From: Yanchuan Nian <ycnian@gmail.com>
Subject: [nft] Some network services cannot be recognized
Date: Tue,  2 Sep 2014 14:58:17 +0800
Message-ID: <1409641097-16356-1-git-send-email-ycnian@gmail.com>
Cc: Yanchuan Nian <ycnian@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:34070 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbaIBGzi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Sep 2014 02:55:38 -0400
Received: by mail-pa0-f48.google.com with SMTP id ey11so13906045pad.7
        for <netfilter-devel@vger.kernel.org>; Mon, 01 Sep 2014 23:55:35 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When matching network service, we can identify it by protocol name or
port number, but
(1) some names include special characters, such as
    whois++ (63), sql*net(66), 914c/g(211)
(2) some names start with a number, such as
    9pfs(564), 3com-amp3(629), 3comnetman(1181), 3l-l1(1511), 3ds-lm(1538)
(3) some names conflict with keywords in nft, such as
    set(257), monitor(561), checksum(1386)
In these cases, the network service cannot be recognized correctly.
