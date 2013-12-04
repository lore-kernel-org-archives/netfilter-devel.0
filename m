From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Merging iptables-nftables into iptables
Date: Wed, 4 Dec 2013 12:48:34 +0100
Message-ID: <20131204114834.GA13280@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49202 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932099Ab3LDLsj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Dec 2013 06:48:39 -0500
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

The iptables-nftables tree [1] currently stores the iptables over
nftables compatibility support. This allows you to run iptables
commands using the nftables kernel infrastructure.

JFYI, my plan is to merge the iptables-nftables into iptables at some
point of this week given that it contains stuff that is scheduled for
3.13.  After that merge, the iptables-nftables will be disabled.

[1] http://git.netfilter.org/iptables-nftables/
