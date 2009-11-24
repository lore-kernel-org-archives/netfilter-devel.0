From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: next iptables release
Date: Tue, 24 Nov 2009 16:07:31 +0100
Message-ID: <1259075255-25781-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:36319 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933214AbZKXPHb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Nov 2009 10:07:31 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 596c69007acb569843391e4c98dc21d6f2336e7b:
  Patrick McHardy (1):
        DNAT: fix incorrect check during parsing

are available in the git repository at:

  git://dev.medozas.de/iptables master

Jan Engelhardt (3):
      iptables: take masks into consideration for replace command
      doc: explain experienced --hitcount limit
      doc: name resolution clarification

 extensions/libxt_recent.man |    4 +++-
 ip6tables.8.in              |   10 ++++++----
 ip6tables.c                 |   10 ++++++----
 iptables.8.in               |    8 +++++---
 iptables.c                  |   10 ++++++----
 5 files changed, 26 insertions(+), 16 deletions(-)
