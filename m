From: "Greg Scott" <GregScott@InfraSupportEtc.com>
Subject: RE: Ebtables hook order anomaly
Date: Wed, 9 Apr 2008 10:21:51 -0500
Message-ID: <925A849792280C4E80C5461017A4B8A226A0F9@mail733.InfraSupportEtc.com>
References: <925A849792280C4E80C5461017A4B8A226A019@mail733.InfraSupportEtc.com> <alpine.LNX.1.10.0803250301140.9368@fbirervta.pbzchgretzou.qr> <alpine.LNX.1.10.0803250455030.9368@fbirervta.pbzchgretzou.qr> <47E8F6B4.4030800@trash.net> <alpine.LNX.1.10.0804081645450.2229@fbirervta.pbzchgretzou.qr> <47FCD47A.7060600@trash.net> <alpine.LNX.1.10.0804091639210.3866@fbirervta.pbzchgretzou.qr> <925A849792280C4E80C5461017A4B8A226A0F7@mail733.InfraSupportEtc.com> <47FCDC8F.5030701@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "Jan Engelhardt" <jengelh@computergmbh.de>,
	"Netfilter Developer Mailing List" <netfilter-devel@vger.kernel.org>
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.infrasupportetc.com ([66.173.97.5]:15899 "EHLO
	mail733.InfraSupportEtc.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751744AbYDIPVw convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2008 11:21:52 -0400
Content-class: urn:content-classes:message
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> I forgot why exactly you need the bridge port in iptables.

We crossed in the email a minute ago when I described my H.323 stuff.  

There was another case a year or so ago that first turned me on to
bridging.  I inherited a network that had systems with IP Addresses all
over the place both in front and behind the firewall.  It was mess.  

I tried to set up a Linux firewall with proxy ARP but the results were
very ugly.  It turned out, they had this load balancer in their network
nobody told me about and my proxy ARP and the load-balancer's proxy ARPs
got confused with each other and this took down a popular website for an
hour or so at 5 in the morning central time.  

And then I finally figured out what proxy ARP really meant when my
outside eth0 interface was proxy-ARPing.  This was in a co-lo site and
there were other customers on the same Ethernet and I ended up
proxy-ARPing for them - woops!  This didn't cause any damage but it sure
scared me to death!

Needless to say, that was the last time I ever used proxy-ARP.  

So now I use bridging whenever I have devices that need public IP
Addresses inside a mostly NATed network.

- Greg
