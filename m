From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCH nf-next 0/2] netfilter: nft_hash: symhash type support
Date: Thu, 23 Feb 2017 12:09:38 +0100
Message-ID: <20170223110938.ttzvk7gtjk72oajx@nevthink>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wr0-f179.google.com ([209.85.128.179]:36171 "EHLO
        mail-wr0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750891AbdBWLL3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Feb 2017 06:11:29 -0500
Received: by mail-wr0-f179.google.com with SMTP id 89so19499580wrr.3
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Feb 2017 03:09:42 -0800 (PST)
Received: from nevthink ([91.126.73.162])
        by smtp.gmail.com with ESMTPSA id d42sm5572028wrd.7.2017.02.23.03.09.40
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 23 Feb 2017 03:09:40 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

These changes add support for multi hash functions and include the
symmetric hash type.

As 2 different structures are needed, we're going to rename the
nft_hash structure to nft_jhash, and then provide support for
several hash functions before including the new type.

Laura Garcia Liebana (2):
  netfilter: nft_hash: rename nft_hash to nft_jhash
  netfilter: nft_hash: support of symmetric hash

 include/uapi/linux/netfilter/nf_tables.h |  13 +++
 net/netfilter/nft_hash.c                 | 132 ++++++++++++++++++++++++++-----
 2 files changed, 127 insertions(+), 18 deletions(-)

-- 
2.11.0

