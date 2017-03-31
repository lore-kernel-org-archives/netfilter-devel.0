From: Arushi Singhal <arushisinghal19971997@gmail.com>
Subject: [PATCH 0/4] Multiple checkpatch issues.
Date: Fri, 31 Mar 2017 21:43:47 +0530
Message-ID: <20170331161351.26141-1-arushisinghal19971997@gmail.com>
Cc: Arushi Singhal <arushisinghal19971997@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:35040 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933126AbdCaQOA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 31 Mar 2017 12:14:00 -0400
Received: by mail-pg0-f68.google.com with SMTP id g2so18324701pge.2
        for <netfilter-devel@vger.kernel.org>; Fri, 31 Mar 2017 09:13:59 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Solved the multiple checkpatch issues.

Arushi Singhal (4):
  iptables: iptables: Add blank line after declaration
  iptables: iptables: Remove assignment in if condition
  iptables: iptables: Indent the code.
  iptables: iptables: switch and case should be at the same indent

 iptables/getethertype.c      |  4 ++-
 iptables/ip6tables-restore.c | 62 ++++++++++++++++++++++----------------------
 iptables/nft-arp.c           |  3 ++-
 iptables/xtables-arp.c       |  4 +--
 iptables/xtables-eb.c        |  4 +--
 5 files changed, 40 insertions(+), 37 deletions(-)

-- 
2.11.0

