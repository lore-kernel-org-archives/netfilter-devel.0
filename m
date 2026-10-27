Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793143095;
	b=xZKY3XQDtPVgGWGgUfdeG1zirq/+O5UANMhsOT6YR5t5+RY4FCn7smOU0y8bmOgNApPe
	 y33+lB/d+dGGLJLHOeyRP9joC6nk6qGg+pY+T/aSrhajN+XD6ikUrprP+qcSEPAqtHyUY
	 nvlKlNeErXoIZsAX2xJgXrSIfN3x3D1xkuCTQPCkJLWdr+JvH0CsLpqQ9EWsjjPCC25Dr
	 EgGzZQC1zdmuQzH1lAKyNJqbaQidA0/937AsegStyY1Lfk+DabHISHq0QmBd7AvPNYmRy
	 21syGkXBsOHtPkXhxDxPOU5sfc6S1fz419PxH+KLU9B6SRXrRMU1z0dTET5wLdYVzIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793143095;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Spam-Flag:X-Spam-Level:
	 X-Spamd-Result:X-Spam-Score;
	bh=acE5Ncigevem1rvJq34AhEgWIwa6Afk3YbaUSBaIe5I=;
	b=QmWK3QHwrpzkmCO1yq2hErGJ00C+ccu81Vm+5ho86D6dlWcYMjsY7ZNIh9gb+1osw6Jh
	 +SvC88oky82cmnt0lDUO8yPrK3fvYhux3kmkCByOmBxqI2V7Tf1/muNrHKfMpeY5fbsvD
	 k3hWb4H+fYHyL7ZaR/Cr5DiUv1pOw3PR5DlnYNkFDOym6rC7VXEih6Wxs1UHZhTHoGXaB
	 sHZ0QzxtB8J0miCalRMw1XKL2m505xc5Ld4es4B8fjtdcUYsHwwQyzao2m/KgorJMVq6o
	 lgjqOc0BK/NK/E0WCOiVqJhCNKpv2TD3eOwnWHWsb4Y95l2ct19wi2BgBNU+b406gDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=1vXmWIPG;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=glRQ1Ugo;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=1vXmWIPG;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=glRQ1Ugo;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C931606A31D;
	Tue, 27 Oct 2026 23:18:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3C931606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=1vXmWIPG;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=glRQ1Ugo;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=1vXmWIPG;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=glRQ1Ugo
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 28B141F8C1;
	Tue, 27 Oct 2026 23:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793143092; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=acE5Ncigevem1rvJq34AhEgWIwa6Afk3YbaUSBaIe5I=;
	b=1vXmWIPGn/A+uMdyRB5jtvVwkHCR/bSNXPUMQPAAULkqOxFte5XQV5xhruOCUFlI/X9R9e
	xKXX+fJ2WAb12k5KuLpYm8wVNFNff9cWJkG/y2NVct8wz4IinMWLgii1KKY9H54dE03J2B
	smTJmFgmQPdihllFPJRS/UKNTjwpFGY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793143092;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=acE5Ncigevem1rvJq34AhEgWIwa6Afk3YbaUSBaIe5I=;
	b=glRQ1Ugow14LgE78ux1AwddcxidrJ4A2IFS2C2HMdrymxmQti+ct7i7FyzZUtZgy3XKBb+
	nkFuG+rn6P06+TDw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793143092; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=acE5Ncigevem1rvJq34AhEgWIwa6Afk3YbaUSBaIe5I=;
	b=1vXmWIPGn/A+uMdyRB5jtvVwkHCR/bSNXPUMQPAAULkqOxFte5XQV5xhruOCUFlI/X9R9e
	xKXX+fJ2WAb12k5KuLpYm8wVNFNff9cWJkG/y2NVct8wz4IinMWLgii1KKY9H54dE03J2B
	smTJmFgmQPdihllFPJRS/UKNTjwpFGY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793143092;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=acE5Ncigevem1rvJq34AhEgWIwa6Afk3YbaUSBaIe5I=;
	b=glRQ1Ugow14LgE78ux1AwddcxidrJ4A2IFS2C2HMdrymxmQti+ct7i7FyzZUtZgy3XKBb+
	nkFuG+rn6P06+TDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 84E741321C;
	Tue, 27 Oct 2026 23:18:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Cka5FTMx4WoZJgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 27 Oct 2026 23:18:11 +0000
