From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH 0/2] Add syntax and translation for comment module
Date: Tue, 22 Dec 2015 15:47:30 +0530
Message-ID: <cover.1450779140.git.shivanib134@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:33209 "EHLO
	mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932181AbbLVKRh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Dec 2015 05:17:37 -0500
Received: by mail-pf0-f170.google.com with SMTP id n128so87787031pfn.0
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2015 02:17:37 -0800 (PST)
Received: from gmail.com ([171.50.109.40])
        by smtp.gmail.com with ESMTPSA id h80sm10378394pfd.44.2015.12.22.02.17.34
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Tue, 22 Dec 2015 02:17:36 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patchset adds the appropriate syntax for comment module that is,
counter should be used as prefix with comment module unlike all other
modules. Also, it adds the appropriate translation to nft.

After applying this patchset, iptables-translate produces correct
translation for comment module to nft.

Shivani Bhardwaj (2):
  iptables: nft-ipv4: Remove suffix counter for comment module
  extensions: libxt_comment: Add translation to nft

 extensions/libxt_comment.c | 17 +++++++++++++++--
 iptables/nft-ipv4.c        | 25 +++++++++++++++----------
 2 files changed, 30 insertions(+), 12 deletions(-)

-- 
1.9.1

