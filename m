From: kaber@trash.net
Subject: [PATCH 00/13] netfilter: netfilter update
Date: Wed,  2 Mar 2011 13:12:40 +0100
Message-ID: <1299067973-15977-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:32944 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757259Ab1CBMNA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Mar 2011 07:13:00 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Dave,

following is a netfilter update for net-next, containing:

- minor cleanups and bugfixes

- a fix for a bridge netfilter information leak, from Vasiliy Kulikov

- IPVS timer fixes, from Tinggong Wang

- conversion of the IPVS hash table to hlists, from Changli

- TCP conntrack improvements, from Pablo

Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/kaber/nf-next-2.6.git master

Thanks!
