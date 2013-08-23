From: "Laurence J. Lane" <ljlane@debian.org>
Subject: Re: [PATCH] iptables: libxt_string.man add example
Date: Fri, 23 Aug 2013 15:38:25 -0400
Message-ID: <CA+0KVf1g3KXXkFDDpWq3YVGRQKU7Wat+gEiuE6x-9ozka2vdyA@mail.gmail.com>
References: <1377240085-15466-1-git-send-email-ljlane@debian.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ankh.ljlane.net ([71.19.149.249]:40653 "EHLO ankh.ljlane.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756399Ab3HWTpi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Aug 2013 15:45:38 -0400
Received: from mail-vc0-f170.google.com (mail-vc0-f170.google.com [209.85.220.170])
	(using TLSv1 with cipher ECDHE-RSA-RC4-SHA (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: google-debian@ankh.ljlane.net)
	by ankh.ljlane.net (Postfix) with ESMTPSA id 87556EF0F
	for <netfilter-devel@vger.kernel.org>; Fri, 23 Aug 2013 15:38:46 -0400 (EDT)
Received: by mail-vc0-f170.google.com with SMTP id kw10so754939vcb.1
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Aug 2013 12:38:45 -0700 (PDT)
In-Reply-To: <1377240085-15466-1-git-send-email-ljlane@debian.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The markup is wrong.

On Fri, Aug 23, 2013 at 2:41 AM, Laurence J. Lane <ljlane@debian.org> wrote:
> Show delimeters for hex string pattern.
>
> http://bugs.debian.org/699904
>
> Signed-off-by: Laurence J. Lane <ljlane@debian.org>
> ---
>  extensions/libxt_string.man | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/extensions/libxt_string.man b/extensions/libxt_string.man
> index b6b271d..ebea1d3 100644
> --- a/extensions/libxt_string.man
> +++ b/extensions/libxt_string.man
> @@ -16,3 +16,10 @@ Matches the given pattern.
>  .TP
>  [\fB!\fP] \fB\-\-hex\-string\fP \fIpattern\fP
>  Matches the given pattern in hex notation.
> +.TP
> +Example:
> +.PP
> +   Log HTTP GET requests for /test:
> +.PP
> +   iptables \-A INPUT \-p tcp \-\-dport 80 \-m string \-\-algo bm \-\-string 'GET /test' \-j LOG
> +   iptables \-A INPUT \-p tcp \-\-dport 80 \-m string \-\-algo bm \-\-hex\-string '|474554202F74657374|' \-j LOG
> --
> 1.8.4.rc3
>
