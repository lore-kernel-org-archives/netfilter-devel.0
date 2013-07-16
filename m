From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [xtables-arptables PATCH 0/4] nft changes for xtables-arptables
Date: Wed, 17 Jul 2013 00:30:22 +0200
Message-ID: <20130716222925.13253.93123.stgit@nftables>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ea0-f172.google.com ([209.85.215.172]:55358 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755657Ab3GVObi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Jul 2013 10:31:38 -0400
Received: by mail-ea0-f172.google.com with SMTP id q10so3923976eaj.3
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Jul 2013 07:31:37 -0700 (PDT)
Received: from [127.0.1.1] ([37.77.121.31])
        by mx.google.com with ESMTPSA id p49sm51264213eeu.2.2013.07.22.07.31.35
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Mon, 22 Jul 2013 07:31:37 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following series implements changes in nft code that permit
to reuse some functions in other tool (like xtables-arptables).

I changed nft.h, now struct nft_handle gets a struct builtin_table
pointer used in functions to works with a properly tables and not
with tables declared in nft.c.

---

Giuseppe Longo (4):
      nft: add builtin_table pointer
      nft: search builtin tables via nft_handle tables pointer
      nft: nft_xtables_config_load() called only in nft_init()
      nft: make functions public



 iptables/nft.c |   77 ++++++++++++++++++--------------------------------------
 iptables/nft.h |   42 +++++++++++++++++++++++++++++++
 2 files changed, 67 insertions(+), 52 deletions(-)

--
