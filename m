From: Gargi Sharma <gs051095@gmail.com>
Subject: [PATCH 0/4] Constify option structures
Date: Tue, 28 Mar 2017 00:15:26 +0530
Message-ID: <cover.1490640256.git.gs051095@gmail.com>
Cc: pablo@netfilter.orgm, outreachy-kernel@googlegroups.com,
        Gargi Sharma <gs051095@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:34014 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752149AbdC0Sq1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Mar 2017 14:46:27 -0400
Received: by mail-pg0-f65.google.com with SMTP id o123so12301004pga.1
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Mar 2017 11:46:21 -0700 (PDT)
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


Gargi Sharma (4):
  extensions: libebt_limit: Constify option struct
  extenstions: libebt_mark_m: Constify option struct
  extensions: libebt_mark: Constify option struct
  extensions: libebt_nflog: Constify option struct

 extensions/libebt_limit.c  | 2 +-
 extensions/libebt_mark.c   | 2 +-
 extensions/libebt_mark_m.c | 2 +-
 extensions/libebt_nflog.c  | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

-- 
2.7.4

