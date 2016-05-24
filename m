From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] netfilter: helper: Fix helper unregister count.
Date: Tue, 24 May 2016 12:14:10 +0200
Message-ID: <20160524101410.GB2724@salvia>
References: <1463231993-26917-1-git-send-email-ap420073@gmail.com>
 <CA+6hz4pj-wp5Vye6GSxiZM1-Bfq=qcJCUJD0hjEbmmtRsTfhow@mail.gmail.com>
 <20160524092608.GA2132@salvia>
 <CA+6hz4qEt7CMCuTAf+8ik2LGUJ7SLVuSkkd8VCbgvL4MehEsWQ@mail.gmail.com>
 <20160524094200.GA2294@salvia>
 <CA+6hz4pHweCqvTU0UhiKHcCg=kYAj0z1t1Ow26u3njDxPHXsgg@mail.gmail.com>
 <20160524095518.GA2434@salvia>
 <CA+6hz4reMcuYk=x5ouJbgb=YogR9ycnoySEDy2XuSiGZj7CDPg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Taehee Yoo <ap420073@gmail.com>, Patrick McHardy <kaber@trash.net>,
	kadlec@blackhole.kfki.hu,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Feng Gao <gfree.wind@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37436 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581AbcEXKOR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2016 06:14:17 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id ACD3E13C0D5
	for <netfilter-devel@vger.kernel.org>; Tue, 24 May 2016 12:14:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 9A293A876
	for <netfilter-devel@vger.kernel.org>; Tue, 24 May 2016 12:14:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 0707415D62C
	for <netfilter-devel@vger.kernel.org>; Tue, 24 May 2016 12:14:12 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CA+6hz4reMcuYk=x5ouJbgb=YogR9ycnoySEDy2XuSiGZj7CDPg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 24, 2016 at 06:03:41PM +0800, Feng Gao wrote:
> Hi Pablo,
> 
> Then could you give me some tips that how could i should to do next?
> Rebase the codes, and resubmit the commit about register helpers?
> Or Give up this and try to other commits?

Let's get the fixes in the tree first. Then, I'd suggest you follow up
with your patches once the fixes show up in nf-next.
