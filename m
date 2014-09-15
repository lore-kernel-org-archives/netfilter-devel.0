From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] libxt_devgroup: manpage corrections
Date: Mon, 15 Sep 2014 14:49:33 +0200
Message-ID: <20140915124933.GD14006@breakpoint.cc>
References: <1410784519-28428-1-git-send-email-anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:54073 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750790AbaIOMtf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Sep 2014 08:49:35 -0400
Content-Disposition: inline
In-Reply-To: <1410784519-28428-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ana Rey <anarey@gmail.com> wrote:
> This corrects several errors in the devgroup match.
> 
> Signed-off-by: Ana Rey <anarey@gmail.com>
> ---
>  extensions/libxt_devgroup.man |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/extensions/libxt_devgroup.man b/extensions/libxt_devgroup.man
> index 4a66c9f..7696f28 100644
> --- a/extensions/libxt_devgroup.man
> +++ b/extensions/libxt_devgroup.man
> @@ -1,7 +1,7 @@
>  Match device group of a packets incoming/outgoing interface.
>  .TP
> -[\fB!\fP] \fB\-\-src\-group\fP \fIname\fP
> +[\fB!\fP] \fB\-\-src\-group\fP \fIvalue[/mask]\fP

The match also supports name mappings via /etc/iproute2/group_map.

[ although iproute2 seems to use /etc/iproute2/group instead,
  perhaps a bug? ]
