From: Patrick McHardy <kaber@trash.net>
Subject: Re: SIP messages with no/invalid CSeq are dropped by nf_ct_sip, 400
 Bad Request is expected instead
Date: Thu, 24 Sep 2015 12:19:08 +0100
Message-ID: <20150924111908.GA32673@macbook.localdomain>
References: <5603BA34.60700@c-s.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>, netfilter@vger.kernel.org,
	TIXADOU Jean-Yves <jean-yves.tixadou@c-s.fr>,
	PERRONNY Olivier <olivier.perronny@c-s.fr>
To: Christophe Leroy <christophe.leroy@c-s.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40719 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380AbbIXL2k (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Sep 2015 07:28:40 -0400
Content-Disposition: inline
In-Reply-To: <5603BA34.60700@c-s.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 24.09, Christophe Leroy wrote:
> I have an issue with the SIP conntrack:
> 
> In commit 30f33e6dee [NETFILTER]: nf_conntrack_sip: support method specific
> request/response handling
> Modified by b20ab9cc63 netfilter: nf_ct_helper: better logging for dropped
> packets
> 
> SIP requests with no CSeq header are dropped by kernel before reaching the
> user app.
> 
> According to RFC4475 "Session Initiation Protocol (SIP) Torture Test
> Messages", requests with invalid CSeq should be responded with 400 Bad
> Request, and that's what my app does, but it can only do it if it receives
> the request.

I don't see anything about missing CSeq-headers in that RFC, could you point
me to the correct chapter?
