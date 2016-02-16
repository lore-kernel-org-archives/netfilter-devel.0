From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Merging iptables-translate branch into master
Date: Tue, 16 Feb 2016 19:38:26 +0100
Message-ID: <20160216183826.GA28273@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41364 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755507AbcBPSih (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Feb 2016 13:38:37 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id D0538E6645
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Feb 2016 19:38:35 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C0A20AD91
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Feb 2016 19:38:35 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B5DD0ADCC
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Feb 2016 19:38:31 +0100 (CET)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

During a Netfilter lunch meeting during NetDev 1.1, we agreed on
merging the translation infrastructure into master.

For those that are not familiar, the new iptables-translate provides a
translation to the nft syntax, eg.

# iptables-translate -A INPUT -m tcp --dport 22 -j ACCEPT
nft add rule ip filter INPUT tcp dport 22 counter accept

So far, there are translation for ~30 extensions. Shivani took the
time to document this on the wiki.nftables.org site.

Please, help us testing and providing new translation. Thanks.
