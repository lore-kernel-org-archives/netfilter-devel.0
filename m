From: Steven Jan Springl <steven@springl.ukfsn.org>
Subject: Implicit loading of module xt_set.
Date: Tue, 5 Jul 2011 17:12:31 +0100
Message-ID: <201107051712.32139.steven@springl.ukfsn.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.springl.ukfsn.org ([84.45.199.6]:50261 "EHLO
	mail.springl.ukfsn.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755316Ab1GEQTb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Jul 2011 12:19:31 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.springl.ukfsn.org (Postfix) with ESMTP id 04C7E20D30
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Jul 2011 17:13:57 +0100 (BST)
Received: from mail.springl.ukfsn.org ([127.0.0.1])
	by localhost (l2.home [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CCRU6n6hIF35 for <netfilter-devel@vger.kernel.org>;
	Tue,  5 Jul 2011 17:13:56 +0100 (BST)
Received: from l3.home (l3.home [IPv6:2001:4d48:ad51:24:250:daff:fe6d:bbdd])
	by mail.springl.ukfsn.org (Postfix) with ESMTP id 4522D20D06
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Jul 2011 17:13:56 +0100 (BST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello

The following command implicitly loads module xt_set:

ip6tables -A INPUT -m set --match-set sjs src -j ACCEPT

However, the following command does not implicitly load module xt_set:

iptables -A INPUT -m set --match-set sjs src -j ACCEPT

Instead the following message is issued:

iptables: No chain/target/match by that name.

Is this behaviour expected?

Steven.
