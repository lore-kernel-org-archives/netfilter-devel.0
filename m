From: Jan Engelhardt <jengelh@medozas.de>
Subject: nf-next: checks and misc
Date: Thu, 18 Mar 2010 14:24:24 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1003181422230.17133@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:46983 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752441Ab0CRNYZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Mar 2010 09:24:25 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,


these are the issue-free parts of the previous submission (thus
no repost of the commits themselves). Please merge.


The following changes since commit e8a96f69383f3d88cdc06d8ccd450f70c48628a3:
  Patrick McHardy (1):
        Merge branch 'master' of ../nf-2.6

are available in the git repository at:

  git://dev.medozas.de/linux master

Jan Engelhardt (4):
      netfilter: xtables: do without explicit XT_ALIGN
      netfilter: xtables: clean up xt_mac match routine
      netfilter: xtables: limit xt_mac to ethernet devices
      netfilter: xtables: resort osf kconfig text

 net/netfilter/Kconfig  |   26 +++++++++++++-------------
 net/netfilter/xt_CT.c  |    2 +-
 net/netfilter/xt_LED.c |    2 +-
 net/netfilter/xt_mac.c |   21 +++++++++++++--------
 4 files changed, 28 insertions(+), 23 deletions(-)
