From: Peter Warasin <peter@endian.com>
Subject: [PATCH 0/3] iptables-edit: tool to apply iptables rules to iptables-save'ed
 statefiles
Date: Sat, 20 Oct 2007 02:56:49 +0200
Message-ID: <47195251.6050805@endian.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from solaria.endian.it ([80.190.199.145]:40330 "EHLO
	solaria.endian.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754644AbXJTBYl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Oct 2007 21:24:41 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by solaria.endian.it (Postfix) with ESMTP id B8CAA59830F
	for <netfilter-devel@vger.kernel.org>; Sat, 20 Oct 2007 02:56:53 +0200 (CEST)
Received: from solaria.endian.it ([127.0.0.1])
	by localhost (solaria.endian.it [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UfrPZauvC3Ks for <netfilter-devel@vger.kernel.org>;
	Sat, 20 Oct 2007 02:56:51 +0200 (CEST)
Received: from [10.139.200.200] (host92-108-dynamic.54-82-r.retail.telecomitalia.it [82.54.108.92])
	by solaria.endian.it (Postfix) with ESMTP id 1437859821F
	for <netfilter-devel@vger.kernel.org>; Sat, 20 Oct 2007 02:56:51 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi guys

This patchset introduces a new tool called iptables-edit, which allows
to apply iptables rules on an iptables-save'd state file instead of
applying it to the kernel.

This allows to minimize the outage of firewall script which rebuild the
entire ruleset from scratch when something changed within it's
configuration.

It uses functionality from iptables-save and iptables-restore, therefore
the patchset reorganizes those functionality in separate files.

The patchset is against iptables 1.3.8.

Please advice me if i should port it to another version or subversion
repository.

I will start with man page and ip6tables-edit as well if the patch makes
sense to you.

Please let me know what you think

Regards,
peter

-- 
:: e n d i a n
:: open source - open minds

:: peter warasin
:: http://www.endian.com   :: peter@endian.com
