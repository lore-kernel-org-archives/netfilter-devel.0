From: Yanchuan Nian <ycnian@gmail.com>
Subject: [nft] Byteorder problem still exists in nft
Date: Mon,  1 Sep 2014 17:25:54 +0800
Message-ID: <1409563554-1563-1-git-send-email-ycnian@gmail.com>
Cc: Yanchuan Nian <ycnian@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:62449 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbaIAJXW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Sep 2014 05:23:22 -0400
Received: by mail-pa0-f54.google.com with SMTP id fb1so11929906pad.13
        for <netfilter-devel@vger.kernel.org>; Mon, 01 Sep 2014 02:23:18 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,
There are still some byteorder prolems in nft.

The first one:
nft> add rule bridge filter input ip saddr 192.168.1.1 counter
nft> list table bridge filter
table bridge filter {
	chain input {
		 type filter hook input priority 0;
		 unknown unknown 0xc0a80101 [invalid type] counter packets 0 bytes 0
	}
}
nft>
I guess this error occurs in payload_gen_dependency() which set the byteorder
host endian but ether type is big endian.

The second one:
nft> add rule ip filter input ip length > 10 counter
BUG: invalid byte order conversion 0 => 2
nft: src/evaluate.c:153: byteorder_conversion_op: Assertion `0' failed.
This is because the datatype of ip length is integer_type whose byteorder is invalid.
