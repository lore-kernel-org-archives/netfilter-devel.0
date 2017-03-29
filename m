From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH 0/2] iptables: Fix multiple checkpatch issues.
Date: Thu, 30 Mar 2017 00:56:38 +0530
Message-ID: <58dc0a73.437c630a.9094a.51f4@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: outreachy-kernel <outreachy-kernel@googlegroups.com>
To: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:34808 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753325AbdC2T0p (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Mar 2017 15:26:45 -0400
Received: by mail-pg0-f66.google.com with SMTP id o123so4141327pga.1
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Mar 2017 12:26:44 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patchset fixes multiple checkpatch issues.

Varsha Rao (2):
  iptables: Remove explicit static variables initalization.
  iptables: Remove unnecessary braces.

 iptables/ip6tables-restore.c   |  2 +-
 iptables/ip6tables-save.c      |  2 +-
 iptables/iptables-restore.c    |  2 +-
 iptables/iptables-save.c       |  2 +-
 iptables/iptables-standalone.c |  3 +--
 iptables/iptables-xml.c        | 10 +++++-----
 iptables/iptables.c            |  3 +--
 iptables/xtables-arp.c         |  2 +-
 iptables/xtables-standalone.c  |  3 +--
 iptables/xtables-translate.c   |  6 ++----
 10 files changed, 15 insertions(+), 20 deletions(-)

-- 
2.9.3