Message-ID: <17a53ec0-7493-4f60-97b0-da6012412056@suse.de>
Date: Wed, 28 Oct 2026 00:16:55 +0100
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf] netfilter: nf_nat: do not link a conntrack twice into
 nat_bysource
To: Vimal Agrawal <avimalin@gmail.com>, netfilter-devel@vger.kernel.org,
 pablo@netfilter.org, Florian Westphal <fw@strlen.de>
Cc: phil@nwl.cc, coreteam@netfilter.org, netdev@vger.kernel.org,
 Anirudh Gupta <anirudh.gupta@sophos.com>,
 Vimal Agrawal <vimal.agrawal@sophos.com>
References: <20261022105943.4003353-1-vimal.agrawal@sophos.com>
 <CALkUMdSvyg9eOUfsZPy-uvtwdednnavtX3k8BU4mbxYzkr5NhA@mail.gmail.com>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <CALkUMdSvyg9eOUfsZPy-uvtwdednnavtX3k8BU4mbxYzkr5NhA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-13.29 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org,netfilter.org,strlen.de];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -13.29

On 10/27/26 7:56 AM, Vimal Agrawal wrote:
> Hi Florian,
> 
> Can you please review this patch?
> 

We are all a bit overwhelmed with submissions and this kind of pings 
does not help IMHO.

