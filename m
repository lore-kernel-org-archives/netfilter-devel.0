From: "Greg Scott" <GregScott@InfraSupportEtc.com>
Subject: RE: Ebtables hook order anomaly
Date: Sun, 30 Mar 2008 16:21:12 -0500
Message-ID: <925A849792280C4E80C5461017A4B8A226A084@mail733.InfraSupportEtc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "Netfilter Developer Mailing List" <netfilter-devel@vger.kernel.org>
To: "Patrick McHardy" <kaber@trash.net>,
	"Jan Engelhardt" <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.infrasupportetc.com ([66.173.97.5]:56009 "EHLO
	mail733.InfraSupportEtc.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753188AbYC3VVO convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Mar 2008 17:21:14 -0400
Content-class: urn:content-classes:message
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> This still seems to work - ebtables BROUTE still seems to come 
> before iptables NAT PREROUTING and my ebtables BROUTE marks all 
> show up in iptables.  Am I on solid ground for the future if I 
> keep this up?

So can I count on this working for the long term?

ie - Can I mark packets in ebtables-BROUTE based on the in-interface and
then read the mark later on in iptables?  (I already know I can't do
this any more for the out-interface.)

Thanks

- Greg
