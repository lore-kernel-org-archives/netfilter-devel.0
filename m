From: Alexey Perevalov <alexey.perevalov@hotmail.com>
Subject: Re: nfacct: add filter in to the list operation
Date: Sun, 7 Sep 2014 10:32:59 +0400
Message-ID: <BLU436-SMTP19F461BF570CCFBE9D09658DC00@phx.gbl>
References: <20140826194501.GA4789@salvia>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Alexey Perevalov <a.perevalov@samsung.com>,
	kyungmin.park@samsung.com, hs81.go@samsung.com,
	netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from blu004-omc1s17.hotmail.com ([65.55.116.28]:61070 "EHLO
	BLU004-OMC1S17.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751903AbaIGGde (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 7 Sep 2014 02:33:34 -0400
In-Reply-To: <20140826194501.GA4789@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello Pablo,

Also I have several remarks about command line parsing of the nfacct tool,
 in general.
1. reset and other options, including new, they are position insensetive.
e.g. reset could follow after counters
2. option occurrences, e.g. #nfacct list reset reset reset.
Maybe it wasn't so important before, but now for filter options it's important.
For example #nfacct list counters overquota
will show overquoted counters only, end user, in this case, will not get any
error.

So, do you think it worth to fix?
Also do you plan to include nfacct functionality into nft tool?

ps. Sorry I forgot in previous mail to cc netfilter-devel.

Alexey Perevalov (1):
  nfacct: add filter in to the list operation

 include/linux/netfilter/nfnetlink_acct.h |    8 ++++
 src/nfacct.c                             |   63 ++++++++++++++++++++++++++++++
 2 files changed, 71 insertions(+)

-- 
1.7.9.5

