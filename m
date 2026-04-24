Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C13DF3DD50C
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Apr 2026 14:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777041262; cv=none; b=Ry/eBAefkJbSluaXyamVKEhl8bQvZHuC8EW31VZat6wfyxPFGrGNWG3rgzFY9oeYkHuOE1OtOxkbCMWo4HCNhNzigm1ppHIeRNfhPKp4i8pfnto+JONxHJW6BUd4DO58Gm0Tmsn1RUcXFHzYaSAHEtaZ17eHKgARECSWLsFqAUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777041262; c=relaxed/simple;
	bh=cjY/3NxjXZbrcDBXJpRluVXZQ08PC7LxJX6fMpp78C4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MPnBGi/XPVA4Ox330Pu7DQ3eOqh2CebNX6JteWE9bRYw6/k11vC6FoZlar2v5hZVA3UCTy8SpFBTgTcrRSMHurevtqjmLTKjvdN7DuO5qk+gNz1xsYbkTs3ZXIogDM2yONaEs+1ESg9WNzlk0NoctRQJWMDAK0qIQm1LppZX+/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=gLwxawha; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=LrDGhDy8; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=IVZVsz0g; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=DJpQNxRV; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="gLwxawha";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="LrDGhDy8";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="IVZVsz0g";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="DJpQNxRV"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 866AD6A843;
	Fri, 24 Apr 2026 14:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777041258; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NbQ3pnTY1zwvePkYMdpCtWIXdwnra2zKnM4w3AL9+EU=;
	b=gLwxawhaUVjSxKdXKbyg2Tkf8eJ9E5pVyiRrrKTDhbnleZJXQ3uqVPHcxcaVdhmbjwiiat
	EDSQeEJMB802j3IDqKX2eTI3CLfJNqyf0nPIShdqhPGuZpbo60YqeFSMZ30co953CNMV9k
	QPNhTixW2V9pSyHStpW2mI6wlAs3s0I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777041258;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NbQ3pnTY1zwvePkYMdpCtWIXdwnra2zKnM4w3AL9+EU=;
	b=LrDGhDy8FhOBvscjz9JTU0d5ozOMPeVZq94HM+OkweLHrMknvtrdfKTJKSm9P0fIcxRTBf
	b2YKDNaBNwTv1WBg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=IVZVsz0g;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=DJpQNxRV
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777041257; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NbQ3pnTY1zwvePkYMdpCtWIXdwnra2zKnM4w3AL9+EU=;
	b=IVZVsz0gLjc5lqIa15727VI0azIOjBwGeQq2nUl1KrLslyFC2ORbWH6a3GvjwcuCIjjxkB
	zdKPmvksqQ5ySESBDlp1raROOa4lazQJYATd6x9ry6fp/ZaVhxqW8MZAaBOa6iMepCTHud
	4O1YMY5rDW1JWo8dHfe+Wu3RE79HSvA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777041257;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NbQ3pnTY1zwvePkYMdpCtWIXdwnra2zKnM4w3AL9+EU=;
	b=DJpQNxRVPah2spx631Eozqh9l/YZ/lpv9bveI1gkVAISrZg/sSw1in1jeP2X+/7Ty4V7Ie
	WRmFyslvJhx04GCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 29AE5593A4;
	Fri, 24 Apr 2026 14:34:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YB0yB2l/62lleAAAD6G6ig
	(envelope-from <fmancera@suse.de>); Fri, 24 Apr 2026 14:34:17 +0000
Message-ID: <463e0514-686b-4680-8d84-7cda0dbba121@suse.de>
Date: Fri, 24 Apr 2026 16:33:56 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3 nf v3] netfilter: xtables: fix L4 header parsing for
 non-first fragments
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 ecklm94@gmail.com, phil@nwl.cc, fw@strlen.de
References: <20260421104409.5452-1-fmancera@suse.de>
 <20260421104409.5452-3-fmancera@suse.de> <aetWRt8_AlLabPtm@chamomile>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <aetWRt8_AlLabPtm@chamomile>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-5.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	DWL_DNSWL_LOW(-1.00)[suse.de:dkim];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	MID_RHS_MATCH_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,netfilter.org,gmail.com,nwl.cc,strlen.de];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:mid,suse.de:dkim,suse.de:email];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -5.51
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 866AD6A843

