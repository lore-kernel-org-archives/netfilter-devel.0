From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCH 0/5] Check u32 load in u8 attributes
Date: Wed, 10 Aug 2016 17:29:34 +0200
Message-ID: <cover.1470842571.git.nevola@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34929 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934067AbcHJTJK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Aug 2016 15:09:10 -0400
Received: by mail-wm0-f65.google.com with SMTP id i5so11401916wmg.2
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2016 12:09:10 -0700 (PDT)
Received: from sonyv (cli-5b7e49a2.wholesale.adamo.es. [91.126.73.162])
        by smtp.gmail.com with ESMTPSA id i80sm8904837wmf.11.2016.08.10.08.29.36
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Wed, 10 Aug 2016 08:29:36 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following patchset adds a check during the load of an u32 value
into an u8 attribute which can cause an overflow.


Laura Garcia Liebana (5):
  netfilter: nf_tables: Check u32 load in u8 nft_bitwise attribute
  netfilter: nf_tables: Check u32 load in u8 nft_byteorder attribute
  netfilter: nf_tables: Check u32 load in u8 nft_cmp attribute
  netfilter: nf_tables: Check u32 load in u8 nft_immediate attribute
  netfilter: nf_tables: Check u32 load in u8 nft_nat attribute

 net/netfilter/nft_bitwise.c   |  7 ++++++-
 net/netfilter/nft_byteorder.c | 13 +++++++++++--
 net/netfilter/nft_cmp.c       |  5 ++++-
 net/netfilter/nft_immediate.c |  3 +++
 net/netfilter/nft_nat.c       |  2 ++
 5 files changed, 26 insertions(+), 4 deletions(-)

-- 
2.8.1

