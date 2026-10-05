Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EF05374E64;
	Mon,  5 Oct 2026 12:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791202279; cv=none; b=q4jxeXM4f3JhAwOvS7PxoQaJ+7mSGU4o6rVCKxCTVlLLipaIHiL9ozjSKfSLTMPNzSmGneRM3URNmVmaDJD7Dc+BwDHgfL/WZ56JaaBBTiUqYq3jDZndx3H63MnNKVZPBO4LQbAk5s+EeACos0yuwu3NGREgM/n/W6NPR+VgzX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791202279; c=relaxed/simple;
	bh=NMNSe3FkVICodJODLNmb6qjWWEtDYnXT0FQbdSuT1As=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uGhk9A9/8/hotLIwKWlufAb5njxyWaAMmsZeXcx1XTS/gfABeyv6cc/BFzFU7bIP4PqgOhuy81zPeyt08tKwzAW9sXanROssu83Pj/L8BjDVOi5oAKVSUCL+IwsvpBcf7FOvrXDUkOAKMz+tx3gIHYbeDG7U4UjgBCh0OqmBC4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ik4USNNm; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=gf4VmEZA; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Kn7WDEnh; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=T7zxEmgb; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ik4USNNm";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="gf4VmEZA";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Kn7WDEnh";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="T7zxEmgb"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B6DB21F453;
	Mon,  5 Oct 2026 12:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791202271; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UgjgUIqUXrg+EmvIXZhJUXz5k9rmyxilEYl1OB1+7V8=;
	b=ik4USNNmK+n9A++JQnnoX3Hz5lwWSOaG50x95D7B/RH40zLOcXnPeNi2AvRYX+izD8z63V
	K86g8UlIra9NBP6IrOmWk3XFVFrcCBhPfGeHG2vTQXA/N1QuYlGwHY374/DyN6y/N9mm/y
	q1Hvp3FP58voky8LUsxRgxZ9t1OEIjI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791202271;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UgjgUIqUXrg+EmvIXZhJUXz5k9rmyxilEYl1OB1+7V8=;
	b=gf4VmEZASS7PbFVF91RYbmofEgwcscJ9lQdRNXlH8FWxu9u1galIC0tn2uZAc3tzGyZWdr
	zpiRdolC2H52kWAg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791202267; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UgjgUIqUXrg+EmvIXZhJUXz5k9rmyxilEYl1OB1+7V8=;
	b=Kn7WDEnhbd2e1zHJMM9KDoy07nnKPZC6lJOVBWQ3P33gdrskcGGHnHLaDLcz9NkNIRpWdK
	8Cd7NqfNxPxSKKh/iY1tcs+dFKu+r1X7jvAIJIwne2W6hRul5T51X1x7N5/vwdCkpvVSof
	siVqZolmZ9j+Q9l1wSbQgl3RUm8QcMs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791202267;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UgjgUIqUXrg+EmvIXZhJUXz5k9rmyxilEYl1OB1+7V8=;
	b=T7zxEmgbiD4WEJY66TGQy1rF3j67NkL6lG+sBhiTxXMqrpumnonyKDIeXSZwnxjPNj0K09
	zXGSZcyrORSJYrAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E1704132D3;
	Mon,  5 Oct 2026 12:11:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1C9OLNqTw2qYGAAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 05 Oct 2026 12:11:06 +0000
Message-ID: <bea33147-1a2e-4fba-93ac-7521dd7b6556@suse.de>
Date: Mon, 5 Oct 2026 14:09:56 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf-next] netfilter: nf_nat: replace u_int16_t with u16
To: Carlos Grillet <carlos@carlosgrillet.me>,
 Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
 Phil Sutter <phil@nwl.cc>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20261002201057.132466-1-carlos@carlosgrillet.me>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20261002201057.132466-1-carlos@carlosgrillet.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 

On 10/2/26 10:10 PM, Carlos Grillet wrote:
> Use the preferred kernel type u16 instead of the POSIX u_int16_t
> variant across the NAT helpers.
> 
> No functional change.
> 
> Signed-off-by: Carlos Grillet <carlos@carlosgrillet.me>
> ---
> This supersedes the nf_nat_amanda one-liner from batch 3, which was
> dropped in favour of a larger changeset:
> 
>    https://lore.kernel.org/netfilter-devel/ak5lH1UnFth6oreP@strlen.de/
> 
> nf_nat is now converted in one patch, as suggested. The remaining
> families (nfnetlink, nf_log, x_tables, ...) will follow the same way.

