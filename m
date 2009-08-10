From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: pom-ng and different iptables versions
Date: Mon, 10 Aug 2009 12:42:54 +0200
Message-ID: <200908101242.54570.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rs02.intra2net.com ([81.169.173.116]:40119 "EHLO
	rs02.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953AbZHJK4i (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Aug 2009 06:56:38 -0400
Received: from intranator.m.i2n (unknown [172.16.1.99])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by rs02.intra2net.com (Postfix) with ESMTP id DF3B2A1D1
	for <netfilter-devel@vger.kernel.org>; Mon, 10 Aug 2009 12:42:57 +0200 (CEST)
Received: from localhost (intranator.m.i2n [127.0.0.1])
	by localhost (Postfix) with ESMTP id 8DD4D2AC52
	for <netfilter-devel@vger.kernel.org>; Mon, 10 Aug 2009 12:42:57 +0200 (CEST)
Received: from storm.localnet (storm.m.i2n [172.16.1.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by intranator.m.i2n (Postfix) with ESMTPS id 21A3E2AC50
	for <netfilter-devel@vger.kernel.org>; Mon, 10 Aug 2009 12:42:55 +0200 (CEST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

pom-ng supports to apply the kernel part of a patchlet
depending on the kernel version via different file names:

linux-2.6.patch
linux-2.6.16.patch
linux-2.6.19.patch
...

Is something like this also possible for the "iptables" extension part?

The internal API changed after iptables 1.4.2. A user sent me a patch
for iptables 1.4.4, if possible I'd like to keep 1.4.2 support
at the same time. What's the best approach to do this?
#ifdefs? :o)

Thanks in advance,
Thomas

