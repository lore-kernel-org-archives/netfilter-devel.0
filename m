From: Mart Frauenlob <mart.frauenlob@chello.at>
Subject: [PATCH 0/2] iptables: utils: Add bash completion
Date: Thu, 25 Feb 2016 16:06:52 +0100
Message-ID: <1456412814-4580-1-git-send-email-mart.frauenlob@chello.at>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vie01a-qmta-at02-2.mx.upcmail.net ([62.179.121.176]:32044 "EHLO
	vie01a-qmta-at02-2.mx.upcmail.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760202AbcBYPY4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Feb 2016 10:24:56 -0500
Received: from [172.31.218.30] (helo=vie01a-dmta-at03-3.mx.upcmail.net)
	by vie01a-pqmta-at02.mx.upcmail.net with esmtps (UNKNOWN:AES256-GCM-SHA384:256)
	(Exim 4.72)
	(envelope-from <mart.frauenlob@chello.at>)
	id 1aYxVR-0007xK-Rb
	for netfilter-devel@vger.kernel.org; Thu, 25 Feb 2016 16:07:05 +0100
Received: from [172.31.216.43] (helo=vie01a-pemc-psmtp-pe01)
	by vie01a-dmta-at03.mx.upcmail.net with esmtp (Exim 4.72)
	(envelope-from <mart.frauenlob@chello.at>)
	id 1aYxVO-00014J-Or
	for netfilter-devel@vger.kernel.org; Thu, 25 Feb 2016 16:07:02 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Good day!

The first patch adds completion code for the bash shell.
The second patch adds it to the build routine.

Would be great if you consider it.

Best regards,
Mart

---
 configure.ac                             |   13 +
 utils/Makefile.am                        |    3 +
 utils/iptables_bash_completion/README.md |  290 ++++
 utils/iptables_bash_completion/iptables  | 2426 ++++++++++++++++++++++++++++++
 4 files changed, 2732 insertions(+), 0 deletions(-)
 create mode 100644 utils/iptables_bash_completion/README.md
 create mode 100644 utils/iptables_bash_completion/iptables
---
