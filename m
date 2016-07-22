From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnftnl] examples: selective rule dumping
Date: Fri, 22 Jul 2016 11:00:14 +0200
Message-ID: <20160722090014.GA2004@salvia>
References: <20160721133630.GA2050@salvia>
 <1469113181-5034-1-git-send-email-jalvarez@toulouse.viveris.com>
 <20160721161329.GA1719@salvia>
 <5791CCCD.8080808@toulouse.viveris.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: jalvarez <jalvarez@toulouse.viveris.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40614 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441AbcGVJAW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Jul 2016 05:00:22 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 82AFC11481D
	for <netfilter-devel@vger.kernel.org>; Fri, 22 Jul 2016 11:00:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 714C7FEFBF
	for <netfilter-devel@vger.kernel.org>; Fri, 22 Jul 2016 11:00:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 4D162FF154
	for <netfilter-devel@vger.kernel.org>; Fri, 22 Jul 2016 11:00:15 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <5791CCCD.8080808@toulouse.viveris.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jul 22, 2016 at 09:35:41AM +0200, jalvarez wrote:
> On 21/07/2016 18:13, Pablo Neira Ayuso wrote:
> >Please, send me your Signed-off-by: and a couple of lines with a
> >description.
> >
> >No need to resend this patch, I'll amend this myself. But please
> >include it next time. Thanks.
> 
> I apologize, I forgot to add it this time. Here are the missing lines you requested.
> 
> Improve nft-rule-get example to demonstrate selective rule dumping
> when table and / or chain attributes are set in a rule dump request.
> Usage is now as follows : nft-rule-get <family> [<table> <chain>]
> [<xml|json>].
> 
> Signed-off-by: Josue Alvarez<jalvarez@toulouse.viveris.com>

OK, applied, thanks.

Just for the record, I have also cleaned up a bit the code btw.
