From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: iptables upgrade: NOT operator parser trouble
Date: Fri, 28 Jun 2013 19:10:36 +0200
Message-ID: <3833479.1RoPgaa84s@storm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from re04.intra2net.com ([82.165.46.26]:50531 "EHLO
	re04.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336Ab3F1RL6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Jun 2013 13:11:58 -0400
Received: from intranator.m.i2n (unknown [172.16.1.99])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by re04.intra2net.com (Postfix) with ESMTP id 7C28430128
	for <netfilter-devel@vger.kernel.org>; Fri, 28 Jun 2013 19:11:57 +0200 (CEST)
Received: from localhost (intranator.m.i2n [127.0.0.1])
	by localhost (Postfix) with ESMTP id 452AB2AC5B
	for <netfilter-devel@vger.kernel.org>; Fri, 28 Jun 2013 19:11:57 +0200 (CEST)
Received: from storm.localnet (storm.m.i2n [172.16.1.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by intranator.m.i2n (Postfix) with ESMTPS id 996E12AC57
	for <netfilter-devel@vger.kernel.org>; Fri, 28 Jun 2013 19:10:36 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I've found another issue after upgrading iptables from 1.4.8 to 1.4.18.
This rule used to work:

    iptables -A R34 --protocol tcp --dport ! 80 -j C525


iptables complains:
	iptables-restore v1.4.18: invalid port/service `!' specified


Fix the parser or fix my rules? :)

Cheers,
Thomas

