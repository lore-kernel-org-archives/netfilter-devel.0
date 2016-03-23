From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net-next] change nfqueue failopen to apply also to
 receive message buffer in addition to queue size
Date: Wed, 23 Mar 2016 12:58:26 +0100
Message-ID: <20160323115826.GA19066@salvia>
References: <2ba8dceec36a41149598e43f09af048e@XCH-RTP-014.cisco.com>
 <20160321213532.GA1818@salvia>
 <aecaf341ed194fd991ed1709c3634dab@XCH-RTP-014.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"Florian Westphal (fw@strlen.de)" <fw@strlen.de>
To: "Yigal Reiss (yreiss)" <yreiss@cisco.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48304 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754920AbcCWL6b (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Mar 2016 07:58:31 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 63D0C1525C5
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Mar 2016 12:58:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 09B6ADA8FB
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Mar 2016 12:58:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 303D7DA3AD
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Mar 2016 12:58:28 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <aecaf341ed194fd991ed1709c3634dab@XCH-RTP-014.cisco.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 23, 2016 at 11:40:14AM +0000, Yigal Reiss (yreiss) wrote:
> On Monday, March 21, 2016 11:36 PM, Pablo Neira Ayuso wrote:
> > So isn't the more simple patch that I'm attaching achieving what you need?
>
> Yes. I applied the patch and it works as expected. Indeed much more
> simple.
> 
> I intend to use this patch and would like it to eventually get into
> the formal kernel. Do you intend to pursue this into mainline
> kernel?

Just made a formal submission of the patch.
