From: Jan Engelhardt <jengelh@medozas.de>
Subject: nf-next: removals of old extensions/revs
Date: Tue, 23 Mar 2010 21:44:56 +0100
Message-ID: <1269377101-13875-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:46038 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753782Ab0CWUpJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Mar 2010 16:45:09 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Posting this freestanding set of 4 for review (only), as b05.. has
not been merged yet.


The following changes since commit b050368aa62ab389b00ce305157cb1dad3540666:
  Jan Engelhardt (1):
        netfilter: xtables: shorten up return clause

are available in the git repository at:

  git://dev.medozas.de/linux master3-obs

Jan Engelhardt (4):
      netfilter: xtables: remove xt_hashlimit revision 0
      netfilter: xtables: remove xt_multiport revision 0
      netfilter: xtables: remove xt_string revision 0
      netfilter: xtables: schedule xt_state for removal

 Documentation/Changes                      |    2 +-
 Documentation/feature-removal-schedule.txt |    8 +
 net/netfilter/xt_hashlimit.c               |  221 ----------------------------
 net/netfilter/xt_multiport.c               |   77 ----------
 net/netfilter/xt_string.c                  |   53 +++-----
 5 files changed, 27 insertions(+), 334 deletions(-)
