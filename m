From: ravin goyal <ravirocks1021@gmail.com>
Subject: Conntrack timestamp
Date: Sat, 2 Apr 2016 11:54:16 +0530
Message-ID: <CANU0Mn3daSz9sAAfDxhn5x13_H3pJLeDY=sRsdMF_fB_FjVtBA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:36244 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbcDBGYh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Apr 2016 02:24:37 -0400
Received: by mail-ob0-f170.google.com with SMTP id j9so16312553obd.3
        for <netfilter-devel@vger.kernel.org>; Fri, 01 Apr 2016 23:24:37 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi

Regarding conntrack events using conntrack -E -o ktimestamp, is there
any way that i can get start and stop timestamp in unixtime format
rather than regular human readable format

Regards
Ravin Goyal
