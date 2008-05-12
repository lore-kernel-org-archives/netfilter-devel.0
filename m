From: Henrik Nordstrom <henrik@henriknordstrom.net>
Subject: Re: [patch 2/4] Add support for --set-counters to iptables -P
Date: Mon, 12 May 2008 20:42:20 +0200
Message-ID: <1210617740.3442.49.camel@henriknordstrom.net>
References: <1210616702.3442.33.camel@henriknordstrom.net>
	 <alpine.LNX.1.10.0805122030280.25441@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vps1.henriknordstrom.net ([195.20.207.177]:48529 "EHLO
	vps1.henriknordstrom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756138AbYELSmY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 May 2008 14:42:24 -0400
In-Reply-To: <alpine.LNX.1.10.0805122030280.25441@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On m=C3=A5n, 2008-05-12 at 20:31 +0200, Jan Engelhardt wrote:
> On Monday 2008-05-12 20:25, Henrik Nordstrom wrote:
>=20
> >Adds support for setting the policy counters
> >
> >iptables -P INPUT -J DROP -c 10 20
>=20
> Could this perhaps be changed so that -c only takes one argument?
> Like -c 10,20. This would ease integration with passthrough
> argument parsing in 3rd party applications.

That's a different patch. All this patch does is enabling the existing
--set-counters (-c) option to be used with --set-policy (-P).

Regards
Henrik

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
