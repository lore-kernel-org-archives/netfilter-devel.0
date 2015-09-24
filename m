From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: SIP messages with no/invalid CSeq are dropped by nf_ct_sip, 400 Bad
 Request is expected instead
Date: Thu, 24 Sep 2015 10:54:12 +0200
Message-ID: <5603BA34.60700@c-s.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>, netfilter@vger.kernel.org,
	TIXADOU Jean-Yves <jean-yves.tixadou@c-s.fr>,
	PERRONNY Olivier <olivier.perronny@c-s.fr>
To: Patrick McHardy <kaber@trash.net>,
	"David S. Miller" <davem@davemloft.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 2.236.17.93.rev.sfr.net ([93.17.236.2]:2304 "EHLO
	mailhub1.si.c-s.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750900AbbIXJcV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Sep 2015 05:32:21 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I have an issue with the SIP conntrack:

In commit 30f33e6dee [NETFILTER]: nf_conntrack_sip: support method 
specific request/response handling
Modified by b20ab9cc63 netfilter: nf_ct_helper: better logging for 
dropped packets

SIP requests with no CSeq header are dropped by kernel before reaching 
the user app.

According to RFC4475 "Session Initiation Protocol (SIP) Torture Test 
Messages", requests with invalid CSeq should be responded with 400 Bad 
Request, and that's what my app does, but it can only do it if it 
receives the request.

How can we solve that ?

Christophe
