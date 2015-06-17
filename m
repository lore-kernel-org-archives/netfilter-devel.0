From: Markus Koetter <koetter@rrzn.uni-hannover.de>
Subject: [PATCH 0/5] nft trace
Date: Wed, 17 Jun 2015 22:07:32 +0200
Message-ID: <1434571657-20047-1-git-send-email-koetter@rrzn.uni-hannover.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout2.uni-hannover.de ([130.75.2.114]:38460 "EHLO
	mailout2.uni-hannover.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbbFQUO3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Jun 2015 16:14:29 -0400
Received: from localhost (localhost [127.0.0.1])
	by mailout2.uni-hannover.de (Postfix) with ESMTP id 1BEDD609C
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Jun 2015 22:04:01 +0200 (CEST)
Received: from mailout2.uni-hannover.de ([127.0.0.1])
	by localhost (mailout2.uni-hannover.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sMHk782o91Zp for <netfilter-devel@vger.kernel.org>;
	Wed, 17 Jun 2015 22:04:01 +0200 (CEST)
Received: from hass1404.example.prv (p4FDA71FA.dip0.t-ipconnect.de [79.218.113.250])
	(Authenticated sender: koetter@rrzn.uni-hannover.de)
	by mailout2.uni-hannover.de (Postfix) with ESMTPSA id DF1EC608A
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Jun 2015 22:04:00 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds a new command to nft - the trace command.
The trace command reads NFLOG messages, parses TRACE: messages and prints the
rules in a human readable format.
To trace, you have to set the trace mark on a packet and run "nft trace".
Patch is split into 5 parts, 
 - adding the command, 
 - storing the chain policy during delinearize for later use
 - creating a rule cache to look up the rules
 - implementing the actual command
 - code to log a packet header 'similar' to ip/nftables LOG

Markus Koetter (5):
  parser: add trace command
  netlink: delinarize chain policy
  rule: make cache creation a function
  trace: implement commands action
  trace: add log for packets

 include/Makefile.am |   2 +
 include/log.h       |  17 ++
 include/rule.h      |  15 +
 include/trace.h     |   2 +
 src/Makefile.am     |   2 +
 src/evaluate.c      |   2 +
 src/log.c           | 779 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 src/netlink.c       |   4 +
 src/parser_bison.y  |  16 +-
 src/rule.c          | 121 ++++++--
 src/scanner.l       |   1 +
 src/trace.c         | 361 ++++++++++++++++++++++++
 12 files changed, 1291 insertions(+), 31 deletions(-)
 create mode 100644 include/log.h
 create mode 100644 include/trace.h
 create mode 100644 src/log.c
 create mode 100644 src/trace.c

-- 
1.9.1

