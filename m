From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/4, V2, libnftnl] tests: Fix segfaults due outbound
 access
Date: Sat, 13 Aug 2016 12:12:10 +0200
Message-ID: <20160813101210.GD1376@salvia>
References: <20160811233222.GB5108@salvia>
 <20160812201722.10134-1-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56994 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243AbcHMKNA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 13 Aug 2016 06:13:00 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 3ACDCA4175
	for <netfilter-devel@vger.kernel.org>; Sat, 13 Aug 2016 12:12:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2C609A90D
	for <netfilter-devel@vger.kernel.org>; Sat, 13 Aug 2016 12:12:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 11E3CA90D
	for <netfilter-devel@vger.kernel.org>; Sat, 13 Aug 2016 12:12:40 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160812201722.10134-1-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Aug 12, 2016 at 10:17:19PM +0200, Carlos Falgueras García wrote:
> Changes random values for macros because the conversion to string of these
> values are performed by accessing to an array of strings.

Then, we should fix the functions to return "unknown" for out of bound
access of the array.

I think you have to fix this in the library, not the test.
