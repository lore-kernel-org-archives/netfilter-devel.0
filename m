From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v2] iptables: libxt_string.man add example
Date: Sat, 24 Aug 2013 12:00:07 +0200
Message-ID: <20130824100007.GA26291@breakpoint.cc>
References: <CA+0KVf1g3KXXkFDDpWq3YVGRQKU7Wat+gEiuE6x-9ozka2vdyA@mail.gmail.com>
 <1377291322-17456-1-git-send-email-ljlane@debian.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: "Laurence J. Lane" <ljlane@debian.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:55073 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755264Ab3HXKAM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 24 Aug 2013 06:00:12 -0400
Content-Disposition: inline
In-Reply-To: <1377291322-17456-1-git-send-email-ljlane@debian.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Laurence J. Lane <ljlane@debian.org> wrote:
> diff --git a/extensions/libxt_string.man b/extensions/libxt_string.man
> index b6b271d..ab395b2 100644
> --- a/extensions/libxt_string.man
> +++ b/extensions/libxt_string.man
> @@ -16,3 +16,9 @@ Matches the given pattern.
>  .TP
>  [\fB!\fP] \fB\-\-hex\-string\fP \fIpattern\fP
>  Matches the given pattern in hex notation.
> +.TP
> +Example: log HTTP GET requests for /test using string and hex string patterns
> +.IP
> +iptables \-A INPUT \-p tcp \-\-dport 80 \-m string \-\-algo bm \-\-string 'GET /test' \-j LOG
> +.IP
> +iptables \-A INPUT \-p tcp \-\-dport 80 \-m string \-\-algo bm \-\-hex\-string '|474554202F74657374|' \-j LOG

The second example doesn't make much sense to me, IMHO, since there is
no reason to use hex instead of ascii for this.

What about something like
-p udp --dport 53 -m string --algo bm --from 40 --to 57 --hex-string '|03|www|09|netfilter|03|org|00|'

?
