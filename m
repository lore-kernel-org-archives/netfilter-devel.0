From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/1] ipset patch for nf
Date: Mon, 21 Mar 2016 22:37:30 +0100
Message-ID: <20160321213730.GA1885@salvia>
References: <1458162150-13601-1-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35403 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745AbcCUVhi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Mar 2016 17:37:38 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 5E4C2C125B
	for <netfilter-devel@vger.kernel.org>; Mon, 21 Mar 2016 22:37:37 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 43732DA8F8
	for <netfilter-devel@vger.kernel.org>; Mon, 21 Mar 2016 22:37:37 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 66502DA385
	for <netfilter-devel@vger.kernel.org>; Mon, 21 Mar 2016 22:37:35 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1458162150-13601-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 16, 2016 at 10:02:29PM +0100, Jozsef Kadlecsik wrote:
> Hi Pablo,
> 
> Please apply the next patch against the nf tree:
> 
> - There was a race condition between parallel save/swap and delete,
>   which resulted a kernel crash due to the increase ref for save, swap,
>   wrong ref decrease operations. Reported and fixed by Vishwanath Pai.
> 
> The patch should be applied to the older stable kernel branches too.
> 
> Best regards,
> Jozsef
> 
> The following changes since commit fe1c3e3f630ef7765f34d9585d6b524899502b3f:
> 
>   netfilter: ipset: Check IPSET_ATTR_ETHER netlink attribute length (2016-03-16 21:43:50 +0100)
> 
> are available in the git repository at:
> 
>   git://blackhole.kfki.hu/nf master

Pulled, thanks Jozsef.
