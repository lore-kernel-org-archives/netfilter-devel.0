Received: from mail-wr2-f10.google.com (mail-wr2-f10.google.com [74.125.225.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51CD753A385
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Sep 2026 15:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790092337; cv=none; b=GocorH305BpOkrN5+Wd/i3pgPinO05MhzQFCa+Yca/04DEOMARtgqtTrZ3lfx9MYC10QV6KoEIgMaSfuOgF25LqjwOn31+2lsXQJ3kbKoDurFNDi9J2+/TQVOBBbBOYiXBmZnrWX8Y9s2d0lsQvkn2SIslqIWARwNEq/q+zqFRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790092337; c=relaxed/simple;
	bh=t2BkDoPXJqVAxcWBUrhg4hh5+X8J1TmxXzpE9rjW0Tg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=grI+zMQTwid1d/DfWlyXLjegs7VCZUHRWzsDetqtTxwWXcP/DeKl2ZFEBZxZY9f17UEWnwHGCgJqbFVojz1kd1qM4FFHKhih81A9GoLw5+M/QNB5wWbeChNO+SFCrAZUPYX5kzseDw7dzVNGSgg3kkiQcvhMv1ecUXbakNfY70E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ovn.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=74.125.225.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ovn.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr2-f10.google.com with SMTP id ffacd0b85a97d-484373a2e82so45959f8f.0
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Sep 2026 08:52:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790092333; x=1790697133;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5i9r/pPIqKuMdr6zdOQlfdPCoyhibMvQVpWDyWeclbw=;
        b=ly+YJSfqe3DYH7hFsNpe8iA2AZAkMN5hT8RX5Kk8Cdz1oWmf4gm8496Hd1cJV+977B
         2VoHFJjd31PMs5LlwsfnxTFVMzj+X1KAmP4zGeidaEqzbwBRGCZ0am3dxrtufir/KBKN
         50uH7oXfS+29NyQj2h3Jt/wcXTopNWIgDTZQKd8+jWwiqUUEyXNokNfkfWTfytNdozKo
         ZK3Tvbe+bfLQLf3j8klSPxJMNS/wURACTaAkxCJ95Ewq9eaXLBA4+k/89+v6kJghWNtj
         1fX/Xj9bpFvc3x/nCDH+22D013YFaK1rejFGC/XTqCtVG/U+dBEHL5uot0lj9ajdd4Vw
         npHA==
X-Forwarded-Encrypted: i=1; AKwUvBxyL+5znTfbgm9TEFgN1ZznXtvhDv8vqsOSJHs+g83aTfwFZtWcfcTqBeHc5bFgj6PW6mdjmYnftDUbh3y9f8g=@vger.kernel.org
X-Gm-Message-State: AFuF++lemItHRpb3UJDWS3K67lT1P2kZKpWM+oRsyavMj2YBWYjGvilq
	asEgf2T1Et61F8MSgcAhUnrMHXoTLn/t9eCPICs3M0okPD+lEMUf+EBr
X-Gm-Gg: AYBFou3fEXmYnklbXg/82qCsLIHLZOD8FyWOaiJ0OwUnJwR1gAy0/WGhdt+PEpMhJNZ
	pEHtSv15Cqzrv4MzUldWruuCsdyqVXhmmU9zX+NJN6q8cqfNrk7Prz1dInNP69sNi+lW6irfW+I
	18GilPaCkltmMXGeqYVu0Hh4X5LGVJkny0HAowTba6soJQTFverVOlwoafQWNZrA/kNDthq8bKp
	zWivNbUNoVghzvXifZcw98mio5TGp92AIyeYgMYeZsAwMq73/HCnkfEy/K7cZ9tkbhOIj4ixxiy
	C1ASLmnkI2FH9H6DOT+NIrdGquY2h3aCfuH2i7KapXeYtlg3AogkrTwUmQ9jHaFeTYe99fZnKLC
	7mew7ux/aZdx1lYCdumnI5mzwbTn73IwUZ1rLXxMGMVB4vz+JNEhKwQpyLCZkzuFWAe2EY2vsXl
	7lB6IiUABYVTfcSil5y7o/efiPjv+9L8pj1p51e/AQoC1Bi/yLTWHSz3l12nGAwlHxFX6DuuVnn
	Ii4ltzgWl2+AcbEqZBJ/VNksvXvCvSU1XZZ9iCvqYvCITM=
X-Received: by 2002:a05:6000:41de:b0:487:a9f:4fa5 with SMTP id ffacd0b85a97d-4886705fc4cmr48898f8f.4.1790092333223;
        Tue, 22 Sep 2026 08:52:13 -0700 (PDT)
Received: from [192.168.88.241] (78-80-107-225.customers.tmcz.cz. [78.80.107.225])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4886277e185sm6166579f8f.16.2026.09.22.08.52.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2026 08:52:12 -0700 (PDT)
Message-ID: <dbffdb43-4fe8-4072-82ba-fcd19aec8739@ovn.org>
Date: Tue, 22 Sep 2026 17:52:11 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net 4/6] net/sched: act_ct: avoid modifying shared
 unconfirmed ct entry
To: netdev-bot+sashiko@kernel.org, i.maximets@ovn.org
Cc: netdev@vger.kernel.org, pablo@netfilter.org, fw@strlen.de, phil@nwl.cc,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, horms@kernel.org, aconole@redhat.com,
 echaudro@redhat.com, jhs@mojatatu.com, jiri@resnulli.us,
 lucien.xin@gmail.com, marcelo.leitner@gmail.com,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 linux-kernel@vger.kernel.org, dev@openvswitch.org, stable@vger.kernel.org
References: <20260921145655.3167436-5-i.maximets@ovn.org>
 <179008912095.2160803.9187949237353089190@kernel.org>
Content-Language: en-US
From: Ilya Maximets <i.maximets@ovn.org>
Autocrypt: addr=i.maximets@ovn.org; keydata=
 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
In-Reply-To: <179008912095.2160803.9187949237353089190@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 9/22/26 4:58 PM, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 0 · Medium: 1 (1) · Low: 0
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [Medium] tcf_ct_act() now discards an unconfirmed conntrack entry
>   purely because its refcount is >1, without checking whether the…
> 
> Pre-existing issues:
> - [Medium] At this commit, tcf_ct_act() still calls nf_ct_helper()
>   (net/sched/act_ct.c:1106) before the commit block that grows the…
> 
> --
> 
> net/sched: act_ct: avoid modifying shared unconfirmed ct entry
> 
> tcf_ct_act() now resets the skb conntrack association when the cached entry
> is unconfirmed and its refcount shows it is shared with another skb, so that
> a commit or nat pass cannot grow the extension area of an entry another
> clone still points into.  The nat flag is also hoisted into a local
> variable.
> 
>> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
>> index 55f3521edb4c9..e72143d36b119 100644
>> --- a/net/sched/act_ct.c
>> +++ b/net/sched/act_ct.c
> 
> [ ... ]
> 
>> @@ -998,6 +998,7 @@ TC_INDIRECT_SCOPE int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
>>  	retval = p->action;
>>  	commit = p->ct_action & TCA_CT_ACT_COMMIT;
>>  	clear = p->ct_action & TCA_CT_ACT_CLEAR;
>> +	nat = p->ct_action & TCA_CT_ACT_NAT;
>>  	tmpl = p->tmpl;
>>  
>>  	tcf_lastuse_update(&c->tcf_tm);
>> @@ -1046,6 +1047,19 @@ TC_INDIRECT_SCOPE int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
>>  	 * different zone.
>>  	 */
>>  	cached = tcf_ct_skb_nfct_cached(net, skb, p);
>> +
>> +	/* If the ct entry is not confirmed and shared with some other skb,
>> +	 * e.g., a cloned one, we can't just modify it with a commit or nat
>> +	 * as we must not modify the extension set.  Reset.
>> +	 */
>> +	if (cached && (commit || nat)) {
>> +		ct = nf_ct_get(skb, &ctinfo);
>> +		if (ct && !nf_ct_is_confirmed(ct) && nf_ct_shared(ct)) {
>> +			nf_reset_ct(skb);
>> +			cached = false;
>> +		}
>> +	}
>> +
> 
> [Severity: Medium]
> Can this drop NAT state that was already applied to the packet?
> 
> The condition keys off nf_ct_shared(ct), i.e. refcount > 1, and not off
> whether the sharing skb will ever be re-processed by conntrack.  act_ct
> permits nat without commit, and in that case
> tcf_ct_act_nat()->nf_ct_nat() (net/netfilter/nf_nat_ovs.c) already
> installs the binding and translates the headers on the unconfirmed entry:
> 
> net/netfilter/nf_nat_ovs.c:nf_ct_nat() {
> 	...
> 	/* Add NAT extension if not confirmed yet. */
> 	if (!nf_ct_is_confirmed(ct) && !nf_ct_nat_ext_add(ct))
> 		return NF_DROP;   /* Can't NAT. */
> 	...
> 	err = nf_ct_nat_execute(skb, ct, ctinfo, action, range, maniptype);
> }
> 
> If the skb is then cloned by a path that keeps the nfct reference, and a
> later filter runs "action ct zone N commit" on the original, the new block
> sees cached && commit with an unconfirmed, shared entry, calls
> nf_reset_ct(skb) and sets cached = false.  nf_conntrack_in() then re-tracks
> the already translated packet, so the entry that gets committed carries the
> post-NAT tuple as its ORIGINAL tuple and no matching binding, and reply
> traffic is no longer reverse translated.  Before this change the cached,
> NAT'ed unconfirmed entry was simply committed.

It's true that some information will be lost on reset, but it is expected.
The described sequence of events should also not happen in a practical
networking pipeline.  Alternative is to forbid nat without commit, which
would be a significant uAPI break.

> 
> One note on the trigger: act_mirred and AF_PACKET taps do not produce this
> sharing, since both clear the association on the clone:
> 
> net/sched/act_mirred.c:tcf_mirred_to_dev() {
> 	/* All mirred/redirected skbs should clear previous ct info */
> 	nf_reset_ct(skb_to_send);
> }
> 
> net/packet/af_packet.c:packet_rcv() {
> 	/* drop conntrack reference */
> 	nf_reset_ct(skb);
> }
> 
> Bridge flood/multicast delivery does keep it, though -
> net/bridge/br_forward.c:deliver_clone() calls skb_clone() with no
> nf_reset_ct(), so __nf_copy() raises ct_general.use on the clone.
> 
> Would it be worth mentioning in the changelog that the reset also fires
> when the second pass does commit?  The changelog currently only argues
> about the "without commit" case:
> 
>     This, however, doesn't really change the picture for sensible
>     networking cases as there should be no need to run the same packet
>     twice (before and after the clone) through conntrack without packet
>     header or zone changes and without commit.

Flood cases will be addressed separately, there is no need to spell out
every single thing.

> 
> [Severity: Medium]
> This is a pre-existing ordering problem and is not introduced by this
> patch, but it is worth flagging for backports since the new guard does not
> cover it.
> 
> At this commit tcf_ct_act() still runs the helper before the commit block
> grows the extension area of an unconfirmed entry:
> 
> net/sched/act_ct.c:tcf_ct_act() {
> 	...
> 	if (nf_ct_is_confirmed(ct) ? ((!cached && !skip_add) || add_helper) : commit) {
> 		err = nf_ct_helper(skb, ct, ctinfo, family);
> 		if (err != NF_ACCEPT)
> 			goto nf_error;
> 	}
> 
> 	if (commit) {
> 		tcf_ct_act_set_mark(ct, p->mark, p->mark_mask);
> 		tcf_ct_act_set_labels(ct, p->labels, p->labels_mask);
> 
> 		if (!nf_ct_is_confirmed(ct))
> 			nf_conn_act_ct_ext_add(skb, ct, ctinfo);
> 	...
> }
> 
> A helper that inserts an expectation links exp->lnode into a list head that
> lives inside ct->ext:
> 
> net/netfilter/nf_conntrack_expect.c:nf_ct_expect_insert() {
> 	hlist_add_head_rcu(&exp->lnode, &master_help->expectations);
> }
> 
> and the following nf_ct_ext_add(NF_CT_EXT_ACT_CT) relocates that memory:
> 
> net/netfilter/nf_conntrack_extend.c:nf_ct_ext_add() {
> 	new = krealloc(old, alloc, gfp);
> }
> 
> leaving exp->lnode.pprev pointing into the freed block, which is written
> through when the expectation is unlinked via nf_ct_remove_expectations().
> 
> The new reset only fires for cached entries with refcount > 1, so an entry
> that was just tracked (cached == false), or the replacement entry created
> after the reset, still follows the helper-then-realloc sequence with a
> single skb reference.
> 
> The later patch in this series ("net/sched: act_ct: fix helper UAF due to
> extensions realloc") moves nf_ct_helper() after the
> nf_conn_act_ct_ext_add() block with the comment "This has to be done after
> all the extensions are already added.", so the ordering is resolved within
> the series.  Given the stable tag here, should the two patches be marked so
> that backporters take the reordering change together with this one?
Preexisting.  Fixed later in the set.

Best regards, Ilya Maximets.
