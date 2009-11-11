From: Jan Engelhardt <jengelh@medozas.de>
Subject: ipset manpage adjustments
Date: Wed, 11 Nov 2009 13:54:17 +0100
Message-ID: <1257944062-6988-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:43723 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754729AbZKKMyU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Nov 2009 07:54:20 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit a8231be7ebf6086d21a25ea6d4a46a5117697189:
  Jozsef Kadlecsik (1):
        Corrected kernel/ChangeLog entry

are available in the git repository at:

  git://dev.medozas.de/ipset master

Jan Engelhardt (4):
      doc: fix an unbalanced tag
      doc: make emphasis markup consistent
      doc: escape dashes in manpage
      doc: clarify terms "ip" and "cidrsize"

 ipset.8 |  265 +++++++++++++++++++++++++++++----------------------------------
 1 files changed, 121 insertions(+), 144 deletions(-)
