From: kaber@trash.net
Subject: [PATCH 00/01] netfilter: netfilter fix for net-next
Date: Wed, 16 Mar 2011 18:38:30 +0100
Message-ID: <1300297111-28116-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35606 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962Ab1CPRif (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Mar 2011 13:38:35 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Dave,

following is a single netfilter fix from Thomas for net-next. The new
AUDIT target is supposed to work with ebtables, however it returns
a xtables verdict, which are unfortunately incompatible with ebtables
verdicts.

Please apply or pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/kaber/nf-next-2.6.git master

Thanks!

