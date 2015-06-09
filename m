From: Andreas Schultz <aschultz@tpip.net>
Subject: iptables nftables compat weirdness
Date: Tue, 9 Jun 2015 11:16:30 +0000 (UTC)
Message-ID: <1424744661.225751.1433848590972.JavaMail.zimbra@tpip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.tpip.net ([92.43.49.48]:33262 "EHLO mail.tpip.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753046AbbFILYj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Jun 2015 07:24:39 -0400
Received: from office.tpip.net (office.tpip.net [92.43.51.2])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.tpip.net (Postfix) with ESMTPS id 9A5544F403
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Jun 2015 11:16:31 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by office.tpip.net (Postfix) with ESMTP id 7857A3A9855
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Jun 2015 11:16:31 +0000 (UTC)
Received: from office.tpip.net ([127.0.0.1])
	by localhost (office.tpip.net [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id Z0u0qwjcNgvo for <netfilter-devel@vger.kernel.org>;
	Tue,  9 Jun 2015 11:16:31 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by office.tpip.net (Postfix) with ESMTP id 1E2143A984F
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Jun 2015 11:16:31 +0000 (UTC)
Received: from office.tpip.net ([127.0.0.1])
	by localhost (office.tpip.net [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id NmKW9LZF5Bc6 for <netfilter-devel@vger.kernel.org>;
	Tue,  9 Jun 2015 11:16:31 +0000 (UTC)
Received: from office.tpip.net (office.tpip.net [92.43.51.2])
	by office.tpip.net (Postfix) with ESMTP id 084793A9851
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Jun 2015 11:16:31 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

While testing iptables-compat, I've come across some weird behavior:

# iptables-compat -t mangle -N TEST
# iptables-compat -t mangle -A PREROUTING -j TEST 

This works nicely, but when we put something in the TEST chain:

# iptables-compat -t mangle -A TEST -j MARK --set-mark 0x80000000/0x80000000
# iptables-compat -t mangle -A PREROUTING -j TEST
iptables-compat: Invalid argument. Run `dmesg' for more information.

dmesg does not contain any information.

The same problem exists for all default chains in mangle, filter and nat.

Kernel is: 4.1-rc5
iptables: git://git.netfilter.org/iptables, branch master,   commit 0bb1859e2d6dd79a0a59c3ee65f6a78cba118b86
nftables: git://git.netfilter.org/nftables, branch next-4.1, commit a93bc1795b272174a10d90961a248f2c620bfa2c


Any ideas?

Regards
Andreas

-- 
-- 
Andreas Schultz
