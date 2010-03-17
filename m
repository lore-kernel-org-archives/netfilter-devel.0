From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: iptables pull request, add XT_RECENT_REAP support
Date: Wed, 17 Mar 2010 20:34:57 +0100
Message-ID: <1268854497.2894.2.camel@edumazet-laptop>
References: <20100317184852.89F0DF89BB@sepang.rtg.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: Tim Gardner <timg@tpi.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f212.google.com ([209.85.218.212]:59334 "EHLO
	mail-bw0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755765Ab0CQTfD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Mar 2010 15:35:03 -0400
Received: by bwz4 with SMTP id 4so1452221bwz.39
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Mar 2010 12:35:01 -0700 (PDT)
In-Reply-To: <20100317184852.89F0DF89BB@sepang.rtg.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le mercredi 17 mars 2010 =C3=A0 12:48 -0600, Tim Gardner a =C3=A9crit :
> diff --git a/extensions/libxt_recent.man b/extensions/libxt_recent.ma=
n
> index 532c328..26e4fb9 100644
> --- a/extensions/libxt_recent.man
> +++ b/extensions/libxt_recent.man
> @@ -41,6 +41,11 @@ This option must be used in conjunction with one o=
f \fB\-\-rcheck\fP or
>  \fB\-\-update\fP. When used, this will narrow the match to only happ=
en when the
>  address is in the list and was seen within the last given number of =
seconds.
>  .TP
> +\fB\-\-reap\fP \fIreap\fP
> +This option must be used in conjunction with \fB\-\-seconds\fP. When=
 used, this
> +will remove entries with the most recent timestamp older then \fB\-\=
-seconds\fP
> +since the last packet was received.
> +.TP
>  \fB\-\-hitcount\fP \fIhits\fP
>  This option must be used in conjunction with one of \fB\-\-rcheck\fP=
 or
>  \fB\-\-update\fP. When used, this will narrow the match to only happ=
en when the

Are you sure this "most recent timestamp older then " is correct ? ;)



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
