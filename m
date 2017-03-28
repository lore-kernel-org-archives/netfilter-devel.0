From: Gargi Sharma <gs051095@gmail.com>
Subject: [PATCH 0/3] ebtables: Constify option struct
Date: Tue, 28 Mar 2017 16:57:48 +0530
Message-ID: <cover.1490699407.git.gs051095@gmail.com>
Cc: pablo@netfilter.org, outreachy-kernel@googlegroups.com,
        Gargi Sharma <gs051095@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:34994 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755471AbdC1L2N (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Mar 2017 07:28:13 -0400
Received: by mail-pg0-f66.google.com with SMTP id g2so20605128pge.2
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Mar 2017 04:28:12 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The struct option is generally used only to initialise
fields inside certain structs and is not modified anywhere.
Done using Coccinelle:

@r1 disable optional_qualifier@
identifier s,i;
position p;
@@

static struct option i@p[] ={...};

@ok1@
identifier r1.i;
expression e;
position p;
@@
e = i@p

@bad@
position p != {r1.p,ok1.p};
identifier r1.i;
@@
e@i@p

@depends on !bad disable optional_qualifier@
identifier r1.i;
@@
static
+const
struct option i[] = { ... };

Gargi Sharma (3):
  ebtables: extensions: Constify option struct
  ebtables: extensions: Constify option struct
  ebtables: extensions: Constify option struct

 extensions/ebt_802_3.c    | 2 +-
 extensions/ebt_among.c    | 2 +-
 extensions/ebt_arp.c      | 2 +-
 extensions/ebt_arpreply.c | 2 +-
 extensions/ebt_inat.c     | 4 ++--
 extensions/ebt_ip.c       | 2 +-
 extensions/ebt_limit.c    | 2 +-
 extensions/ebt_log.c      | 2 +-
 extensions/ebt_mark.c     | 2 +-
 extensions/ebt_mark_m.c   | 2 +-
 extensions/ebt_nat.c      | 4 ++--
 extensions/ebt_nflog.c    | 2 +-
 extensions/ebt_pkttype.c  | 2 +-
 extensions/ebt_redirect.c | 2 +-
 extensions/ebt_standard.c | 2 +-
 extensions/ebt_stp.c      | 2 +-
 extensions/ebt_ulog.c     | 2 +-
 extensions/ebt_vlan.c     | 2 +-
 18 files changed, 20 insertions(+), 20 deletions(-)

-- 
2.7.4

