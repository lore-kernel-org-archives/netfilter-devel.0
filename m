From: Steven Jan Springl <steven@springl.ukfsn.org>
Subject: arptables bug.
Date: Sat, 5 Jan 2013 20:56:18 +0000
Message-ID: <201301052056.18524.steven@springl.ukfsn.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.springl.ukfsn.org ([84.45.199.6]:38419 "EHLO
	mail.springl.ukfsn.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755865Ab3AEVFT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Jan 2013 16:05:19 -0500
Received: from localhost (localhost [127.0.0.1])
	by mail.springl.ukfsn.org (Postfix) with ESMTP id 4E8A4880053
	for <netfilter-devel@vger.kernel.org>; Sat,  5 Jan 2013 20:56:20 +0000 (GMT)
Received: from mail.springl.ukfsn.org ([127.0.0.1])
	by localhost (es1.home [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7yaPTMrEr3K8 for <netfilter-devel@vger.kernel.org>;
	Sat,  5 Jan 2013 20:56:19 +0000 (GMT)
Received: from l9.localnet (l9.home [IPv6:2001:4d48:ad52:500:e2cb:4eff:feb4:8d52])
	by mail.springl.ukfsn.org (Postfix) with ESMTP id F3350880046
	for <netfilter-devel@vger.kernel.org>; Sat,  5 Jan 2013 20:56:18 +0000 (GMT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello

I am using arptables v0.0.3.4 in Debian Squeeze.

Issuing command:

aptables -A INPUT -i eth0 --opcode ! 1 -j DROP

Then issuing command arptables-save produces the following:

-A INPUT -j DROP -i eth0  --opcode 1

The "!" is missing from the opcode.

Regards.

Steven.
