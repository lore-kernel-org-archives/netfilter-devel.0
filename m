From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: iptables: Resource temporarily unavailable.
Date: Thu, 11 Nov 2010 16:35:28 +0100
Message-ID: <1289489728.17691.1331.camel@edumazet-laptop>
References: <20101111150055.GI15421@fi.muni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Jan Kasprzak <kas@fi.muni.cz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58239 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987Ab0KKPfc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Nov 2010 10:35:32 -0500
Received: by wyb28 with SMTP id 28so818732wyb.19
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Nov 2010 07:35:31 -0800 (PST)
In-Reply-To: <20101111150055.GI15421@fi.muni.cz>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le jeudi 11 novembre 2010 =C3=A0 16:00 +0100, Jan Kasprzak a =C3=A9crit=
 :
> 	Hello,
>=20
> I have a iptables-based firewall with ~1200 IPv4 and ~950 IPv6 rules.
> When I want to reload its configuration, I often get "Resource tempor=
arily
> unavailable" error from iptables.
>=20
> I have a HA setup with two servers, and the error more often happens =
on
> a server with four cores and 2 GB of RAM than on a server with two co=
res
> and 4 GB of RAM.
>=20
> I have added a band-aid fix to my startup script - sleeping for one s=
econd
> and trying again when the error code from iptables is 4, and it appar=
ently
> helps. But the error messages from the startup script are still a bit=
 ugly.
> What else can I do in order to fix the problem?

Hi

Please provide=20

cat /proc/meminfo

Also please apply this patch :

http://git2.kernel.org/?p=3Dlinux/kernel/git/davem/net-2.6.git;a=3Dcomm=
itdiff;h=3D6b1686a71e3158d3c5f125260effce171cc7852b



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
