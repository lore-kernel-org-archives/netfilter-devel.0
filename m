From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: merge of iptables-tests to master
Date: Tue, 30 Sep 2014 19:53:22 +0200
Message-ID: <20140930175322.GA9585@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55716 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753828AbaI3RwU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Sep 2014 13:52:20 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Short notice. I'll merge the automated regression tests for iptables
in this branch.

http://git.netfilter.org/iptables/log/?h=tests

By this week. They have remained in a separated branch for quite some
time. They should help to catch problems in the iptables-nftables
compatibility layer.
