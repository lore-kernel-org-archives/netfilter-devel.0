From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ANNOUNCE] iptables 1.6.0 release
Date: Fri, 18 Dec 2015 21:17:28 +0100
Message-ID: <20151218201728.GA17439@salvia>
References: <20151218200453.GA13109@salvia>
 <alpine.LSU.2.20.1512182110250.16656@nerf40.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	netfilter-announce@lists.netfilter.org, lwn@lwn.net
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52750 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964879AbbLRURs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Dec 2015 15:17:48 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id B3164132A8E
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Dec 2015 21:17:46 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 76D70DA809
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Dec 2015 21:17:46 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 64678DA7FF
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Dec 2015 21:17:44 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.20.1512182110250.16656@nerf40.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 18, 2015 at 09:13:55PM +0100, Jan Engelhardt wrote:
> 
> On Friday 2015-12-18 21:04, Pablo Neira Ayuso wrote:
> >        iptables 1.6.0
> >You can download it from:
> >http://www.netfilter.org/projects/conntrack-tools/downloads.html
> >ftp://ftp.netfilter.org/pub/conntrack-tools/
> 
> There used to be a HTTP location for the downloads,
> http://netfilter.org/projects/iptables/files/ .
> 
> This seems to be not pointing to the same directory as the ftp://
> location above, or, if they are deliberately different directories,
> the synchronization has not occurred yet. Is one of them
> (non-)official?

This should be:

http://www.netfilter.org/projects/iptables/downloads.html
ftp://ftp.netfilter.org/pub/iptables/

The website is compiling, the update should be upstream soon.
