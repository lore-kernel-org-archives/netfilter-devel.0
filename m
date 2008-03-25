From: "Greg Scott" <GregScott@InfraSupportEtc.com>
Subject: RE: Ebtables hook order anomaly
Date: Tue, 25 Mar 2008 09:17:37 -0500
Message-ID: <925A849792280C4E80C5461017A4B8A226A020@mail733.InfraSupportEtc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "Jan Engelhardt" <jengelh@computergmbh.de>,
	"Netfilter Developer Mailing List" <netfilter-devel@vger.kernel.org>
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.infrasupportetc.com ([66.173.97.5]:18429 "EHLO
	mail733.InfraSupportEtc.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752865AbYCYORj convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2008 10:17:39 -0400
Content-class: urn:content-classes:message
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> For routed packets you can't make any decisions in iptables based on 
> the outgoing bridge port, thats only possible for purely bridged 
> traffic.

Bummer - but at least I now know the rules.  I guess I'll test using
source IP Address.  That kind of works - I know what stuff is on either
side - but it's messy.  

Thanks

- GReg
