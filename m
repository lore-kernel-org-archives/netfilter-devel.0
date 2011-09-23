From: "U.Mutlu" <for-gmane@mutluit.com>
Subject: Re: [libnetfilter_queue] extra data after payload
Date: Fri, 23 Sep 2011 19:02:57 +0200
Message-ID: <j5ie42$f7k$1@dough.gmane.org>
References: <j5ibim$sen$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:49556 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138Ab1IWRDM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Sep 2011 13:03:12 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gnnd-netfilter-devel@m.gmane.org>)
	id 1R799b-0004ly-Ks
	for netfilter-devel@vger.kernel.org; Fri, 23 Sep 2011 19:03:11 +0200
Received: from p5dc8ef82.dip.t-dialin.net ([93.200.239.130])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Sep 2011 19:03:11 +0200
Received: from for-gmane by p5dc8ef82.dip.t-dialin.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Sep 2011 19:03:11 +0200
In-Reply-To: <j5ibim$sen$1@dough.gmane.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

U.Mutlu wrote, On 2011-09-23 18:19:
> Hi,
>
> when reading queue data via the recv() function
> then one gets a return value much longer than the payload data,
> so there are some extra data after the payload.
> What kind of extra data is it?
>
> for example:
> rv = recv(fd, buf, sizeof(buf), 0); // rv=84
> ...
> ret = nfq_get_payload(tb, &data); // ret=40 (ie. ip + tcp pkt, both w/o options, and tcp w/o user data)
>
> So, here, what are the extra 44 bytes after the tcp data?

Correction: the extra data is in front of the payload.

