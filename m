From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: iptables pull request, add XT_RECENT_REAP support
Date: Wed, 17 Mar 2010 20:50:02 +0100
Message-ID: <1268855402.2894.18.camel@edumazet-laptop>
References: <20100317184852.89F0DF89BB@sepang.rtg.net>
	 <1268854497.2894.2.camel@edumazet-laptop>  <4BA1310D.5080800@tpi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: timg@tpi.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f212.google.com ([209.85.218.212]:63090 "EHLO
	mail-bw0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab0CQTuI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Mar 2010 15:50:08 -0400
Received: by bwz4 with SMTP id 4so1466969bwz.39
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Mar 2010 12:50:06 -0700 (PDT)
In-Reply-To: <4BA1310D.5080800@tpi.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le mercredi 17 mars 2010 =C3=A0 13:44 -0600, Tim Gardner a =C3=A9crit :
> On 03/17/2010 01:34 PM, Eric Dumazet wrote:
> > Le mercredi 17 mars 2010 =C3=A0 12:48 -0600, Tim Gardner a =C3=A9cr=
it :
> >> diff --git a/extensions/libxt_recent.man b/extensions/libxt_recent=
=2Eman
> >> index 532c328..26e4fb9 100644
> >> --- a/extensions/libxt_recent.man
> >> +++ b/extensions/libxt_recent.man
> >> @@ -41,6 +41,11 @@ This option must be used in conjunction with on=
e of \fB\-\-rcheck\fP or
> >>   \fB\-\-update\fP. When used, this will narrow the match to only =
happen when the
> >>   address is in the list and was seen within the last given number=
 of seconds.
> >>   .TP
> >> +\fB\-\-reap\fP \fIreap\fP
> >> +This option must be used in conjunction with \fB\-\-seconds\fP. W=
hen used, this
> >> +will remove entries with the most recent timestamp older then \fB=
\-\-seconds\fP
> >> +since the last packet was received.
> >> +.TP
> >>   \fB\-\-hitcount\fP \fIhits\fP
> >>   This option must be used in conjunction with one of \fB\-\-rchec=
k\fP or
> >>   \fB\-\-update\fP. When used, this will narrow the match to only =
happen when the
> >
> > Are you sure this "most recent timestamp older then " is correct ? =
;)
> >
> >
> >
>=20
> That does kind of make my head hurt. Perhaps it is better stated, "Wh=
en=20
> used, this will remove entries that have not received a packet in the=
=20
> time specified by --seconds."
>=20

Well, it will remove the oldest entry, if its age is more than time
specifed by --seconds.

ie you wrote "most recent" instead of "least recent"  ----> "oldest"



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
