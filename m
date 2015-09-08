From: Jan Engelhardt <jengelh@inai.de>
Subject: RE: [PATCH v1 1/1] fix: resource leakage when loading library using
 dlopen
Date: Tue, 8 Sep 2015 10:55:30 +0200 (CEST)
Message-ID: <alpine.LSU.2.20.1509081051090.24872@nerf40.vanv.qr>
References: <1441622536-15123-1-git-send-email-imran.zaman@intel.com>,<alpine.LSU.2.20.1509071238500.579@nerf40.vanv.qr> <0851720D2FAA48479DE89E28AEACE10E3B69D763@IRSMSX102.ger.corp.intel.com>,<alpine.LSU.2.20.1509071506190.2437@nerf40.vanv.qr>
 <0851720D2FAA48479DE89E28AEACE10E3B69DAA6@IRSMSX102.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: "Zaman, Imran" <imran.zaman@intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:45078 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753984AbbIHIzb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Sep 2015 04:55:31 -0400
In-Reply-To: <0851720D2FAA48479DE89E28AEACE10E3B69DAA6@IRSMSX102.ger.corp.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2015-09-08 09:02, Zaman, Imran wrote:

>Well! I tend to disagree here..
>
>Any resource should be freed immediately if it is not in use..

Yet they are in use until xtables-main.c:78 or so.

>Do you know when is 'ptr' get free'd and at which point in code?

xtables-main.c:93:	exit(!ret)
