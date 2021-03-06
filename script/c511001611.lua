--Numbers Evaille
--Rescripted by edo9300
function c511001611.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511001611.target)
	e1:SetOperation(c511001611.activate)
	c:RegisterEffect(e1)
end
function c511001611.filter(c,mg)
	if not c:IsSetCard(0x48) or not c:IsType(TYPE_XYZ) or not c.xyz_number then return false end
	if c.xyz_number==0 then 
		return mg:IsExists(function(c)return c.xyz_number==0 end,1,c)
	else
		return (mg-c):CheckWithSumEqual(function(c)return c.xyz_number end,c.xyz_number,1,99999)
	end
end
function c511001611.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local pg=aux.GetMustBeMaterialGroup(tp,Group.CreateGroup(),tp,nil,nil,REASON_XYZ)
		local mg=Duel.GetMatchingGroup(function(c) return c.xyz_number end,tp,LOCATION_EXTRA,0,nil)
		if #(pg-mg)>0 then return false end
		return Duel.IsExistingMatchingCard(c511001611.filter,tp,LOCATION_EXTRA,0,1,nil,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_EXTRA)
end
function c511001611.checkvalid(c,mg,sg,mg0,cc)
	Duel.SetSelectedCard((sg+cc)-mg0)
	return (mg-c):CheckWithSumEqual(function(c)return c.xyz_number end,c.xyz_number,0,99999)
end
function c511001611.activate(e,tp,eg,ep,ev,re,r,rp)
	local pg=aux.GetMustBeMaterialGroup(tp,Group.CreateGroup(),tp,nil,nil,REASON_XYZ)
	local mg,mg0=Duel.GetMatchingGroup(function(c) return c.xyz_number end,tp,LOCATION_EXTRA,0,nil):Split(function(c)return c.xyz_number>0 end,nil)
	if #(pg-(mg+mg0))>0 then return false end
	local mat=Group.CreateGroup()
	while true do
		local cg=mg:Filter(function(c,mg,sg)
			return mg:IsExists(c511001611.checkvalid,1,c+sg,mg,sg,mg0,c)
		end,mat,mg,mat)+(mg0-mat)
		if #cg==0 then break end
		local cancel = ((mg0:Includes(mat) and #(mg0-mat)>0) or mg:IsExists(function(c,mg,sg)
			Duel.SetSelectedCard(sg-mg0)
			return sg:CheckWithSumEqual(function(c)return c.xyz_number end,c.xyz_number,0,0)
		end,1,mat,mg,mat)) and #mat>0
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local tc=cg:SelectUnselect(mat,tp,cancel,cancel)
		if not tc then break end
		if mat:IsContains(tc) then
			mat=mat-tc
		else
			mat=mat+tc
		end
	end
	local spc
	if mg0:Includes(mat) and #(mg0-mat)>0 then
		spc=mg0:Select(tp,1,1,mat):GetFirst()
	else
		spc=mg:FilterSelect(tp,function(c,mat)
			Duel.SetSelectedCard(mat-mg0)
			return Group.CreateGroup():CheckWithSumEqual(function(c)return c.xyz_number end,c.xyz_number,0,0)
		end,1,1,mat,mat):GetFirst()
	end
	if spc and Duel.SpecialSummon(spc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.Overlay(spc,mat)
		spc:CompleteProcedure()
	end
end
