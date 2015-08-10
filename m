From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [lnf-log RFC PATCH 0/2] introduce new functions to use without
 nflog_handle
Date: Mon, 10 Aug 2015 17:13:42 +0900
Message-ID: <20150810081342.GB25169@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:33438 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287AbbHJINr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Aug 2015 04:13:47 -0400
Received: by pdrh1 with SMTP id h1so50852092pdr.0
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Aug 2015 01:13:47 -0700 (PDT)
Received: from gmail.com (softbank220009032004.bbtec.net. [220.9.32.4])
        by smtp.gmail.com with ESMTPSA id ns14sm18937467pdb.17.2015.08.10.01.13.46
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Aug 2015 01:13:46 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 Hi,

I am trying to extend ulogd to introduce mmaped netlink socket. The
current libnetfilter_log can not be used since it presumes to use a
normal socket.

This patch adds new functions which can parse nlmsg without
nflog_handle. It would be helpful for me to be accepted to the
master, how about it?

Thanks,
