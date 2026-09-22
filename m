Received: from mail-wr2-f0.google.com (mail-wr2-f0.google.com [74.125.225.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E9A55C1B7
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Sep 2026 15:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.64
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790090831; cv=none; b=bZDo5tJJod+tiw7STFsHhBdLzl3b/No/Mco7S/69TtYVpeoNCg+SY6bsOO/5utAuIyJTVhaTDpW9FfrcpN2Fs9UqKjWdQUta3q5YoyObfY9c/BvEzctBoUhIM+ZNhzJmHlBfgAGUKsby5ri3dtsFlTZN9PvLG5YOmdTdy85auI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790090831; c=relaxed/simple;
	bh=GfIfs/0EGo/RymnqAeqVdDOWxyk4M7N5a2NnfAHIR8w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bB4Ptmh26yVn2A1469RtxEELZu7dSLPjAILzCYvyPtFmBjQhF2xREMi+flllY9WvIv+G/NCL5QTjsqQr9gixDlSSWeqvUuNq4RH0al2OyWXvbSnyns2eHKwpU4D5QRyhy7bc+TOooOf8XI6Wb37YoUyJbSOQJK2p1htQyQ25qFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ovn.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=74.125.225.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ovn.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr2-f0.google.com with SMTP id ffacd0b85a97d-48861ba835cso11552f8f.1
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Sep 2026 08:27:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790090828; x=1790695628;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KUv0ScJKS33Zn26FXiz9fHEW+C7p6kp+a2yKDonWs4A=;
        b=KXOKzMRUjAjNAXZa6djMeJVy1jorfl36KZEOa245qMLjPUMCFdydSNNODJZ2pRj6X4
         q+gfg/Sg4E9h+uPBse2/MCqn/4kk/TrIewklINEWqmBGscDl9ogFZhplbZr7gNqbmqR4
         MTa7XCyi9AMvmzoK3h0B7MAgow3d7igC8RXGOg8mwRlEPvOPoCX+k0LH4pwB2JoS2K27
         hZzZmNSRbUDJhsJ2z4lEE0kNOfaj1V2/6pJgKt/EQJf82gM2rI5EYNv96ZFLAHYg88En
         ceiUT+xDzsISGYMtyiBJ8R0Gg6BN5jKkGlicBICIUJw7A0/IAYqGE5mODiKvNjUAJ//p
         PZiw==
X-Forwarded-Encrypted: i=1; AKwUvBxTFjxMWwokfxDo+fbwAvSiIi3nDeWPI8rRP1t/+5JKeMcjXHjwAxBTDn3VMb371JM9ezR95Jp3+lxc9bnIX0c=@vger.kernel.org
X-Gm-Message-State: AFuF++nQ63g0HHhetjrTntEqvVcODO8taEXUEPgWCQq28Iild6zDtFZg
	dcGUuk8PkOjVnegp6qdJE94dzO3+tmw2RMKq26aFjIgi/YrK/S5eWE1w
X-Gm-Gg: AYBFou0Av4AESSCSWBjKTfcnkO4MyMDR56c85X1mTjpdTsEGe22bm3oB+/j8XrIgJfR
	t36YIs61nj23m7ldzDffBL7yarV0eXljV1Zs/EqtHkpsktEn0EvoYH5pSlnKfHb0pyvN0Nuyech
	n5fU7iOs+s4BCUfucu2cOd2ikWGNzVu4oXscTYID6qJG1D9zVsSuLbP9RvaIzWkOS+KACK+hmxN
	WSGbYJSZhDHbNaU14QVbT9VtSIKF9Kpznc6vtAOtL2fYq2FcJ+Dn8tUadasP0kEEkS1p7bkqVZ6
	omkrpiHr82XEXOGL0jAiQH1Lpl6OyftulUPckQhv5Pv/6YH2Qi6aViCVfqxZZzQpGgNocur1XP3
	SB9GlF5VqmScK87zGUh1nvHO3L631Vg1KzBfWTISTUTa7qbnRx+d0EeRol5vqa/nYECAYvIlm2R
	2ICLyvCyxUraDtwg1l8BLzzUjrchTZlFIIXXEEHIcfAsQ8IqHfyXBOLpb4PpldqCCAYLPcffC0+
	ZwbfhQAnuO6GSGrDWoylRPlYY0fHqSw6C7n12H141wT4bpecyZnTDhwCw==
X-Received: by 2002:a05:6000:471e:b0:485:8c17:976f with SMTP id ffacd0b85a97d-4871e36e866mr21205182f8f.49.1790090827399;
        Tue, 22 Sep 2026 08:27:07 -0700 (PDT)
Received: from [192.168.88.241] (78-80-107-225.customers.tmcz.cz. [78.80.107.225])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-488627744f5sm6097237f8f.7.2026.09.22.08.27.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2026 08:27:06 -0700 (PDT)
Message-ID: <af1e5328-7e08-4697-b0d6-dc5b77f51530@ovn.org>
Date: Tue, 22 Sep 2026 17:27:04 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net 1/6] net: openvswitch: conntrack: avoid modifying
 shared unconfirmed ct entry
To: netdev-bot+sashiko@kernel.org, i.maximets@ovn.org
Cc: netdev@vger.kernel.org, pablo@netfilter.org, fw@strlen.de, phil@nwl.cc,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, horms@kernel.org, aconole@redhat.com,
 echaudro@redhat.com, jhs@mojatatu.com, jiri@resnulli.us,
 lucien.xin@gmail.com, marcelo.leitner@gmail.com,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 linux-kernel@vger.kernel.org, dev@openvswitch.org, stable@vger.kernel.org
References: <20260921145655.3167436-2-i.maximets@ovn.org>
 <179008911592.2160803.15817354196701627708@kernel.org>
Content-Language: en-US
From: Ilya Maximets <i.maximets@ovn.org>
Autocrypt: addr=i.maximets@ovn.org; keydata=
 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
In-Reply-To: <179008911592.2160803.15817354196701627708@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 9/22/26 4:58 PM, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 0 · Medium: 1 · Low: 1 (1)
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [Medium] New behaviour change introduced by the guard in
>   __ovs_ct_lookup() (net/openvswitch/conntrack.c:741-747): when two skbs…
> - [Low] nf_ct_shared() is added as an undocumented generic predicate in
>   include/net/netfilter/nf_conntrack.h:188-191 returning…
> 
> Pre-existing issues:
> - [Low] Peer call site net/sched/act_ct.c (tcf_ct_act()) performs the
>   same 'cached, unconfirmed ct + commit modifies the extension set'…
> 
> --
> 
> net: openvswitch: conntrack: avoid modifying shared unconfirmed ct entry
> 
> This adds a new nf_ct_shared() helper to the conntrack header and uses it in
> __ovs_ct_lookup() to reset the cached conntrack entry when an skb arrives at
> a committing ct action with an unconfirmed entry that is shared with another
> skb.  The goal is to avoid two clones committing the same unconfirmed entry
> with different extension sets, which can lead to a use-after-free.
> 
> A few questions below.
> 
>> diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
>> index bc42dd0e10e65..c39425e54d87d 100644
>> --- a/include/net/netfilter/nf_conntrack.h
>> +++ b/include/net/netfilter/nf_conntrack.h
>> @@ -185,6 +185,11 @@ static inline void nf_ct_put(struct nf_conn *ct)
>>  		nf_ct_destroy(&ct->ct_general);
>>  }
>>  
>> +static inline bool nf_ct_shared(const struct nf_conn *ct)
>> +{
>> +	return refcount_read(&ct->ct_general.use) > 1;
>> +}
>> +
> 
> [Severity: Low]
> Would it be worth documenting that this predicate is only meaningful for
> unconfirmed, non-template entries?
> 
> The reference accounting comment on struct nf_conn in this same header says
> the count is "1 for hash table, 1 per skb, plus 1 for any connection(s) we
> are `master' for".  With that, every confirmed entry owned by a single skb
> already has use == 2, since __nf_conntrack_confirm() does:
> 
> 	/* The caller holds a reference to this object */
> 	refcount_set(&ct->ct_general.use, 2);
> 
> The same is true for a template in use: nf_ct_tmpl_alloc() sets use = 1 and
> nf_ct_set(skb, tmpl, ...) adds another.  So nf_ct_shared() returns true for
> an ordinary single-owner confirmed entry and for an in-use template, while
> the name reads as "more than one skb owns this ct".

The comments in the callers state the cloned skb as an example, not as a
sole reason for the entry being shared.  "shared" just means there is more
than one reference here.  I can add a comment to the function itself if
someone thinks this is not clear enough, but otherwise I'd keep as is.

> Both consumers at the end of the series check !nf_ct_is_confirmed(ct) first,
> so there is no misbehaviour today, but a future caller without that check
> would get a surprising answer.
> 
> There is also already an open-coded twin of this test in
> nf_ct_drop_unconfirmed() in net/netfilter/nfnetlink_queue.c, which states the
> precondition ("conntrack assumes exclusive skb->_nfct ownership for
> unconfirmed entries") and applies it only after:
> 
> 	if (!ct || nf_ct_is_confirmed(ct))
> 		return false;
> 
> Should that one be converted to the new helper so there is a single
> definition of "shared"?

nfnetlink_queue needs some work on its own and can be cleaned up separately.

> 
> [Severity: Low]
> This isn't a bug introduced by this patch, but the helper lands in the
> shared netfilter header while the equivalent call site in net/sched/act_ct.c
> is left alone here.
> 
> tcf_ct_act() runs the same sequence on a cached unconfirmed entry, adding
> extensions and running helpers:
> 
> 	err = __nf_ct_try_assign_helper(ct, p->tmpl, GFP_ATOMIC);
> 	...
> 	if (p->ct_action & TCA_CT_ACT_NAT && !nfct_seqadj(ct)) {
> 		if (!nfct_seqadj_ext_add(ct))
> 			goto drop;
> 
> tcf_ct_skb_nfct_cached() has no exclusivity test either.
> 
> For what it is worth, the follow-up patch in this series, "net/sched:
> act_ct: avoid modifying shared unconfirmed ct entry", adds the same guard to
> tcf_ct_act() and extends it to the NAT-without-commit case, so the gap is
> closed by the end of the series.  Mentioning that ordering in this changelog
> might help backporters.

Preexisting, fixed later in the set.

> 
>> diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
>> index 0f433688e17b9..a733029c28dd0 100644
>> --- a/net/openvswitch/conntrack.c
>> +++ b/net/openvswitch/conntrack.c
>> @@ -734,6 +734,18 @@ static int __ovs_ct_lookup(struct net *net, struct sw_flow_key *key,
>>  	enum ip_conntrack_info ctinfo;
>>  	struct nf_conn *ct;
>>  
>> +	/* If the ct entry is not confirmed and shared with some other skb,
>> +	 * e.g., a cloned one, we can't just modify it with the commit as we
>> +	 * must not modify the extension set.  Reset.
>> +	 */
>> +	if (cached && info->commit) {
>> +		ct = nf_ct_get(skb, &ctinfo);
>> +		if (ct && !nf_ct_is_confirmed(ct) && nf_ct_shared(ct)) {
>> +			nf_reset_ct(skb);
>> +			cached = false;
>> +		}
>> +	}
>> +
> 
> [Severity: Medium]
> Since the test is a point-in-time refcount snapshot, does it exempt the last
> remaining holder?
> 
> With two skbs sharing one unconfirmed entry and both executing ct(commit) in
> the same zone:
> 
>   - the first one to reach the check sees use == 2, so nf_reset_ct() drops
>     its reference (2 -> 1), nf_conntrack_in() runs again and it commits a
>     brand new entry with the same tuple.
> 
>   - the second holder now sees use == 1, so nf_ct_shared() is false, it
>     keeps the stale unconfirmed entry and commits that.
> 
> __nf_conntrack_confirm() then finds the equal tuple already in
> nf_conntrack_hash and falls into nf_ct_resolve_clash(), where:
> 
> 	l4proto = nf_ct_l4proto_find(nf_ct_protonum(ct));
> 	if (!l4proto->allow_clash)
> 		goto drop;
> 
> For TCP, SCTP and DCCP that returns NF_DROP, and verdict_to_errno(NF_DROP)
> == -EINVAL propagates through ovs_ct_commit() and ovs_ct_execute(), so that
> packet is dropped with OVS_DROP_CONNTRACK.  Before the patch both clones
> were accepted, as the second nf_conntrack_confirm() was a no-op on the
> already confirmed shared entry.
> 
> For UDP and ICMP the clash resolution succeeds, but __nf_ct_resolve_clash()
> discards the losing entry, so the mark and labels the second clone just
> wrote are silently lost.
> 
> The changelog says the reset "doesn't affect any known use cases".  Should
> the drop and the mark/label loss be spelled out there, given both are
> visible consequences for a pipeline that commits two clones into the same
> zone?
> 
> The clone precondition itself comes from __nf_copy() in
> include/linux/skbuff.h, which unconditionally takes a ct reference:
> 
> 	dst->_nfct = src->_nfct;
> 	nf_conntrack_get(skb_nfct(src));
> 
> and skb_nfct_cached() returns true for the surviving clone since it only
> checks netns, zone, helper, timeout and force.
> 

All of that can happen even without cloning.  With or without the changes
applied.  The entry can be created separately and then clash with the one
in the skb causing a drop.  This is expected.  The "use case" is also not
meaningful in practice.

Best regards, Ilya Maximets.