On 4/24/26 1:38 PM, Pablo Neira Ayuso wrote:
> On Tue, Apr 21, 2026 at 12:44:09PM +0200, Fernando Fernandez Mancera wrote:
>> Multiple targets and matches relies on L4 header to operate. For
>> fragmented packets, every fragment carries the transport protocol
>> identifier, but only the first fragment contains the L4 header.
>>
>> As the 'raw' table can be configured to run at priority -450 (before
>> defragmentation at -400), the target/match can be reached before
>> reassembly. In this case, non-first fragments have their payload
>> incorrectly parsed as a TCP/UDP header. This would be of course a
>> misconfiguration scenario. In most of the cases this just lead to a
>> unreliable behavior for fragmented traffic.
>>
>> Add a fragment check to ensure target/match only evaluates unfragmented
>> packets or the first fragment in the stream.
> 

Hi Pablo,

> AI reports xt_hashlimit could be a good candidate to check for
> fragoff, I think it is, so I would suggest to expand it there to cover
> this.
> 

This seems like a good catch. I will work on this.

> It also mentions synproxy as another candidate but IPv6 synproxy does
> not do ipv6_find_hdr() on purpose I think (it assumed nexthdr is TCP)
> for SYN and ACK packets, so checking for fragoff there is not
> possible. Given this is to deal with flood, I think think it is worth
> the fragoff validation.
> 

I don't think it makes sense for SYNPROXY. SYNPROXY requires conntrack 
to work both ipt_SYNPROXY and nft_synproxy and only allows LOCAL_IN and 
FORWARD hooks so it should be fine AFAIU. I don't understand how someone 
could skip defragmentation here.

Maybe something extra to add to ipt_SYNPROXY is a restriction for TCP 
protocol only. As the code currently assumes the transport layer is TCP 
which isn't enforced.

But that would be kind of a different fix. What do you think?

