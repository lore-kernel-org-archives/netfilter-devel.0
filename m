Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED5F6C38147
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Jan 2023 15:29:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbjARP3o (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Jan 2023 10:29:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231336AbjARP3K (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Jan 2023 10:29:10 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 018F66A58
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jan 2023 07:28:36 -0800 (PST)
Date:   Wed, 18 Jan 2023 16:28:33 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Long Xin <lxin@redhat.com>,
        Claudio Porfiri <claudio.porfiri@ericsson.com>
Subject: Re: [PATCH v3 4/4] netfilter: conntrack: unify established states
 for SCTP paths
Message-ID: <Y8gQIUaGTnbS5mEN@salvia>
References: <20230118113853.8067-1-sriram.yagnaraman@est.tech>
 <20230118113853.8067-5-sriram.yagnaraman@est.tech>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230118113853.8067-5-sriram.yagnaraman@est.tech>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jan 18, 2023 at 12:38:53PM +0100, Sriram Yagnaraman wrote:
> An SCTP endpoint can start an association through a path and tear it
> down over another one. That means the initial path will not see the
> shutdown sequence, and the conntrack entry will remain in ESTABLISHED
> state for 5 days.
> 
> By merging the HEARTBEAT_ACKED and ESTABLISHED states into one
> ESTABLISHED state, there remains no difference between a primary or
> secondary path. The timeout for the merged ESTABLISHED state is set to
> 210 seconds (hb_interval * max_path_retrans + rto_max). So, even if a
> path doesn't see the shutdown sequence, it will expire in a reasonable
> amount of time.

Thanks for new patchset version. One question below.

> @@ -523,8 +512,7 @@ int nf_conntrack_sctp_packet(struct nf_conn *ct,
>  
>  	nf_ct_refresh_acct(ct, ctinfo, skb, timeouts[new_state]);
>  
> -	if (old_state == SCTP_CONNTRACK_COOKIE_ECHOED &&
> -	    dir == IP_CT_DIR_REPLY &&
> +	if (dir == IP_CT_DIR_REPLY &&
>  	    new_state == SCTP_CONNTRACK_ESTABLISHED) {
>  		pr_debug("Setting assured bit\n");
>  		set_bit(IPS_ASSURED_BIT, &ct->status);

Why old_state == SCTP_CONNTRACK_COOKIE_ECHOED was removed to set on
the assured bit?

Thanks.
