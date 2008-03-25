From: "Greg Scott" <GregScott@InfraSupportEtc.com>
Subject: RE: Ebtables hook order anomaly
Date: Tue, 25 Mar 2008 08:32:46 -0500
Message-ID: <925A849792280C4E80C5461017A4B8A226A01E@mail733.InfraSupportEtc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "Netfilter Developer Mailing List" <netfilter-devel@vger.kernel.org>
To: "Patrick McHardy" <kaber@trash.net>,
	"Jan Engelhardt" <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.infrasupportetc.com ([66.173.97.5]:16703 "EHLO
	mail733.InfraSupportEtc.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753335AbYCYNct convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2008 09:32:49 -0400
Content-class: urn:content-classes:message
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> Indeed, on output bridge netfilter will run after IPv4 netfilter.
> Does that explain things?

Well, not really.  2.6.23-2 behaves differently than 2.6.18.  My
ebtables marks get set and read by iptables in 2.6.18.  iptables does
not see them in 2.6.23.

It could be something in the order of execution changed.  I'm using
RedHat kernels right now and I know they tweak the kernels a little bit.
But surely the RedHat guys would not change something this fundamental?


I set my ebtables mark for outbound packets in two places - in the
OUTPUT chain and the FORWARD chain.  I was looking mostly at the
ebtables FORWARD chain for packets that pass thru the box.  I set the
mark in ebtables FORWARD and OUTPUT.  Iptables POSTROUTING needs to see
them so it knows to MASQUERADE.  Otherwise, things get really weird.  :)
iptables sees the marks in 2.6.18, but does not see them in 2.6.23.  

I have a couple of 2.6.23 systems here and I can brew up a 2.6.18 fc6
system later on for testing if needed.  (All the 2.6.18 stuff I have
built up right now is in production.)  I can set up some tests similarly
to Jan's testing from last night for packets passing through the box.  

Or if there's a better way to do this, I'm open.  

- Greg
