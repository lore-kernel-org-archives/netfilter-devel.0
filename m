Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E09CBC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Dec 2021 18:07:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233126AbhLHSKc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Dec 2021 13:10:32 -0500
Received: from mail.netfilter.org ([217.70.188.207]:41154 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232815AbhLHSKb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Dec 2021 13:10:31 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id A75B5605C4;
        Wed,  8 Dec 2021 19:04:36 +0100 (CET)
Date:   Wed, 8 Dec 2021 19:06:55 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Eugene Crosser <crosser@average.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 2/2] Handle retriable errors from mnl functions
Message-ID: <YbD0P44IvQYGU7Dm@salvia>
References: <20211208134914.16365-1-crosser@average.org>
 <20211208134914.16365-3-crosser@average.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211208134914.16365-3-crosser@average.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Dec 08, 2021 at 02:49:14PM +0100, Eugene Crosser wrote:
> rc == -1 and errno == EINTR mean:
> 
> mnl_socket_recvfrom() - blindly rerun the function
> mnl_cb_run()          - restart dump request from scratch
> 
> This commit introduces handling of both these conditions
> 
> Signed-off-by: Eugene Crosser <crosser@average.org>
> ---
>  src/iface.c | 73 ++++++++++++++++++++++++++++++++---------------------
>  1 file changed, 44 insertions(+), 29 deletions(-)
> 
> diff --git a/src/iface.c b/src/iface.c
> index d0e1834c..029f6476 100644
> --- a/src/iface.c
> +++ b/src/iface.c
> @@ -66,39 +66,54 @@ void iface_cache_update(void)
>  	struct nlmsghdr *nlh;
>  	struct rtgenmsg *rt;
>  	uint32_t seq, portid;
> +	bool need_restart;
> +	int retry_count = 5;

Did you ever hit this retry count? What is you daemon going to do
after these retries?

Probably this can be made configurable for libraries in case you
prefer your daemon to give up after many retries, but, by default,
I'd prefer to to keep trying until you get a consistent cache from the
kernel via netlink dump.
