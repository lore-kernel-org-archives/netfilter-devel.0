From: Jan Engelhardt <jengelh@medozas.de>
Subject: iptables: pull request June-05
Date: Fri,  5 Jun 2009 21:25:52 +0200
Message-ID: <1244229955-27642-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:35721 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbZFETZ5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jun 2009 15:25:57 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi,


in another working copy I found these accumulated pieces:

	Jan Engelhardt (2):
	      DNAT/SNAT: add manpage documentation for --persistent flag
	      extensions: remove redundant casts

	Michael Granzow (1):
	      iptables: accept multiple IP address specifications for -s, -d

They have now been uploaded, so please pull once again from
	git://dev.medozas.de/iptables master

 configure.ac                 |    4 +-
 extensions/libipt_DNAT.man   |    7 +-
 extensions/libipt_SAME.man   |    2 +
 extensions/libipt_SNAT.man   |    7 +-
 extensions/libipt_realm.c    |    4 +-
 extensions/libxt_multiport.c |   12 ++--
 include/xtables.h.in         |    5 +
 ip6tables.c                  |   49 ++++++++-----
 iptables.8.in                |    7 +-
 iptables.c                   |   42 +++++++---
 xtables.c                    |  175 ++++++++++++++++++++++++++++++++++++++++++
 11 files changed, 268 insertions(+), 46 deletions(-)
