From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 2/3] meta: add prandom matching
Date: Tue, 16 Feb 2016 17:28:08 +0100
Message-ID: <20160216162808.GC3504@salvia>
References: <DB5D81F9-A143-4DE6-A315-465B72EA84B3@trash.net>
 <20160204144646.GA25780@breakpoint.cc>
 <20160204152711.GA3853@macbook.localdomain>
 <20160204153240.GB25780@breakpoint.cc>
 <20160204160937.GA13973@breakpoint.cc>
 <20160204164243.GB13973@breakpoint.cc>
 <20160204174029.GB13157@macbook.localdomain>
 <20160215125446.GA23168@breakpoint.cc>
 <20160216114523.GA2502@salvia>
 <20160216120024.GB13417@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46111 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932387AbcBPQ2M (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Feb 2016 11:28:12 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 8BFD56DFD8
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Feb 2016 17:28:11 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 7D32891F7
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Feb 2016 17:28:11 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 906D091F5
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Feb 2016 17:28:09 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160216120024.GB13417@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 16, 2016 at 01:00:24PM +0100, Florian Westphal wrote:
> I understand, but,  the proposed float and probability types
> are very different, and allow for very little re-use.

I see, then stick to the probability datatype.
