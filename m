From: Jan Engelhardt <jengelh@medozas.de>
Subject: nf-next: obsolete old extension revisions
Date: Wed, 31 Mar 2010 10:03:44 +0200
Message-ID: <1270022629-2494-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:40381 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906Ab0CaIDw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Mar 2010 04:03:52 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit f95c74e33eff5e3fe9798e2dc0a7749150ea3f80:
  Jan Engelhardt (1):
        netfilter: xtables: shorten up return clause

are available in the git repository at:

  git://dev.medozas.de/linux master

Jan Engelhardt (4):
      netfilter: xtables: remove xt_hashlimit revision 0
      netfilter: xtables: remove xt_multiport revision 0
      netfilter: xtables: remove xt_string revision 0
      netfilter: xtables: merge registration structure to NFPROTO_UNSPEC

 Documentation/Changes        |    2 +-
 net/netfilter/xt_hashlimit.c |  221 ------------------------------------------
 net/netfilter/xt_multiport.c |   77 ---------------
 net/netfilter/xt_state.c     |   31 ++----
 net/netfilter/xt_string.c    |   53 ++++-------
 5 files changed, 29 insertions(+), 355 deletions(-)