Hi Carlos,

given that this is a mechanical change that is not a risk, can they all 
be handled in a single patch for the netfilter subsystem?

Thanks,
Fernando.

> 
>   include/linux/netfilter/nf_conntrack_sip.h |  2 +-
>   net/ipv4/netfilter/nf_nat_h323.c           | 10 +++++-----
>   net/ipv4/netfilter/nf_nat_pptp.c           |  4 ++--
>   net/netfilter/nf_nat_amanda.c              |  2 +-
>   net/netfilter/nf_nat_ftp.c                 |  2 +-
>   net/netfilter/nf_nat_irc.c                 |  2 +-
>   net/netfilter/nf_nat_sip.c                 |  6 +++---
>   7 files changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/include/linux/netfilter/nf_conntrack_sip.h b/include/linux/netfilter/nf_conntrack_sip.h
> index aafa0c04f917..3b66ec4b20c8 100644
> --- a/include/linux/netfilter/nf_conntrack_sip.h
> +++ b/include/linux/netfilter/nf_conntrack_sip.h
> @@ -143,7 +143,7 @@ struct nf_nat_sip_hooks {
>   				 unsigned int *datalen,
>   				 unsigned int matchoff,
>   				 unsigned int matchlen,
> -				 u_int16_t port);
> +				 u16 port);
>   
>   	unsigned int (*sdp_session)(struct sk_buff *skb,
>   				    unsigned int protoff,
> diff --git a/net/ipv4/netfilter/nf_nat_h323.c b/net/ipv4/netfilter/nf_nat_h323.c
> index 6bcd6734769b..265c1ba5b348 100644
> --- a/net/ipv4/netfilter/nf_nat_h323.c
> +++ b/net/ipv4/netfilter/nf_nat_h323.c
> @@ -186,7 +186,7 @@ static int nat_rtp_rtcp(struct sk_buff *skb, struct nf_conn *ct,
>   	struct nf_ct_h323_master *info = nfct_help_data(ct);
>   	int dir = CTINFO2DIR(ctinfo);
>   	int i;
> -	u_int16_t nated_port;
> +	u16 nated_port;
>   
>   	if (!info)
>   		return -1;
> @@ -282,7 +282,7 @@ static int nat_t120(struct sk_buff *skb, struct nf_conn *ct,
>   		    struct nf_conntrack_expect *exp)
>   {
>   	int dir = CTINFO2DIR(ctinfo);
> -	u_int16_t nated_port = ntohs(port);
> +	u16 nated_port = ntohs(port);
>   
>   	/* Set expectations for NAT */
>   	exp->saved_proto.tcp.port = exp->tuple.dst.u.tcp.port;
> @@ -321,7 +321,7 @@ static int nat_h245(struct sk_buff *skb, struct nf_conn *ct,
>   {
>   	struct nf_ct_h323_master *info = nfct_help_data(ct);
>   	int dir = CTINFO2DIR(ctinfo);
> -	u_int16_t nated_port = ntohs(port);
> +	u16 nated_port = ntohs(port);
>   
>   	if (!info)
>   		return -1;
> @@ -402,7 +402,7 @@ static int nat_q931(struct sk_buff *skb, struct nf_conn *ct,
>   {
>   	struct nf_ct_h323_master *info = nfct_help_data(ct);
>   	int dir = CTINFO2DIR(ctinfo);
> -	u_int16_t nated_port = ntohs(port);
> +	u16 nated_port = ntohs(port);
>   	union nf_inet_addr addr;
>   
>   	if (!info)
> @@ -488,7 +488,7 @@ static int nat_callforwarding(struct sk_buff *skb, struct nf_conn *ct,
>   			      struct nf_conntrack_expect *exp)
>   {
>   	int dir = CTINFO2DIR(ctinfo);
> -	u_int16_t nated_port;
> +	u16 nated_port;
>   
>   	/* Set expectations for NAT */
>   	exp->saved_addr = exp->tuple.dst.u3;
> diff --git a/net/ipv4/netfilter/nf_nat_pptp.c b/net/ipv4/netfilter/nf_nat_pptp.c
> index fed5249001a4..5387c288c348 100644
> --- a/net/ipv4/netfilter/nf_nat_pptp.c
> +++ b/net/ipv4/netfilter/nf_nat_pptp.c
> @@ -130,7 +130,7 @@ pptp_outbound_pkt(struct sk_buff *skb,
>   	struct nf_ct_pptp_master *ct_pptp_info;
>   	struct nf_conn_nat *nat = nfct_nat(ct);
>   	struct nf_nat_pptp *nat_pptp_info;
> -	u_int16_t msg;
> +	u16 msg;
>   	__be16 new_callid;
>   	unsigned int cid_off;
>   
> @@ -243,7 +243,7 @@ pptp_inbound_pkt(struct sk_buff *skb,
>   {
>   	const struct nf_nat_pptp *nat_pptp_info;
>   	struct nf_conn_nat *nat = nfct_nat(ct);
> -	u_int16_t msg;
> +	u16 msg;
>   	__be16 new_pcid;
>   	unsigned int pcid_off;
>   
> diff --git a/net/netfilter/nf_nat_amanda.c b/net/netfilter/nf_nat_amanda.c
> index 330415809425..17b0c1c8d4e1 100644
> --- a/net/netfilter/nf_nat_amanda.c
> +++ b/net/netfilter/nf_nat_amanda.c
> @@ -34,7 +34,7 @@ static unsigned int help(struct sk_buff *skb,
>   			 struct nf_conntrack_expect *exp)
>   {
>   	char buffer[sizeof("65535")];
> -	u_int16_t port;
> +	u16 port;
>   
>   	/* Connection comes from client. */
>   	exp->saved_proto.tcp.port = exp->tuple.dst.u.tcp.port;
> diff --git a/net/netfilter/nf_nat_ftp.c b/net/netfilter/nf_nat_ftp.c
> index 25d20e2970ae..0c90165040e0 100644
> --- a/net/netfilter/nf_nat_ftp.c
> +++ b/net/netfilter/nf_nat_ftp.c
> @@ -70,7 +70,7 @@ static unsigned int nf_nat_ftp(struct sk_buff *skb,
>   			       struct nf_conntrack_expect *exp)
>   {
>   	union nf_inet_addr newaddr;
> -	u_int16_t port;
> +	u16 port;
>   	int dir = CTINFO2DIR(ctinfo);
>   	char buffer[sizeof("|1||65535|") + INET6_ADDRSTRLEN];
>   	unsigned int buflen;
> diff --git a/net/netfilter/nf_nat_irc.c b/net/netfilter/nf_nat_irc.c
> index 89b31fe932ba..140b7d99a887 100644
> --- a/net/netfilter/nf_nat_irc.c
> +++ b/net/netfilter/nf_nat_irc.c
> @@ -39,7 +39,7 @@ static unsigned int help(struct sk_buff *skb,
>   {
>   	char buffer[sizeof("4294967296 65635")];
>   	union nf_inet_addr newaddr;
> -	u_int16_t port;
> +	u16 port;
>   
>   	/* Reply comes from server. */
>   	newaddr = ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u3;
> diff --git a/net/netfilter/nf_nat_sip.c b/net/netfilter/nf_nat_sip.c
> index 8c412bcf6cff..e27c9744054e 100644
> --- a/net/netfilter/nf_nat_sip.c
> +++ b/net/netfilter/nf_nat_sip.c
> @@ -410,7 +410,7 @@ static unsigned int nf_nat_sip_expect(struct sk_buff *skb, unsigned int protoff,
>   	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
>   	struct nf_ct_sip_master *ct_sip_info = nfct_help_data(ct);
>   	union nf_inet_addr newaddr;
> -	u_int16_t port;
> +	u16 port;
>   	__be16 srcport;
>   	char buffer[INET6_ADDRSTRLEN + sizeof("[]:nnnnn")];
>   	unsigned int buflen;
> @@ -536,7 +536,7 @@ static unsigned int nf_nat_sdp_port(struct sk_buff *skb, unsigned int protoff,
>   				    const char **dptr, unsigned int *datalen,
>   				    unsigned int matchoff,
>   				    unsigned int matchlen,
> -				    u_int16_t port)
> +				    u16 port)
>   {
>   	char buffer[sizeof("nnnnn")];
>   	unsigned int buflen;
> @@ -601,7 +601,7 @@ static unsigned int nf_nat_sdp_media(struct sk_buff *skb, unsigned int protoff,
>   	enum ip_conntrack_info ctinfo;
>   	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
>   	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
> -	u_int16_t port;
> +	u16 port;
>   
>   	/* Connection will come from reply */
>   	if (nf_inet_addr_cmp(&ct->tuplehash[dir].tuple.src.u3,

