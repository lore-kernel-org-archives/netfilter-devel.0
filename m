From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/1] ipset patch for nf
Date: Thu, 10 Mar 2016 19:28:16 +0100
Message-ID: <20160310182816.GB21139@salvia>
References: <1457466260-20373-1-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46521 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752574AbcCJS2X (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Mar 2016 13:28:23 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id AAFBBC9ED5
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Mar 2016 19:28:21 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 9A55CDA383
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Mar 2016 19:28:21 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A9F86DA392
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Mar 2016 19:28:19 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1457466260-20373-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 08, 2016 at 08:44:19PM +0100, Jozsef Kadlecsik wrote:
> Hi Pablo,
> 
> Please apply the next patch against the nf tree:
> 
> - Julia Lawall pointed out that IPSET_ATTR_ETHER netlink attribute
>   length was not checked explicitly. The patch adds the missing
>   checkings.
> 
> The patch should be applied to the older stable kernel branches too.
> 
> Best regards,
> Jozsef
> 
> The following changes since commit 45040978c8994d1401baf5cc5ac71c1495d4e120:
> 
>   netfilter: ipset: Fix set:list type crash when flush/dump set in parallel (2016-02-24 20:32:21 +0100)
> 
> are available in the git repository at:
> 
>   git://blackhole.kfki.hu/nf master

This patch also came with the previous pull, so this will show up in
the nf-next tree too.

Thanks.
