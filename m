From: Jan Engelhardt <jengelh@medozas.de>
Subject: ipset: unused parameter removal
Date: Sat,  8 Jan 2011 04:14:37 +0100
Message-ID: <1294456479-4401-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:48620 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751538Ab1AHDOk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Jan 2011 22:14:40 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 2c76d78838671f1e7da9a0b01703801d8996eb98:

  Merge branch 'master' of git://dev.medozas.de/ipset (2011-01-03 10:07:59 +0100)

are available in the git repository at:

  git://dev.medozas.de/ipset master

Jan Engelhardt (1):
      kernel: remove unused ctnl parameter from call_ad

 kernel/ip_set.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)
