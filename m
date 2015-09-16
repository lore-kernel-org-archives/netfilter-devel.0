From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl 0/2] map fixes
Date: Wed, 16 Sep 2015 15:06:50 +0200
Message-ID: <1442408812-28799-1-git-send-email-pablo@netfilter.org>
Cc: jengelh@inai.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39179 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752306AbbIPNAZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Sep 2015 09:00:25 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following patchset contains map fixes to address the problems reported by
Jan Engelhardt.

Pablo Neira Ayuso (2):
  src: move new set and set_elem symbols to new group
  src: move new nftnl symbols to new group

 src/libnftnl.map |  136 ++++++++++++++++++++++++------------------------------
 1 file changed, 60 insertions(+), 76 deletions(-)

-- 
1.7.10.4