> Vimal
> 
> On Thu, Oct 22, 2026 at 4:32 PM Vimal Agrawal <avimalin@gmail.com> wrote:
>>
>> From: Vimal Agrawal <vimal.agrawal@sophos.com>
>>
>> nf_nat_setup_info() assumes it owns an unconfirmed conntrack, but the
>> clones made by br_flood() share one (skb_clone() only takes a
>> reference). That is safe while they are handled one after another on
>> the same CPU. If one clone is sent to NFQUEUE and another is not, the
>> queued one is reinjected later from process context by nf_reinject()
>> (BH enabled, any CPU) and can run NAT concurrently with the other.
>>
>> Both callers can then reach hlist_add_head_rcu(&ct->nat_bysource, ...).
>> Linking a node twice makes it point to itself, so a walk of that bucket
>> never ends. Also, "ct->status |= IPS_SRC_NAT" is a plain
>> read-modify-write outside nf_nat_locks[]; it can erase a concurrently
>> set IPS_SRC_NAT_DONE, and nf_nat_cleanup_conntrack() then leaves the
>> node of a freed conntrack in the bucket.
>>
>> We hit this on 6.6.49 (tainted, out-of-tree modules) as a general
>> protection fault in the bucket walk, from a packet reinjected from
>> NFQUEUE:
>>
>>    general protection fault, probably for non-canonical address
>>    0xabeb549edb10a8d4: 0000 [#1] SMP NOPTI
>>    RIP: 0010:nf_nat_setup_info+0x8b6/0xba0 [nf_nat]
>>     nf_nat_masquerade_ipv4+0x11d/0x200 [nf_nat]
>>     ipt_do_table+0x2b9/0x410 [ip_tables]
>>     nf_nat_inet_fn+0x14f/0x260 [nf_nat]
>>     nf_nat_ipv4_out+0x4d/0xe0 [nf_nat]
>>     nf_reinject+0x177/0x1d0
>>     ...
>>

Do you happen to have a reproducer that could trigger this on a 
non-tainted kernel? I would like to reproduce this to verify what is 
going on.

The idea is sounds but I would like to understand the problem better and 
if possible add a fixes tag.

Thanks,
Fernando.

>> Use set_bit() for IPS_SRC_NAT/IPS_DST_NAT. Test IPS_SRC_NAT_DONE under
>> nf_nat_locks[] before linking and set it only after the node is
>> linked. A losing caller returns NF_ACCEPT, as before, without linking
>> again. The early nf_nat_initialized() check is unchanged, and two
>> callers that both create a real mapping are not covered.
>>
>> Link: https://lore.kernel.org/netfilter-devel/CALkUMdQ_6aU8Sy8vTORReQ2=vr4TskbkhZQt3WRazwUMTNEOtg@mail.gmail.com/
>> Signed-off-by: Vimal Agrawal <vimal.agrawal@sophos.com>
>> Reviewed-by: Anirudh Gupta <anirudh.gupta@sophos.com>
>> ---
>>   net/netfilter/nf_nat_core.c | 41 +++++++++++++++++++++++++++++--------
>>   1 file changed, 32 insertions(+), 9 deletions(-)
>>
>> diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
>> index cc8e1e81006d..3a89c894a520 100644
>> --- a/net/netfilter/nf_nat_core.c
>> +++ b/net/netfilter/nf_nat_core.c
>> @@ -791,11 +791,14 @@ nf_nat_setup_info(struct nf_conn *ct,
>>                  nf_ct_invert_tuple(&reply, &new_tuple);
>>                  nf_conntrack_alter_reply(ct, &reply);
>>
>> -               /* Non-atomic: we own this at the moment. */
>> +               /* Atomic: a concurrent caller on the same unconfirmed ct may
>> +                * set IPS_SRC_NAT_DONE (set_bit() below) at the same
>> +                * time, and a plain read-modify-write here could erase it.
>> +                */
>>                  if (maniptype == NF_NAT_MANIP_SRC)
>> -                       ct->status |= IPS_SRC_NAT;
>> +                       set_bit(IPS_SRC_NAT_BIT, &ct->status);
>>                  else
>> -                       ct->status |= IPS_DST_NAT;
>> +                       set_bit(IPS_DST_NAT_BIT, &ct->status);
>>
>>                  if (nfct_help(ct) && !nfct_seqadj(ct))
>>                          if (!nfct_seqadj_ext_add(ct))
>> @@ -806,21 +809,41 @@ nf_nat_setup_info(struct nf_conn *ct,
>>                  unsigned int srchash;
>>                  spinlock_t *lock;
>>
>> +               /* Concurrent callers can reach here for the same,
>> +                * still-unconfirmed ct (skb_clone()/GSO segmentation/
>> +                * nf_ct_attach() can share one ct across skbs processed on
>> +                * different CPUs before it is confirmed). The DONE bit is
>> +                * tested and set under this lock, and only after the node is
>> +                * linked, so a set bit always means the node is in the hash
>> +                * (nf_nat_cleanup_conntrack() relies on that). Only the first
>> +                * caller links the node; a losing caller does not link it
>> +                * again, which would corrupt the list.
>> +                *
>> +                * The winner sets the mapping (ct->status/reply tuple) before
>> +                * taking this lock, so it is final once the DONE bit is seen.
>> +                * The loser's packet is therefore accepted: nf_nat_packet()
>> +                * applies the winner's mapping to it. This is the common case
>> +                * for bridge-flooded broadcasts (e.g. DHCP) racing with a
>> +                * packet reinjected from NFQUEUE (nf_reinject() runs the
>> +                * remaining hooks with BH enabled), where the mapping is an
>> +                * identity null binding on both sides.
>> +                */
>>                  srchash = hash_by_src(net, nf_ct_zone(ct),
>>                                        &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
>>                  lock = &nf_nat_locks[srchash % CONNTRACK_LOCKS];
>>                  spin_lock_bh(lock);
>> +               if (test_bit(IPS_SRC_NAT_DONE_BIT, &ct->status)) {
>> +                       spin_unlock_bh(lock);
>> +                       return NF_ACCEPT;
>> +               }
>>                  hlist_add_head_rcu(&ct->nat_bysource,
>>                                     &nf_nat_bysource[srchash]);
>> +               set_bit(IPS_SRC_NAT_DONE_BIT, &ct->status);
>>                  spin_unlock_bh(lock);
>> +       } else {
>> +               set_bit(IPS_DST_NAT_DONE_BIT, &ct->status);
>>          }
>>
>> -       /* It's done. */
>> -       if (maniptype == NF_NAT_MANIP_DST)
>> -               ct->status |= IPS_DST_NAT_DONE;
>> -       else
>> -               ct->status |= IPS_SRC_NAT_DONE;
>> -
>>          return NF_ACCEPT;
>>   }
>>   EXPORT_SYMBOL(nf_nat_setup_info);
>> --
>> 2.43.0
>>
> 

