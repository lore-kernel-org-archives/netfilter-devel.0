From: kaber@trash.net
Subject: [PATCH 0/1] netfilter: netfilter fixes
Date: Wed,  9 Feb 2011 15:39:28 +0100
Message-ID: <1297262369-26393-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:52922 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755599Ab1BIOju (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Feb 2011 09:39:50 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Dave,

following is a single netfilter fix for net-2.6.git, fixing use of conntrack
templates when TCP conntrack kills the current conntrack in TIME_WAIT state
in order to have the conntrack core create a fresh one, from Pablo.

Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/kaber/nf-2.6.git master

Thanks!

