From: kaber@trash.net
Subject: [PATCH 0/2] netfilter: netfilter fixes for 2.6.38
Date: Wed,  2 Mar 2011 12:56:19 +0100
Message-ID: <1299066981-14058-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:65379 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754485Ab1CBL4f (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Mar 2011 06:56:35 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Dave,

the following patches fix two IPVS/netfilter bugs:

- incorrect locking in __ip_vs_update_dest(), from Julian

- a potential oops when binding or unbinding an invalid address family
  through nfnetlink_log, from Jan

Please apply or pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/kaber/nf-2.6.git master

Thanks!
