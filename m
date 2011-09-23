From: "U.Mutlu" <for-gmane@mutluit.com>
Subject: [libnetfilter_queue] extra data after payload
Date: Fri, 23 Sep 2011 18:19:32 +0200
Message-ID: <j5ibim$sen$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:41228 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424Ab1IWQTv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Sep 2011 12:19:51 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gnnd-netfilter-devel@m.gmane.org>)
	id 1R78Td-0007js-3S
	for netfilter-devel@vger.kernel.org; Fri, 23 Sep 2011 18:19:49 +0200
Received: from p5dc8ef82.dip.t-dialin.net ([93.200.239.130])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Sep 2011 18:19:49 +0200
Received: from for-gmane by p5dc8ef82.dip.t-dialin.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Sep 2011 18:19:49 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

when reading queue data via the recv() function
then one gets a return value much longer than the payload data,
so there are some extra data after the payload.
What kind of extra data is it?

for example:
   rv  = recv(fd, buf, sizeof(buf), 0);   // rv=84
   ...
   ret = nfq_get_payload(tb, &data);      // ret=40 (ie. ip + tcp pkt, both w/o options, and tcp w/o user data)

So, here, what are the extra 44 bytes after the tcp data?

