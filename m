From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] libxtables: change option precedence order to be intuitive
Date: Mon, 15 Nov 2010 13:28:15 +0100
Message-ID: <1289824097-27337-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:57886 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452Ab0KOM2T (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Nov 2010 07:28:19 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 648fd1ad68ae2ec675ac07efee80783912535404:
                                   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

  libxt_TOS: avoid an undesired overflowing computation (2010-11-02 09:17:09 +0100)

are available in the git repository at:
  git://dev.medozas.de/iptables master

Jan Engelhardt (1):
      iptables: fix longopt reecognition and workaround getopt(3) behavior

 ip6tables.c |    1 +
 iptables.c  |    1 +
 xtables.c   |    3 ++-
 3 files changed, 4 insertions(+), 1 deletions(-)
