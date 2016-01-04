From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH 0/2] Add support for ttl translation
Date: Mon, 4 Jan 2016 22:49:10 +0530
Message-ID: <cover.1451927507.git.shivanib134@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:35371 "EHLO
	mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611AbcADRTS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Jan 2016 12:19:18 -0500
Received: by mail-pf0-f181.google.com with SMTP id 78so207059136pfw.2
        for <netfilter-devel@vger.kernel.org>; Mon, 04 Jan 2016 09:19:17 -0800 (PST)
Received: from gmail.com ([106.201.42.190])
        by smtp.gmail.com with ESMTPSA id m87sm91976881pfi.51.2016.01.04.09.19.15
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Mon, 04 Jan 2016 09:19:16 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patchset adds ttl translation to nftables by adding ip ttl to
the buffer everytime a ttl match is hit as it is necessary to mention
the protocol version with ttl, that is, 
$ sudo nft .. ttl 3 ..             won't work but
$ sudo nft .. ip ttl 3 ..          would work.
Also, since adding ip to the buffer in the code for ttl won't look
suitable, some amendments have been done in the nft-ipv4 code.

Shivani Bhardwaj (2):
  iptables: nft-ipv4: Add ip ttl to the buffer
  extensions: libipt_ttl: Add translation to nft

 extensions/libipt_ttl.c | 28 ++++++++++++++++++++++++++++
 iptables/nft-ipv4.c     |  3 +++
 2 files changed, 31 insertions(+)

-- 
1.9.1

