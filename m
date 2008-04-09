From: "Greg Scott" <GregScott@InfraSupportEtc.com>
Subject: RE: Ebtables hook order anomaly
Date: Wed, 9 Apr 2008 10:12:52 -0500
Message-ID: <925A849792280C4E80C5461017A4B8A226A0F8@mail733.InfraSupportEtc.com>
References: <925A849792280C4E80C5461017A4B8A226A019@mail733.InfraSupportEtc.com> <alpine.LNX.1.10.0803250301140.9368@fbirervta.pbzchgretzou.qr> <alpine.LNX.1.10.0803250455030.9368@fbirervta.pbzchgretzou.qr> <47E8F6B4.4030800@trash.net> <alpine.LNX.1.10.0804081645450.2229@fbirervta.pbzchgretzou.qr> <47FCD47A.7060600@trash.net> <alpine.LNX.1.10.0804091639210.3866@fbirervta.pbzchgretzou.qr> <47FCDAE5.5050409@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "Netfilter Developer Mailing List" <netfilter-devel@vger.kernel.org>
To: "Patrick McHardy" <kaber@trash.net>,
	"Jan Engelhardt" <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.infrasupportetc.com ([66.173.97.5]:15583 "EHLO
	mail733.InfraSupportEtc.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753330AbYDIPMx convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2008 11:12:53 -0400
Content-class: urn:content-classes:message
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> A pure bridge doesn't need ARP. I don't get your point,
> but my suggestion might not make much sense, I haven't
> really thought about this.

My little bridge-router systems could use ARP.  I am putting together a
site right now that uses an active/passive HA pair of firewall
bridge/router systems.  I kludge in a MAC Address for the active system
to make the router in front of it happy, as well as sending out a GARP.


This site needs bridging because it has H.323 videoconferencing
equipment in place.  H.323 devices - especially older ones - do not get
along well with NAT.  So I give the H.323 stuff a public IP Address and
set up a bridge.  

This all worked nicely until the night before Easter when I tried a new
version and everything broke.  But I can live with not knowing the out
interface from L3 as long as I know the in-interface.  

- Greg
