From: "Greg Scott" <GregScott@InfraSupportEtc.com>
Subject: RE: Ebtables hook order anomaly
Date: Thu, 27 Mar 2008 02:55:44 -0500
Message-ID: <925A849792280C4E80C5461017A4B8A226A03B@mail733.InfraSupportEtc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "Netfilter Developer Mailing List" <netfilter-devel@vger.kernel.org>
To: "Patrick McHardy" <kaber@trash.net>,
	"Jan Engelhardt" <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.infrasupportetc.com ([66.173.97.5]:6029 "EHLO
	mail733.InfraSupportEtc.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754281AbYC0Hzq convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Mar 2008 03:55:46 -0400
Content-class: urn:content-classes:message
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>>> and POSTROUTING hook until the outgoing bridge port was determined
by 
>>> the bridge code. This "feature" was removed because it broke all 
>>> kinds of things, now the order matches the layering and IPv4 hooks 
>>> are always processed entirely before bridging.
>> 
>> Now the order is .. non-consistent.
>> On a pure bridge forward (-i br -o br), as I have determined, 
>> ebtables-nat-POSTROUTING comes _before_ the IPv4 hooks.
>
> Thats indeed inconsistent. I don't believe this has changed however, 
> the IPv4 POSTROUTING hook was always called from the bridge
POSTROUTING 
> hook (with similar priorities).

This woke me up in the middle of the night - I also mark packets in
ebtables BROUTE based on the incoming interface and then test all over
the place in iptables based on that mark.  One of the most important is
a test for -s {private IP Address} coming in from the Internet.  But
there are lots of other tests based on source IP and incoming interface.
I really really really need to know the incoming interface.  

This still seems to work - ebtables BROUTE still seems to come before
iptables NAT PREROUTING and my ebtables BROUTE marks all show up in
iptables.  Am I on solid ground for the future if I keep this up?

Thanks

- Greg
