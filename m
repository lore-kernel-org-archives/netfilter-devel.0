From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [xtables-arptables PATCH v2 0/5] nft changes for xtables-arptables
Date: Tue, 23 Jul 2013 18:11:43 +0200
Message-ID: <20130723161017.10040.6256.stgit@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:49003 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933285Ab3GWQMF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Jul 2013 12:12:05 -0400
Received: by mail-we0-f177.google.com with SMTP id m46so572377wev.8
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jul 2013 09:12:03 -0700 (PDT)
Received: from [127.0.0.1] (adsl-ull-226-41.46-151.net24.it. [151.46.41.226])
        by mx.google.com with ESMTPSA id mb20sm7001728wic.1.2013.07.23.09.12.00
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Tue, 23 Jul 2013 09:12:02 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following series implements changes in nft code that permit
to reuse some functions in other tool (like xtables-arptables).

I changed nft.h, now struct nft_handle gets a struct builtin_table
pointer used in functions to works with a properly tables and not
with tables declared in nft.c.

---

Giuseppe Longo (5):
      nft: add builtin_table
      nft: search builtin tables via nft_handle tables pointer
      nft: nft_xtables_config_load() called only in nft_init()
      nft: make functions public
      nft: replace args.family



 iptables/nft.c                |   82 +++++++++++++++--------------------------
 iptables/nft.h                |   44 ++++++++++++++++++++++
 iptables/xtables-config.c     |    9 +++--
 iptables/xtables-restore.c    |   19 +++++-----
 iptables/xtables-save.c       |   18 +++++----
 iptables/xtables-standalone.c |   16 +++-----
 iptables/xtables.c            |    9 ++++-
 7 files changed, 111 insertions(+), 86 deletions(-)

-- 

