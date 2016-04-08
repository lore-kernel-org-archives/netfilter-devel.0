From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Possible segfault in nft utility
Date: Fri, 8 Apr 2016 13:51:44 +0200
Message-ID: <20160408115144.GA7003@salvia>
References: <60982738E3650D41B91037A907B50C6A31797345@MXAMU25.adm.ds.fhnw.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Meyer Raffaele <raffaele.meyer@fhnw.ch>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36387 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757956AbcDHLv7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 Apr 2016 07:51:59 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 07577C9ED1
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Apr 2016 13:51:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id EB0FEDA38B
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Apr 2016 13:51:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E2591DA8F7
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Apr 2016 13:51:50 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <60982738E3650D41B91037A907B50C6A31797345@MXAMU25.adm.ds.fhnw.ch>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 08, 2016 at 11:10:47AM +0000, Meyer Raffaele wrote:
> Dear Sir or Madam
> 
> I am currently using nftables under Ubuntu 15.10. Kernel version is 4.2.0-16-generic and nftables version is nftables v0.4 (Support Edward Snowden).
> I was looking for a way to match packets based on the mss optional value in the tcp header. While using the describe command, I encountered a segfault:
> 
> user@machine:~$ nft describe tcp reserved
> Segmentation fault (core dumped)

This is already fixed in 0.5 as weel as in the upcoming 0.6 release.

# nft describe tcp reserved 
payload expression, datatype integer (integer), 4 bits

> It is not really a bad bug since the reserved keyword is probably
> not used anyway but I thought to report it. At the same time I
> wanted to ask if it is possible to match packets on wether they have
> a MaximumSegmentSize set in the TCP header or not.

Several people already asked for TCP options matching already, this is
coming soon.
