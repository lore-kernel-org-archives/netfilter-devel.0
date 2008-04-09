From: "Greg Scott" <GregScott@InfraSupportEtc.com>
Subject: RE: Ebtables hook order anomaly
Date: Wed, 9 Apr 2008 10:39:17 -0500
Message-ID: <925A849792280C4E80C5461017A4B8A226A0FA@mail733.InfraSupportEtc.com>
References: <925A849792280C4E80C5461017A4B8A226A019@mail733.InfraSupportEtc.com> <alpine.LNX.1.10.0803250301140.9368@fbirervta.pbzchgretzou.qr> <alpine.LNX.1.10.0803250455030.9368@fbirervta.pbzchgretzou.qr> <47E8F6B4.4030800@trash.net> <alpine.LNX.1.10.0804081645450.2229@fbirervta.pbzchgretzou.qr> <47FCD47A.7060600@trash.net> <alpine.LNX.1.10.0804091639210.3866@fbirervta.pbzchgretzou.qr> <925A849792280C4E80C5461017A4B8A226A0F7@mail733.InfraSupportEtc.com> <47FCDC8F.5030701@trash.net> <925A849792280C4E80C5461017A4B8A226A0F9@mail733.InfraSupportEtc.com> <47FCDF8D.8050107@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "Jan Engelhardt" <jengelh@computergmbh.de>,
	"Netfilter Developer Mailing List" <netfilter-devel@vger.kernel.org>
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.infrasupportetc.com ([66.173.97.5]:16471 "EHLO
	mail733.InfraSupportEtc.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751634AbYDIPjS convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2008 11:39:18 -0400
Content-class: urn:content-classes:message
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>>> I forgot why exactly you need the bridge port in iptables.
>> 
>> We crossed in the email a minute ago when I described my H.323 stuff.


> Yes, but I was wondering more about the exact rules where
> this would be helpful. The things you described in your
> other mail sounds easily doable by simply exluding port
> 1723 from NAT without any knowledge of bridge ports.

I also need to know the direction - is the packet going back inside or
out to the Internet.  Same for input - is it coming from the inside or
coming in from the Internet.  Input is more important than output - but
knowing the output direction would be nice.  

Examples - 

I have a section in iptables-NAT-PREROUTING that tests on input for
anything from 10.n/8 or 172.16/12 or 192.168/16.  If in from the
Internet than I log and drop it.  Without knowing the in-interface, I
don't know how I would do those tests.  

Here is a forward rule for outbound stuff that broke with the recent
change:

$IPTABLES -A FORWARD -m mark --mark 3 -j ACCEPT
# Packets marked with 3 (bits 0 and 1 set) are outbound to the Internet.

The mark was for anything from the inside going out to the Internet.  

The FORWARD rules are not always that simple.  I have some sites that
need to regulate what can go out.  With the new ebtables order, I can
deal with that with IP Addresses instead of eth interfaces.  But it
would still be nice to have the ability to regulate by interface instead
of IP Address.  

Here was another one that made me scratch my bald head most of the night
before Easter - when this rule broke, you can imagine the weird
behavior:

echo "	MASQUERADing everything else going outbound"
##$IPTABLES -t nat -A POSTROUTING -m mark --mark 3 -j LOG --log-prefix
"mark3 "
$IPTABLES -t nat -A POSTROUTING -m mark --mark 3 -j MASQUERADE

I can change this to test for any IP Address other than the local LAN
and it should work.  It just makes things a little more complicated for
sites that have many local LANs.

- Greg
