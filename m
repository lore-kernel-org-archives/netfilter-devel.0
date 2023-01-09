Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA363C54EBD
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Jan 2023 22:21:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235332AbjAIWVN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 9 Jan 2023 17:21:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234969AbjAIWVM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Jan 2023 17:21:12 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27C4DD2D9
        for <netfilter-devel@vger.kernel.org>; Mon,  9 Jan 2023 14:21:11 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pF0Vw-0006r9-88; Mon, 09 Jan 2023 23:21:08 +0100
Date:   Mon, 9 Jan 2023 23:21:08 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Long Xin <lxin@redhat.com>,
        Claudio Porfiri <claudio.porfiri@ericsson.com>
Subject: Re: [RFC PATCH v3] netfilter: conntrack: simplify sctp state machine
Message-ID: <20230109222108.GA15049@breakpoint.cc>
References: <20230109122959.1220-1-sriram.yagnaraman@est.tech>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230109122959.1220-1-sriram.yagnaraman@est.tech>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Sriram Yagnaraman <sriram.yagnaraman@est.tech> wrote:
> diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
> index d88b92a8ffca..5166d8b9b394 100644
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

You either need to leave the other strings in place or you need to use
[SCTP_CONNTRACK_ESTABLISHED] =  "ESTABLISHED",

else the mapping of enum value to string isn't correct anymore.

