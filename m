From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: Linux netfilter shuts down the server
Date: Fri, 03 Jun 2011 21:40:19 +0200
Message-ID: <1307130019.2600.4.camel@edumazet-laptop>
References: <4DE8C3B6.4080409@metu.edu.tr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Lutfi ODUNCUOGLU <lutfio@metu.edu.tr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:60878 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096Ab1FCTkX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Jun 2011 15:40:23 -0400
Received: by wwk4 with SMTP id 4so5417532wwk.1
        for <netfilter-devel@vger.kernel.org>; Fri, 03 Jun 2011 12:40:21 -0700 (PDT)
In-Reply-To: <4DE8C3B6.4080409@metu.edu.tr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le vendredi 03 juin 2011 =C3=A0 14:21 +0300, Lutfi ODUNCUOGLU a =C3=A9c=
rit :
> > On 02/06/11 16:18, Lutfi ODUNCUOGLU wrote:
> >> Hello,
> >>
> >> I have a sun x1400 series server, that I use as a router. The OS i=
s
> >> Debian Squeeze and every week my router goes down and I cannot do
> >> anything then hard booting the server. The photo of the error mess=
ages
> >> can be seen at http://metu.edu.tr/~lutfio/a.jpg. What may be the p=
roblem?
> >=20
> > That information is incomplete. We need to know what Linux kernel
> > version you're using, and the upper part of the backtrace would be
> > really helpful.
> > --
> Ok. I am using custom compiled 2.6.37.2 AMD 64 bit kernel. For upper
> backtrace issue when I hard boot the server, I can't find any logs ab=
out
> this error. Is there a way to have this backtrace for next time?
>=20

Please try to setup netconsole so that another machine in your lan can
get a copy of full backtrace, because your screen is too small to get i=
t
all.

Thanks


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
