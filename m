From: Patrick McHardy <kaber@trash.net>
Subject: Re: Enabling Netfilter LOG hangs the System
Date: Thu, 17 Sep 2009 13:09:59 +0200
Message-ID: <4AB21907.8070006@trash.net>
References: <1253018583.16585.8.camel@ripper.synapse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Ritesh Majumdar <r.majumdar@globallogic.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58301 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952AbZIQLJ7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Sep 2009 07:09:59 -0400
In-Reply-To: <1253018583.16585.8.camel@ripper.synapse.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ritesh Majumdar wrote:
> Hello List,
>=20
> I am using kernel =EF=BB=BF2.6.11 and =EF=BB=BFiptables v1.2.9.
>=20
> I have LOG enabled to log tcp packets. and configured syslog to write
> into /var/log/messages.
>=20
> Every time logrotate restarts syslogd the system goes for a reboot. I=
 am
> not getting to know the exact problem with the system.
>=20
> But when I disable iptables Logging, syslogd restart fine.

2.6.11 is more than four years old, please update to a recent kernel
and send a new report if the problem persists.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
