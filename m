From: "Greg Scott" <GregScott@InfraSupportEtc.com>
Subject: RE: Ebtables hook order anomaly
Date: Wed, 9 Apr 2008 11:18:13 -0500
Message-ID: <925A849792280C4E80C5461017A4B8A226A0FC@mail733.InfraSupportEtc.com>
References: <925A849792280C4E80C5461017A4B8A226A019@mail733.InfraSupportEtc.com> <alpine.LNX.1.10.0803250301140.9368@fbirervta.pbzchgretzou.qr> <alpine.LNX.1.10.0803250455030.9368@fbirervta.pbzchgretzou.qr> <47E8F6B4.4030800@trash.net> <alpine.LNX.1.10.0804081645450.2229@fbirervta.pbzchgretzou.qr> <47FCD47A.7060600@trash.net> <alpine.LNX.1.10.0804091639210.3866@fbirervta.pbzchgretzou.qr> <47FCDAE5.5050409@trash.net> <alpine.LNX.1.10.0804091808500.3866@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "Netfilter Developer Mailing List" <netfilter-devel@vger.kernel.org>
To: "Jan Engelhardt" <jengelh@computergmbh.de>,
	"Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.infrasupportetc.com ([66.173.97.5]:17730 "EHLO
	mail733.InfraSupportEtc.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752119AbYDIQSO convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2008 12:18:14 -0400
Content-class: urn:content-classes:message
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> Well maybe you don't want to use a bridge for simplicity 
> but still do proxy arp for lots of addresses.

See the email I sent a few minutes ago about proxy ARP.  Proxy ARP
scares the daylights out of me.  Now, if there were a way to proxy ARP
for only a select set of IP Addresses - instead of ***all*** IP
Addresses hitting the interface - now that would be something!

- Greg
