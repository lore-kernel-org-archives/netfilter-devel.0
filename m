From: Jan Engelhardt <jengelh@medozas.de>
Subject: 'nother pull request
Date: Thu, 12 Feb 2009 07:19:10 +0100
Message-ID: <1234419553-4147-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:60875 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbZBLGTP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Feb 2009 01:19:15 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


And pull again (wasnot sure if you had seen the patches already),
to receive some bugfixes I cooked in response
to ljlane's request to peek at Debian bugs.

Jan Engelhardt (3):
      libxtables: use const for vars holding literals
      libxt_string: fix undefined behavior/incorrect patlen calculation
      libxtables: flush before fork

 extensions/libxt_string.c |    4 +++-
 include/xtables.h.in      |    3 +--
 xtables.c                 |    6 ++++++
 3 files changed, 10 insertions(+), 3 deletions(-)
