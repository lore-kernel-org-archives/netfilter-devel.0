From: =?UTF-8?B?6JeN5oy655GL?= <lantw44@gmail.com>
Subject: nft produces incorrect output when a reject rule is added using nft
 -f
Date: Sun, 04 Jan 2015 16:17:25 +0800
Message-ID: <54A8F715.60408@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:48998 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbbADIR2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 4 Jan 2015 03:17:28 -0500
Received: by mail-pd0-f174.google.com with SMTP id fp1so25978144pdb.5
        for <netfilter-devel@vger.kernel.org>; Sun, 04 Jan 2015 00:17:27 -0800 (PST)
Received: from wn.lant.com.tw ([175.181.43.117])
        by mx.google.com with ESMTPSA id ig1sm51023972pbc.41.2015.01.04.00.17.26
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 04 Jan 2015 00:17:26 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It seems there is a bug related to the reject rule in both nftables 0.4
and the master branch. I reported the bug here:
https://bugzilla.netfilter.org/show_bug.cgi?id=993. Is it a known problem?


