From: Jan Engelhardt <jengelh@medozas.de>
Subject: (unknown)
Date: Wed,  5 Aug 2009 18:22:33 +0200
Message-ID: <1249489355-20598-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:55947 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934019AbZHEQWk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Aug 2009 12:22:40 -0400
Subject: 
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Please pull from
	git://dev.medozas.de/iptables master

to receive

Jan Engelhardt (2+1):
      xt_conntrack: revision 2 for enlarged state_mask member
      libxt_helper: fix invalid passed option to check_inverse
      Merge branch 'stable'

Diffstat:
Updating 80fcb7b..8e4daca
Fast forward
 extensions/libxt_conntrack.c           |  159 +++++++++++++++++++++++++++----
 extensions/libxt_helper.c              |    2 +-
 include/linux/netfilter/xt_conntrack.h |   13 +++
 3 files changed, 152 insertions(+), 22 deletions(-)
