From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: New xlate3 branch in iptables
Date: Tue, 22 Dec 2015 17:54:14 +0100
Message-ID: <20151222165414.GA20549@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35783 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755151AbbLVRA6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Dec 2015 12:00:58 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 9B75923CF6B
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2015 18:00:57 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8E746DA843
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2015 18:00:57 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 7B018DA862
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2015 18:00:55 +0100 (CET)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Shivani,

Please use the new xlate3 branch as reference in your work:

http://git.netfilter.org/iptables/log/?h=xlate3

I have rebased the xlate2 branch on top of current iptables git HEAD,
so we can easily merge this translation infrastructure once it becomes
a bit more complete.

Thanks.
