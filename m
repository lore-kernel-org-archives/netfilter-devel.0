Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8653C4332F
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Jan 2023 12:41:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbjADMlQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Jan 2023 07:41:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjADMlQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Jan 2023 07:41:16 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83B7217049
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Jan 2023 04:41:14 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pD34y-0002SH-Qn; Wed, 04 Jan 2023 13:41:12 +0100
Date:   Wed, 4 Jan 2023 13:41:12 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Long Xin <lxin@redhat.com>
Subject: Re: [RFC PATCH] netfilter: conntrack: simplify sctp state machine
Message-ID: <20230104124112.GC19686@breakpoint.cc>
References: <20230104113143.21769-1-sriram.yagnaraman@est.tech>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230104113143.21769-1-sriram.yagnaraman@est.tech>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Sriram Yagnaraman <sriram.yagnaraman@est.tech> wrote:
> All the paths in an SCTP connection are kept alive either by actual
> DATA/SACK running through the connection or by HEARTBEAT. This patch
> proposes a simple state machine with only two states OPEN_WAIT and
> ESTABLISHED (similar to UDP). The reason for this change is a full
> stateful approach to SCTP is difficult when the association is
> multihomed since the endpoints could use different paths in the network
> during the lifetime of an association.
> 
> Default timeouts are:
> OPEN_WAIT:   3 seconds   (rto_initial)
> ESTABLISHED: 210 seconds (rto_max + hb_interval * path_max_retrans)
> 
> Important changes/notes
> - Timeout is used to clean up conntrack entries
> - VTAG checks are kept as is (can be moved to a conntrack extension if
>   desired)
> - SCTP chunks are parsed only once, and a map is populated with the
>   information on the chunks present in the packet
> - ASSURED bit is NOT set in this version of the patch, need help
>   understanding when to set it
> 
> Note that this patch has changed uapi headers.

Don't do that please, this will cause trouble.

