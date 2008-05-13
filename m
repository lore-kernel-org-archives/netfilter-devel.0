From: Henrik Nordstrom <henrik@henriknordstrom.net>
Subject: Re: [patch 2/4] Add support for --set-counters to iptables -P
Date: Tue, 13 May 2008 11:07:32 +0200
Message-ID: <1210669652.24094.2.camel@henriknordstrom.net>
References: <1210616702.3442.33.camel@henriknordstrom.net>
	 <alpine.LNX.1.10.0805122030280.25441@fbirervta.pbzchgretzou.qr>
	 <48288F2D.8040904@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vps1.henriknordstrom.net ([195.20.207.177]:52528 "EHLO
	vps1.henriknordstrom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757198AbYEMJHk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 May 2008 05:07:40 -0400
In-Reply-To: <48288F2D.8040904@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On m=C3=A5n, 2008-05-12 at 20:40 +0200, Patrick McHardy wrote:

> > Could this perhaps be changed so that -c only takes one argument?
> > Like -c 10,20. This would ease integration with passthrough
> > argument parsing in 3rd party applications.
>=20
> I already applied it, in case you want to change anything, please
> send a patch on top.

Done, but it is a separate issue not related to these patches.

Regards
Henrik

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
