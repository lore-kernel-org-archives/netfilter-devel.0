From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] conntrackd: don't resync expectations if such sync has
 been disabled
Date: Fri, 3 Aug 2012 11:02:18 +0200
Message-ID: <20120803090218.GB9363@1984>
References: <1343921636-6527-1-git-send-email-bernat@luffy.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Vincent Bernat <bernat@luffy.cx>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51518 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361Ab2HCJCV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Aug 2012 05:02:21 -0400
Content-Disposition: inline
In-Reply-To: <1343921636-6527-1-git-send-email-bernat@luffy.cx>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Aug 02, 2012 at 05:33:56PM +0200, Vincent Bernat wrote:
> conntrackd was segfaulting with `ExpectationSync` set to `Off`.
> 
> Signed-off-by: Vincent Bernat <bernat@luffy.cx>
> ---
>  src/ctnl.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/src/ctnl.c b/src/ctnl.c
> index 107cd5d..154b612 100644
> --- a/src/ctnl.c
> +++ b/src/ctnl.c
> @@ -164,7 +164,7 @@ static void do_polling_alarm(struct alarm_block *a, void *data)
>  		STATE(mode)->internal->exp.purge();
>  
>  	nl_send_resync(STATE(resync));
> -	nl_send_expect_resync(STATE(resync));
> +	if (CONFIG(flags) & CTD_EXPECT) nl_send_expect_resync(STATE(resync));

Applied (with little change to fix coding style).

Thanks Vincent.
