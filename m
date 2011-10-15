From: "U.Mutlu" <for-gmane@mutluit.com>
Subject: [libnetfilter_queue] setting verdict somewhere else than in the cb
Date: Sat, 15 Oct 2011 13:04:21 +0200
Message-ID: <j7bpbl$lr4$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:41971 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040Ab1JOLEh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 15 Oct 2011 07:04:37 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gnnd-netfilter-devel@m.gmane.org>)
	id 1RF22c-0001BF-Lm
	for netfilter-devel@vger.kernel.org; Sat, 15 Oct 2011 13:04:34 +0200
Received: from p4fc33b9d.dip.t-dialin.net ([79.195.59.157])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Sat, 15 Oct 2011 13:04:34 +0200
Received: from for-gmane by p4fc33b9d.dip.t-dialin.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Sat, 15 Oct 2011 13:04:34 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

some questions regarding setting the verdict of queued pkts:

1) Is it neccessary/mandatory to set the verdict in the callback?
    For performance reasons I rather would save the important data
    (ie. h, id etc.) in my own queue, return as quickly as possible
    with a 0 from the cb, and set the verdict when processing that
    own queue by a different thread, but in the mean time the arrival
    of new packets should not be blocked, is it?

2) Is it ok to set the verdict not neccessarily in original
    pkt rcv order? I mean is it mandatory to set the verdict
    in the same order as the packet receive order?
    (I guess not, but just wanted to be sure before starting coding)

3) Somewhere I read stating "The callback is expected to call either
    nfq_set_verdict() or nfq_set_verdict_mark() before returning"
    ( --> http://lists.netfilter.org/pipermail/netfilter-devel/2007-March/027381.html )
    I guess, and hope, that this info is not accurate b/c of my requirement in #1 above, is it?

Thx


