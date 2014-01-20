From: Anders Berggren <anders@halon.se>
Subject: nftable atomic rule replacement/update/restore?
Date: Mon, 20 Jan 2014 22:10:50 +0100
Message-ID: <A2B302C7-AD8B-4239-BD8E-8E0FA29721B7@halon.se>
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail1.hsp.halon.se ([213.80.29.50]:40106 "EHLO
	mail1.hsp.halon.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaATVQl convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Jan 2014 16:16:41 -0500
Received: from mail.halon.se (unknown [213.80.29.51])
	by mail1.hsp.halon.se (Halon Mail Gateway) with ESMTP
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Jan 2014 22:10:59 +0100 (CET)
Received: from [192.168.0.108] (c-4b9970d5.019-139-67626713.cust.bredbandsbolaget.se [213.112.153.75])
	by mail.halon.se (Postfix) with ESMTPSA id DB3234DF02
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Jan 2014 22:10:50 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I apologise if this isn't the appropriate mailing list. Also, congratulations on the 3.13 inclusion, and 0.99 release!

After browsing the code I didn't find any atomic ruleset update/restore functionality, as described by http://marc.info/?l=netfilter-devel&m=135959066918397&w=2 and present in iptables-restore and possibly pfctl -f ...

If it's not currently implemented, I would suggest something like:

# nft -f myruleset
# cat rulesetset
table filter {
	chain input {
		type filter hook input priority 0;
		ct state established accept
		...

so that the user can have a nicely formated firewall configuration file, applied by a simple command.