From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] netfilter: helper: Fix helper unregister count.
Date: Tue, 24 May 2016 11:55:18 +0200
Message-ID: <20160524095518.GA2434@salvia>
References: <1463231993-26917-1-git-send-email-ap420073@gmail.com>
 <CA+6hz4pj-wp5Vye6GSxiZM1-Bfq=qcJCUJD0hjEbmmtRsTfhow@mail.gmail.com>
 <20160524092608.GA2132@salvia>
 <CA+6hz4qEt7CMCuTAf+8ik2LGUJ7SLVuSkkd8VCbgvL4MehEsWQ@mail.gmail.com>
 <20160524094200.GA2294@salvia>
 <CA+6hz4pHweCqvTU0UhiKHcCg=kYAj0z1t1Ow26u3njDxPHXsgg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Taehee Yoo <ap420073@gmail.com>, Patrick McHardy <kaber@trash.net>,
	kadlec@blackhole.kfki.hu,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Feng Gao <gfree.wind@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57945 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752620AbcEXJzg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2016 05:55:36 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 333EC114816
	for <netfilter-devel@vger.kernel.org>; Tue, 24 May 2016 11:55:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 22BE515D62F
	for <netfilter-devel@vger.kernel.org>; Tue, 24 May 2016 11:55:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E817615D622
	for <netfilter-devel@vger.kernel.org>; Tue, 24 May 2016 11:55:19 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CA+6hz4pHweCqvTU0UhiKHcCg=kYAj0z1t1Ow26u3njDxPHXsgg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 24, 2016 at 05:47:07PM +0800, Feng Gao wrote:
> yes.
> 
> It was my fault at that time.
> I thought there may be one problem that I forget test, so I just to notify
> you.
> I was afraid that it would break the work.

That's a valid concern, and I appreciate you indicated this. But then,
it's better if you resubmit and include in the description what you
did to test it.

> But I found i had tested that case after a while, it would not be wrong.
> Because that was my first commit to the netfilter, i don't want to break
> it. So i was too upset.

Don't get upset, it can be a bit frustrating to understand the whole
process in the beginning, and keep re-submitting if you think you're
doing the right thing.

Another note: I also remember you also posted patches out of the
"merge window".  Netfilter sticks to David Miller's net-next merge
window, which is now closed BTW. Merge window (not strictly this, but
an approximation) opens by when -rc1 is released and then it closes by
when the first mainline kernel version is released.

Thanks.
