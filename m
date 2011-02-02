From: kaber@trash.net
Subject: [PATCH 00/26] netfilter: netfilter update
Date: Thu,  3 Feb 2011 00:11:38 +0100
Message-ID: <1296688324-7830-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44713 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350Ab1BBXMa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Feb 2011 18:12:30 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Dave,

following is another netfilter update for net-next-2.6, containing:

- IP set from Jozsef, with some bugfixes from Jozsef and me on top

- IPVS fixes from Simon

- a new xtables 'devgroup' match to match on the network device group,
  from myself

Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/kaber/nf-next-2.6.git master

Thanks!

