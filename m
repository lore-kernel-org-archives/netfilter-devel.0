From: Paul Moore <paul.moore@hp.com>
Subject: Re: [PATCH 1/5] secmark: do not return early if there was no error
Date: Tue, 12 Oct 2010 18:52:01 -0400
Message-ID: <1286923921.5133.84.camel@sifl>
References: <20101012154008.26943.44399.stgit@paris.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
	netfilter@vger.kernel.org, jmorris@namei.org,
	selinux@tycho.nsa.gov, sds@tycho.nsa.gov, jengelh@medozas.de,
	linux-security-module@vger.kernel.org, mr.dash.four@googlemail.com,
	pablo@netfilter.org
To: Eric Paris <eparis@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:47478 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952Ab0JLWwH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Oct 2010 18:52:07 -0400
In-Reply-To: <20101012154008.26943.44399.stgit@paris.rdu.redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 2010-10-12 at 11:40 -0400, Eric Paris wrote:
> Commit 4a5a5c73 attempted to pass decent error messages back to userspace for
> netfilter errors.  In xt_SECMARK.c however the patch screwed up and returned
> on 0 (aka no error) early and didn't finish setting up secmark.  This results
> in a kernel BUG if you use SECMARK.

...

> Signed-off-by: Eric Paris <eparis@redhat.com>

Acked-by: Paul Moore <paul.moore@hp.com>

> ---
> 
>  net/netfilter/xt_SECMARK.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/net/netfilter/xt_SECMARK.c b/net/netfilter/xt_SECMARK.c
> index 23b2d6c..364ad16 100644
> --- a/net/netfilter/xt_SECMARK.c
> +++ b/net/netfilter/xt_SECMARK.c
> @@ -101,7 +101,7 @@ static int secmark_tg_check(const struct xt_tgchk_param *par)
>  	switch (info->mode) {
>  	case SECMARK_MODE_SEL:
>  		err = checkentry_selinux(info);
> -		if (err <= 0)
> +		if (err)
>  			return err;
>  		break;
>  
> 

-- 
paul moore
linux @ hp


