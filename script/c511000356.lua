--Duality
function c511000356.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c511000356.cost)
	e1:SetTarget(c511000356.target)
	e1:SetOperation(c511000356.operation)
	c:RegisterEffect(e1)
end
function c511000356.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c511000356.cfilter(c,e,tp,ft)
	local att=0
	if c:IsAttribute(ATTRIBUTE_LIGHT) then att=att|ATTRIBUTE_DARK end
	if c:IsAttribute(ATTRIBUTE_DARK) then att=att|ATTRIBUTE_LIGHT end
	return (ft>0 or (c:IsControler(tp) and c:GetSequence()<5)) and (c:IsControler(tp) or c:IsFaceup()) 
		and Duel.IsExistingMatchingCard(c511000356.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp,att)
end
function c511000356.spfilter(c,e,tp,att)
	return c:IsAttribute(att) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c511000356.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return ft>-1 and Duel.CheckReleaseGroup(tp,c511000356.cfilter,1,nil,e,tp,ft)
	end
	local g=Duel.SelectReleaseGroup(tp,c511000356.cfilter,1,1,nil,e,tp)
	local att=0
	if g:GetFirst():IsAttribute(ATTRIBUTE_LIGHT) then att=att|ATTRIBUTE_DARK end
	if g:GetFirst():IsAttribute(ATTRIBUTE_DARK) then att=att|ATTRIBUTE_LIGHT end
	Duel.Release(g,REASON_COST)
	Duel.SetTargetParam(att)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c511000356.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c511000356.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,ac)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end