>> Fixes: 902d6a4c2a4f ("netfilter: nf_defrag: Skip defrag if NOTRACK is set")
>> Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
>> ---
>> v2: handled ecn, socket and tcpmss matches
>> v3: extracted socket to its own patch with a generic solution for
>> nft/xt, added a comment specifying that par->fragoff is fine for
>> ecn/tcpmss ipv6 as they enforce -p tcp. Keep on mind that osf only
>> supports ipv4.
>> ---
>>   net/netfilter/xt_TPROXY.c | 11 +++++++++--
>>   net/netfilter/xt_ecn.c    |  4 ++++
>>   net/netfilter/xt_osf.c    |  3 +++
>>   net/netfilter/xt_tcpmss.c |  4 ++++
>>   4 files changed, 20 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/netfilter/xt_TPROXY.c b/net/netfilter/xt_TPROXY.c
>> index e4bea1d346cf..5f60e7298a1e 100644
>> --- a/net/netfilter/xt_TPROXY.c
>> +++ b/net/netfilter/xt_TPROXY.c
>> @@ -86,6 +86,9 @@ tproxy_tg4_v0(struct sk_buff *skb, const struct xt_action_param *par)
>>   {
>>   	const struct xt_tproxy_target_info *tgi = par->targinfo;
>>   
>> +	if (par->fragoff)
>> +		return NF_DROP;
>> +
>>   	return tproxy_tg4(xt_net(par), skb, tgi->laddr, tgi->lport,
>>   			  tgi->mark_mask, tgi->mark_value);
>>   }
>> @@ -95,6 +98,9 @@ tproxy_tg4_v1(struct sk_buff *skb, const struct xt_action_param *par)
>>   {
>>   	const struct xt_tproxy_target_info_v1 *tgi = par->targinfo;
>>   
>> +	if (par->fragoff)
>> +		return NF_DROP;
>> +
>>   	return tproxy_tg4(xt_net(par), skb, tgi->laddr.ip, tgi->lport,
>>   			  tgi->mark_mask, tgi->mark_value);
>>   }
>> @@ -106,6 +112,7 @@ tproxy_tg6_v1(struct sk_buff *skb, const struct xt_action_param *par)
>>   {
>>   	const struct ipv6hdr *iph = ipv6_hdr(skb);
>>   	const struct xt_tproxy_target_info_v1 *tgi = par->targinfo;
>> +	unsigned short fragoff = 0;
>>   	struct udphdr _hdr, *hp;
>>   	struct sock *sk;
>>   	const struct in6_addr *laddr;
>> @@ -113,8 +120,8 @@ tproxy_tg6_v1(struct sk_buff *skb, const struct xt_action_param *par)
>>   	int thoff = 0;
>>   	int tproto;
>>   
>> -	tproto = ipv6_find_hdr(skb, &thoff, -1, NULL, NULL);
>> -	if (tproto < 0)
>> +	tproto = ipv6_find_hdr(skb, &thoff, -1, &fragoff, NULL);
>> +	if (tproto < 0 || fragoff)
>>   		return NF_DROP;
>>   
>>   	hp = skb_header_pointer(skb, thoff, sizeof(_hdr), &_hdr);
>> diff --git a/net/netfilter/xt_ecn.c b/net/netfilter/xt_ecn.c
>> index b96e8203ac54..a8503f5d26bf 100644
>> --- a/net/netfilter/xt_ecn.c
>> +++ b/net/netfilter/xt_ecn.c
>> @@ -30,6 +30,10 @@ static bool match_tcp(const struct sk_buff *skb, struct xt_action_param *par)
>>   	struct tcphdr _tcph;
>>   	const struct tcphdr *th;
>>   
>> +	/* this is fine for IPv6 as ecn_mt_check6() enforces -p tcp */
>> +	if (par->fragoff)
>> +		return false;
>> +
>>   	/* In practice, TCP match does this, so can't fail.  But let's
>>   	 * be good citizens.
>>   	 */
>> diff --git a/net/netfilter/xt_osf.c b/net/netfilter/xt_osf.c
>> index dc9485854002..e8807caede68 100644
>> --- a/net/netfilter/xt_osf.c
>> +++ b/net/netfilter/xt_osf.c
>> @@ -27,6 +27,9 @@
>>   static bool
>>   xt_osf_match_packet(const struct sk_buff *skb, struct xt_action_param *p)
>>   {
>> +	if (p->fragoff)
>> +		return false;
>> +
>>   	return nf_osf_match(skb, xt_family(p), xt_hooknum(p), xt_in(p),
>>   			    xt_out(p), p->matchinfo, xt_net(p), nf_osf_fingers);
>>   }
>> diff --git a/net/netfilter/xt_tcpmss.c b/net/netfilter/xt_tcpmss.c
>> index 0d32d4841cb3..b9da8269161d 100644
>> --- a/net/netfilter/xt_tcpmss.c
>> +++ b/net/netfilter/xt_tcpmss.c
>> @@ -32,6 +32,10 @@ tcpmss_mt(const struct sk_buff *skb, struct xt_action_param *par)
>>   	u8 _opt[15 * 4 - sizeof(_tcph)];
>>   	unsigned int i, optlen;
>>   
>> +	/* this is fine for IPv6 as xt_tcpmss enforces -p tcp */
>> +	if (par->fragoff)
>> +		return false;
>> +
>>   	/* If we don't have the whole header, drop packet. */
>>   	th = skb_header_pointer(skb, par->thoff, sizeof(_tcph), &_tcph);
>>   	if (th == NULL)
>> -- 
>> 2.53.0
>>
> 

