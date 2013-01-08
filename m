From: Steven Jan Springl <steven@springl.ukfsn.org>
Subject: Possible arptables bug.
Date: Tue, 8 Jan 2013 10:32:53 +0000
Message-ID: <201301081032.53926.steven@springl.ukfsn.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.springl.ukfsn.org ([84.45.199.6]:39317 "EHLO
	mail.springl.ukfsn.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab3AHKdC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Jan 2013 05:33:02 -0500
Received: from localhost (localhost [127.0.0.1])
	by mail.springl.ukfsn.org (Postfix) with ESMTP id 98FF6880053
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Jan 2013 10:32:55 +0000 (GMT)
Received: from mail.springl.ukfsn.org ([127.0.0.1])
	by localhost (es1.home [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SuSqaaLDJ3eP for <netfilter-devel@vger.kernel.org>;
	Tue,  8 Jan 2013 10:32:54 +0000 (GMT)
Received: from l9.localnet (l9.home [IPv6:2001:4d48:ad52:500:e2cb:4eff:feb4:8d52])
	by mail.springl.ukfsn.org (Postfix) with ESMTP id 4C12088004D
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Jan 2013 10:32:54 +0000 (GMT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello

arptables-save tries to convert any IP addresses to DNS names.
Is this the expected behaviour?

If it is the expected behaviour, is there any way that it can be disabled as
arptables-save hangs until the DNS lookup times out if DNS is not available?

Steven.
