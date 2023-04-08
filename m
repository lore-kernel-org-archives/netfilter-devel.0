Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 522B7C7619A
	for <netfilter-devel@archiver.kernel.org>; Sat,  8 Apr 2023 23:09:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbjDHXJL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 8 Apr 2023 19:09:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjDHXJL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 8 Apr 2023 19:09:11 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5652061B3
        for <netfilter-devel@vger.kernel.org>; Sat,  8 Apr 2023 16:09:09 -0700 (PDT)
Date:   Sun, 9 Apr 2023 01:09:04 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Dave Pifke <dave@pifke.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] src: try SO_SNDBUF before SO_SNDBUFFORCE
Message-ID: <ZDH0EJN9O0DrWp0W@calendula>
References: <87wn2n8ghs.fsf@stabbing.victim.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87wn2n8ghs.fsf@stabbing.victim.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi again,

Let me revisit this.

On Fri, Apr 07, 2023 at 04:21:57PM -0600, Dave Pifke wrote:
> Prior to this patch, nft inside a systemd-nspawn container was failing
> to install my ruleset (which includes a large-ish map), with the error
> 
> netlink: Error: Could not process rule: Message too long
> 
> strace reveals:
> 
> setsockopt(3, SOL_SOCKET, SO_SNDBUFFORCE, [524288], 4) = -1 EPERM (Operation not permitted)
>
> This is despite the nspawn process supposedly having CAP_NET_ADMIN,
> and despite /proc/sys/net/core/wmem_max (in the main host namespace)
> being set larger than the requested size:
> 
> net.core.wmem_max = 16777216

OK, so you indeed increased net.core.wmem_max on the host namespace.

> A web search reveals at least one other user having the same issue:
> 
> https://old.reddit.com/r/Proxmox/comments/scnoav/lxc_container_debian_11_nftables_geoblocking/
> 
> After this patch, nft succeeds.
> ---
>  src/mnl.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/src/mnl.c b/src/mnl.c
> index 26f943db..ab6750c8 100644
> --- a/src/mnl.c
> +++ b/src/mnl.c
> @@ -260,6 +260,13 @@ static void mnl_set_sndbuffer(const struct mnl_socket *nl,
>  		return;
>  
>  	/* Rise sender buffer length to avoid hitting -EMSGSIZE */
> +	if (setsockopt(mnl_socket_get_fd(nl), SOL_SOCKET, SO_SNDBUF,
> +		       &newbuffsiz, sizeof(socklen_t)) == 0)
> +		return;

setsockopt() with SO_SNDBUF never fails: it trims the newbuffsiz that is
specified by net.core.wmem_max

This needs to call:

	setsockopt(mnl_socket_get_fd(nl), SOL_SOCKET, SO_SNDBUF,
		   &newbuffsiz, sizeof(socklen_t));

without checking the return value. Otherwise, SO_SNDBUFFORCE is never
going to be called after this patch. This needs a v2.

On top of this patch, you still needed to increase net.core.wmem_max
in your host container for this to work.

> +	/* If the above fails (probably because it exceeds
> +	 * /proc/sys/net/core/wmem_max), try again with SO_SNDBUFFORCE.
> +	 * This requires CAP_NET_ADMIN. */
>  	if (setsockopt(mnl_socket_get_fd(nl), SOL_SOCKET, SO_SNDBUFFORCE,
>  		       &newbuffsiz, sizeof(socklen_t)) < 0)
>  		return;
> -- 
> 2.20.1
> 
