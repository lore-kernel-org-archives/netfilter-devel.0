From: Wes Campaigne <westacular@gmail.com>
Subject: xtables: various fixes for handling multiple src/dst addresses
Date: Mon, 21 Feb 2011 19:10:09 -0500
Message-ID: <1298333413-14253-1-git-send-email-westacular@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:65058 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab1BVAKl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Feb 2011 19:10:41 -0500
Received: by iwn34 with SMTP id 34so21597iwn.19
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Feb 2011 16:10:40 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi! I've been working on enabling robust IPv6 support in the TomatoUSB router firmware. In the process, I found and fixed a few old iptables bugs, mostly related to lookups and the handling of multiple addresses. Please review!

NOTE: TomatoUSB is actually still using an old 1.3.8 branch of iptables, and analogous versions of these patches against that version have been commited on the TomatoUSB repo at repo.or.cz/w/tomato.git tomato-RT

===
Wes Campaigne (4):
  xtables: use *all* IPv6 addresses resolved from a hostname
  xtables: fix excessive memory allocation in host_to_ipaddr
  xtables: fix the broken detection/removal of redundant addresses
  xtables: use the correct loop count when applying masks to addresses

 xtables.c |   45 ++++++++++++++++++++-------------------------
 1 files changed, 20 insertions(+), 25 deletions(-)