> Signed-off-by: Sriram Yagnaraman <sriram.yagnaraman@est.tech>
> ---
>  .../uapi/linux/netfilter/nf_conntrack_sctp.h  |  10 +-
>  .../linux/netfilter/nfnetlink_cttimeout.h     |  10 +-
>  net/netfilter/nf_conntrack_proto_sctp.c       | 589 ++++--------------
>  net/netfilter/nf_conntrack_standalone.c       |  72 +--
>  4 files changed, 143 insertions(+), 538 deletions(-)
> 
> diff --git a/include/uapi/linux/netfilter/nf_conntrack_sctp.h b/include/uapi/linux/netfilter/nf_conntrack_sctp.h
> index c742469afe21..89381a57021a 100644
> --- a/include/uapi/linux/netfilter/nf_conntrack_sctp.h
> +++ b/include/uapi/linux/netfilter/nf_conntrack_sctp.h
> @@ -7,16 +7,8 @@
>  
>  enum sctp_conntrack {
>  	SCTP_CONNTRACK_NONE,
> -	SCTP_CONNTRACK_CLOSED,
> -	SCTP_CONNTRACK_COOKIE_WAIT,
> -	SCTP_CONNTRACK_COOKIE_ECHOED,
> +	SCTP_CONNTRACK_OPEN_WAIT,
>  	SCTP_CONNTRACK_ESTABLISHED,
> -	SCTP_CONNTRACK_SHUTDOWN_SENT,
> -	SCTP_CONNTRACK_SHUTDOWN_RECD,
> -	SCTP_CONNTRACK_SHUTDOWN_ACK_SENT,
> -	SCTP_CONNTRACK_HEARTBEAT_SENT,
> -	SCTP_CONNTRACK_HEARTBEAT_ACKED,
> -	SCTP_CONNTRACK_DATA_SENT,
>  	SCTP_CONNTRACK_MAX

Please keep all as-is.

You might want to add a /* no loner used */ or similar.

You could hijack an existing enum to avoid adding a new one:

SCTP_CONNTRACK_OPEN_WAIT = SCTP_CONNTRACK_COOKIE_WAIT,

> diff --git a/include/uapi/linux/netfilter/nfnetlink_cttimeout.h b/include/uapi/linux/netfilter/nfnetlink_cttimeout.h
> index 94e74034706d..372dfe7c07ed 100644
> --- a/include/uapi/linux/netfilter/nfnetlink_cttimeout.h
> +++ b/include/uapi/linux/netfilter/nfnetlink_cttimeout.h
> @@ -86,16 +86,8 @@ enum ctattr_timeout_dccp {
>  
>  enum ctattr_timeout_sctp {
>  	CTA_TIMEOUT_SCTP_UNSPEC,
> -	CTA_TIMEOUT_SCTP_CLOSED,
> -	CTA_TIMEOUT_SCTP_COOKIE_WAIT,
> -	CTA_TIMEOUT_SCTP_COOKIE_ECHOED,
> +	CTA_TIMEOUT_SCTP_OPEN_WAIT,
>  	CTA_TIMEOUT_SCTP_ESTABLISHED,
> -	CTA_TIMEOUT_SCTP_SHUTDOWN_SENT,
> -	CTA_TIMEOUT_SCTP_SHUTDOWN_RECD,
> -	CTA_TIMEOUT_SCTP_SHUTDOWN_ACK_SENT,
> -	CTA_TIMEOUT_SCTP_HEARTBEAT_SENT,
> -	CTA_TIMEOUT_SCTP_HEARTBEAT_ACKED,
> -	CTA_TIMEOUT_SCTP_DATA_SENT,
>  	__CTA_TIMEOUT_SCTP_MAX

Same, this is frozen, you can add to it but you
cannot remove this.

You can add a kernel internal enum if you like, to replace the existing
ones, with kernel mapping the new ones to old (and ignoring the old ones
on input from userspace).

This would allow to shrink struct nf_sctp_net size for example.

>  #define CTA_TIMEOUT_SCTP_MAX (__CTA_TIMEOUT_SCTP_MAX - 1)
> diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
> index d88b92a8ffca..d79ed476b764 100644
> --- a/net/netfilter/nf_conntrack_proto_sctp.c
> +++ b/net/netfilter/nf_conntrack_proto_sctp.c
> @@ -5,12 +5,13 @@
>   * Copyright (c) 2004 Kiran Kumar Immidi <immidi_kiran@yahoo.com>
>   * Copyright (c) 2004-2012 Patrick McHardy <kaber@trash.net>
>   *
> - * SCTP is defined in RFC 2960. References to various sections in this code
> + * SCTP is defined in RFC 4960. References to various sections in this code
>   * are to this RFC.
>   */
>  
>  #include <linux/types.h>
>  #include <linux/timer.h>
> +#include <linux/jiffies.h>
>  #include <linux/netfilter.h>
>  #include <linux/in.h>
>  #include <linux/ip.h>
> @@ -27,127 +28,19 @@
>  #include <net/netfilter/nf_conntrack_ecache.h>
>  #include <net/netfilter/nf_conntrack_timeout.h>
>  
> -/* FIXME: Examine ipfilter's timeouts and conntrack transitions more
> -   closely.  They're more complex. --RR
> -
> -   And so for me for SCTP :D -Kiran */
> +#define	SCTP_FLAG_HEARTBEAT_VTAG_FAILED	1
>  
>  static const char *const sctp_conntrack_names[] = {
>  	"NONE",
> -	"CLOSED",
> -	"COOKIE_WAIT",
> -	"COOKIE_ECHOED",
> +	"OPEN_WAIT",
>  	"ESTABLISHED",
> -	"SHUTDOWN_SENT",
> -	"SHUTDOWN_RECD",
> -	"SHUTDOWN_ACK_SENT",
> -	"HEARTBEAT_SENT",
> -	"HEARTBEAT_ACKED",
>  };

> -	}
> +	[SCTP_CONNTRACK_OPEN_WAIT]			= 3 SECS,
> +	[SCTP_CONNTRACK_ESTABLISHED]		= 210 SECS,
>  };
  
>  
> +#define for_each_sctp_chunk(skb, sch, _sch, offset, dataoff, count)	\
> +for ((offset) = (dataoff) + sizeof(struct sctphdr), (count) = 0;	\
> +	(offset) < (skb)->len &&					\

I think skb_header_pointer() will return NULL if offset + sizeof(_sch)
exceeds skb->len, so this offset < skb->len test is redundant.

> +	(offset) += (ntohs((sch)->length) + 3) & ~3, (count)++)

What if sch->length == 0?

> +	for_each_sctp_chunk (skb, sch, _sch, offset, dataoff, count) {
> +		pr_debug("Chunk Num: %d  Type: %d\n", count, sch->type);

Is this pr_debug() needed?  Its pretty useless because it would print
for every packet (its not an error path).

> +		set_bit(sch->type, map);
>  
> -	if (do_basic_checks(ct, skb, dataoff, map) != 0)
> -		goto out;
> +		if (sch->type == SCTP_CID_INIT ||
> +			sch->type == SCTP_CID_INIT_ACK) {
> +			struct sctp_inithdr _inith, *inith;
> +			inith = skb_header_pointer(skb, offset + sizeof(_sch),
> +						sizeof(_inith), &_inith);
> +			if (inith)
> +				init_vtag = inith->init_tag;
> +			else
> +				goto out_drop;

			if (!inith)
				goto out_drop;

			init_vtag = inith->init_tag;

Also, please run your patch through scripts/checkpatch.pl script, I'm
sure there are several coding style warnings here.

> +	spin_lock_bh(&ct->lock);

Why is this spinlock needed?

>  	if (!nf_ct_is_confirmed(ct)) {
>  		/* If an OOTB packet has any of these chunks discard (Sec 8.4) */
>  		if (test_bit(SCTP_CID_ABORT, map) ||
>  		    test_bit(SCTP_CID_SHUTDOWN_COMPLETE, map) ||
>  		    test_bit(SCTP_CID_COOKIE_ACK, map))
> -			return -NF_ACCEPT;
> +			goto out_unlock;
>  
> -		if (!sctp_new(ct, skb, sh, dataoff))
> -			return -NF_ACCEPT;

Any reason for deleting sctp_new()?
It makes this body a lot larger, the lines below could have been done in
sctp_new().

> +		memset(&ct->proto.sctp, 0, sizeof(ct->proto.sctp));
> +		ct->proto.sctp.state = SCTP_CONNTRACK_OPEN_WAIT;
> +		nf_conntrack_event_cache(IPCT_PROTOINFO, ct);
> +
> +		if (test_bit(SCTP_CID_INIT, map))
> +			ct->proto.sctp.vtag[!dir] = init_vtag;
> +		else if (test_bit(SCTP_CID_SHUTDOWN_ACK, map))
> +			/* If it is a shutdown ack OOTB packet, we expect a return
> +			shutdown complete, otherwise an ABORT Sec 8.4 (5) and (8) */
> +			ct->proto.sctp.vtag[!dir] = sctph->vtag;
> +		else
> +			ct->proto.sctp.vtag[dir] = sctph->vtag;

Maybe the else branch below can be elided by adding a
goto here?

AFAICS the spinlock is only needed for some parts of the else branch,
so the spin_lock_bh can be moved.
> +		/* we have seen traffic both ways, go to established */
> +		if (dir == IP_CT_DIR_REPLY &&
> +			ct->proto.sctp.state == SCTP_CONNTRACK_OPEN_WAIT) {
> +			ct->proto.sctp.state = SCTP_CONNTRACK_ESTABLISHED;
> +			nf_conntrack_event_cache(IPCT_PROTOINFO, ct);

> +	/* Check the verification tag (Sec 8.5) */
> +	if (!test_bit(SCTP_CID_INIT, map) &&
> +		!test_bit(SCTP_CID_SHUTDOWN_COMPLETE, map) &&
> +		!test_bit(SCTP_CID_COOKIE_ECHO, map) &&
> +		!test_bit(SCTP_CID_ABORT, map) &&
> +		!test_bit(SCTP_CID_SHUTDOWN_ACK, map) &&
> +		!test_bit(SCTP_CID_HEARTBEAT, map) &&
> +		!test_bit(SCTP_CID_HEARTBEAT_ACK, map) &&
> +		sctph->vtag != ct->proto.sctp.vtag[dir]) {
> +		pr_debug("Verification tag check failed\n");

Please have a look at
https://patchwork.ozlabs.org/project/netfilter-devel/patch/20230102114612.15860-2-fw@strlen.de/

I hope it will be applied shortly so you can rebase.
I don't have any other sctp patches.

This should be
nf_ct_l4proto_log_invalid(skb, ct, state,
			  "verification tag check failed %x vs %x for dir %d",
			  sh->vtag, ct->proto.sctp.vtag[dir], dir);

instead of pr_debug().

> +	/* Special cases of Verification tag check (Sec 8.5.1) */

Please extend the comments a bit so I don't have to look at the RFC
while reviewing, just quote the relevant part, i.e.

> +	if (test_bit(SCTP_CID_INIT, map)) {
> +		/* Sec 8.5.1 (A) */
> +		if (sctph->vtag != 0)
>  			goto out_unlock;
> -		}

if (sctph->vtag != 0) /* A) init vtag MUST be 0 */
	goto out_unlock;

> +		else if (nf_ct_is_confirmed(ct))

No need to 'else if', just use 'if'.

> +	/* Need some thought on how to set the assured bit */
> +	// if (dir == IP_CT_DIR_REPLY &&
> +	// 	!(test_bit(IPS_ASSURED_BIT, &ct->status))) {
> +	// 	  set_bit(IPS_ASSURED_BIT, &ct->status);
> +	// 	  nf_conntrack_event_cache(IPCT_ASSURED, ct);

Probably do a test_and_set_bit() when the connection switches to
ESTABLISHED?

>  sctp_timeout_nla_policy[CTA_TIMEOUT_SCTP_MAX+1] = {
> -	[CTA_TIMEOUT_SCTP_CLOSED]		= { .type = NLA_U32 },
> -	[CTA_TIMEOUT_SCTP_COOKIE_WAIT]		= { .type = NLA_U32 },
> -	[CTA_TIMEOUT_SCTP_COOKIE_ECHOED]	= { .type = NLA_U32 },
> +	[CTA_TIMEOUT_SCTP_OPEN_WAIT]		= { .type = NLA_U32 },
>  	[CTA_TIMEOUT_SCTP_ESTABLISHED]		= { .type = NLA_U32 },
> -	[CTA_TIMEOUT_SCTP_SHUTDOWN_SENT]	= { .type = NLA_U32 },
> -	[CTA_TIMEOUT_SCTP_SHUTDOWN_RECD]	= { .type = NLA_U32 },
> -	[CTA_TIMEOUT_SCTP_SHUTDOWN_ACK_SENT]	= { .type = NLA_U32 },
> -	[CTA_TIMEOUT_SCTP_HEARTBEAT_SENT]	= { .type = NLA_U32 },
> -	[CTA_TIMEOUT_SCTP_HEARTBEAT_ACKED]	= { .type = NLA_U32 },
> -	[CTA_TIMEOUT_SCTP_DATA_SENT]		= { .type = NLA_U32 },

Please retain this as-is for now.

I'm fine with removing the sysctls though.
