From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: iptables upgrade: netmask parsing trouble
Date: Wed, 08 May 2013 10:17:59 +0200
Message-ID: <1548294.4rj9RFaJ57@storm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from re04.intra2net.com ([82.165.46.26]:55200 "EHLO
	re04.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab3EHISC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 May 2013 04:18:02 -0400
Received: from intranator.m.i2n (unknown [172.16.1.99])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by re04.intra2net.com (Postfix) with ESMTP id A3EEF300D2
	for <netfilter-devel@vger.kernel.org>; Wed,  8 May 2013 10:18:00 +0200 (CEST)
Received: from localhost (intranator.m.i2n [127.0.0.1])
	by localhost (Postfix) with ESMTP id 79DBA2AC58
	for <netfilter-devel@vger.kernel.org>; Wed,  8 May 2013 10:18:00 +0200 (CEST)
Received: from storm.localnet (storm.m.i2n [172.16.1.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by intranator.m.i2n (Postfix) with ESMTPS id 51A9F2AC51
	for <netfilter-devel@vger.kernel.org>; Wed,  8 May 2013 10:17:59 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I've just updated from iptables 1.4.8 to 1.4.18 (git HEAD to be precise)
and now face some trouble with netmask parsing:

This used to work with 1.4.8:
-A foo -m policy --mode tunnel --dir in --tunnel-src 192.168.123.0/255.255.255.0 -j RETURN

With git HEAD I get:
iptables-restore v1.4.18: policy: bad value for option "--tunnel-src", or out of range (0-32)


This of course works:
-A foo -m policy --mode tunnel --dir in --tunnel-src 192.168.123.0/24 -j RETURN


Any reason why we don't accept the full format anymore?

Cheers,
Thomas

