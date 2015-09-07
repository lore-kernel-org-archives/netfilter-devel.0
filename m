From: Jan Engelhardt <jengelh@inai.de>
Subject: RE: [PATCH v1 1/1] fix: resource leakage when loading library using
 dlopen
Date: Mon, 7 Sep 2015 15:08:26 +0200 (CEST)
Message-ID: <alpine.LSU.2.20.1509071506190.2437@nerf40.vanv.qr>
References: <1441622536-15123-1-git-send-email-imran.zaman@intel.com>,<alpine.LSU.2.20.1509071238500.579@nerf40.vanv.qr> <0851720D2FAA48479DE89E28AEACE10E3B69D763@IRSMSX102.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: "Zaman, Imran" <imran.zaman@intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:42811 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975AbbIGNIa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Sep 2015 09:08:30 -0400
In-Reply-To: <0851720D2FAA48479DE89E28AEACE10E3B69D763@IRSMSX102.ger.corp.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2015-09-07 12:52, Zaman, Imran wrote:

>Aah. ookey.. so it needs to be moved two lines below.. 

At which point it's almost useless, because the program will end if the 
requested extension cannot be loaded.

>What about the caller of the function? is it getting closed at any stage?

Implicitly at program exit.

It's not pretty valgrind-wise, but implicit resource freeing 
seems a not-uncommon practice for some programs.
