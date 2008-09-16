From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: netfilter kernel crash in ip_ct_refresh_acct / ip_conntrack with
 centos 5.x
Date: Tue, 16 Sep 2008 12:12:45 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0809161211140.24547@fbirervta.pbzchgretzou.qr>
References: <20080916073821.GL13941@edu.joroinen.fi>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: centos@centos.org, netfilter-devel@vger.kernel.org
To: =?UTF-8?Q?Pasi_K=C3=A4rkk=C3=A4inen?= <pasik@iki.fi>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:49488 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730AbYIPQMs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Sep 2008 12:12:48 -0400
In-Reply-To: <20080916073821.GL13941@edu.joroinen.fi>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2008-09-16 03:38, Pasi K=C3=A4rkk=C3=A4inen wrote:
>
>Has anyone seen this netfilter kernel crash?=20
>
>Images from the console of the crashed firewall:
>http://pasik.reaktio.net/centos5-kernel-crash/

There have been some crashes reported; and some even fixed.
As such you are encouraged to try a (much) newer kernel
because 2.6.18 is outside the scope of the -stable team.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
