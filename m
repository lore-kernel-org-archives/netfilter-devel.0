Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E62ADC38147
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Jan 2023 12:01:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbjARMBJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Jan 2023 07:01:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbjARMAc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Jan 2023 07:00:32 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5EABC366BD
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jan 2023 03:18:47 -0800 (PST)
Date:   Wed, 18 Jan 2023 12:18:43 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Long Xin <lxin@redhat.com>,
        Claudio Porfiri <claudio.porfiri@ericsson.com>
Subject: Re: [PATCH v2 3/4] Revert "netfilter: conntrack: add sctp DATA_SENT
 state"
Message-ID: <Y8fVk7hNjA9Nxyoj@salvia>
References: <20230118111459.32551-1-sriram.yagnaraman@est.tech>
 <20230118111459.32551-4-sriram.yagnaraman@est.tech>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230118111459.32551-4-sriram.yagnaraman@est.tech>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jan 18, 2023 at 12:14:58PM +0100, Sriram Yagnaraman wrote:
> This reverts commit (bff3d0534804: "netfilter: conntrack: add sctp
> DATA_SENT state")
> 
> Using DATA/SACK to detect a new connection on secondary/alternate paths
> works only on new connections, while a HEARTBEAT is required on
> connection re-use. It is probably consistent to wait for HEARTBEAT to
> create a secondary connection in conntrack.
> 
> Signed-off-by: Sriram Yagnaraman <sriram.yagnaraman@est.tech>
> ---
>  .../uapi/linux/netfilter/nf_conntrack_sctp.h  |   2 +-
>  .../linux/netfilter/nfnetlink_cttimeout.h     |   2 +-
>  net/netfilter/nf_conntrack_proto_sctp.c       | 102 ++++++++----------
>  net/netfilter/nf_conntrack_standalone.c       |   8 --
>  4 files changed, 44 insertions(+), 70 deletions(-)
> 
> diff --git a/include/uapi/linux/netfilter/nf_conntrack_sctp.h b/include/uapi/linux/netfilter/nf_conntrack_sctp.h
> index c742469afe21..b90680f01e38 100644
> --- a/include/uapi/linux/netfilter/nf_conntrack_sctp.h
> +++ b/include/uapi/linux/netfilter/nf_conntrack_sctp.h
> @@ -16,7 +16,7 @@ enum sctp_conntrack {
>  	SCTP_CONNTRACK_SHUTDOWN_ACK_SENT,
>  	SCTP_CONNTRACK_HEARTBEAT_SENT,
>  	SCTP_CONNTRACK_HEARTBEAT_ACKED,
> -	SCTP_CONNTRACK_DATA_SENT,
> +	SCTP_CONNTRACK_DATA_SENT,         /* no longer used */

For this case, given this has only shown up in 6.1-rc, I suggest we
can make an exception and simply remove SCTP_CONNTRACK_DATA_SENT.
