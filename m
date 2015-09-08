From: "Zaman, Imran" <imran.zaman@intel.com>
Subject: RE: [PATCH v1 1/1] fix: resource leakage when loading library using
 dlopen
Date: Tue, 8 Sep 2015 09:50:13 +0000
Message-ID: <0851720D2FAA48479DE89E28AEACE10E3B69DB51@IRSMSX102.ger.corp.intel.com>
References: <1441622536-15123-1-git-send-email-imran.zaman@intel.com>,<alpine.LSU.2.20.1509071238500.579@nerf40.vanv.qr>
 <0851720D2FAA48479DE89E28AEACE10E3B69D763@IRSMSX102.ger.corp.intel.com>,<alpine.LSU.2.20.1509071506190.2437@nerf40.vanv.qr>
 <0851720D2FAA48479DE89E28AEACE10E3B69DAA6@IRSMSX102.ger.corp.intel.com>,<alpine.LSU.2.20.1509081051090.24872@nerf40.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:54759 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754098AbbIHJuV convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Sep 2015 05:50:21 -0400
In-Reply-To: <alpine.LSU.2.20.1509081051090.24872@nerf40.vanv.qr>
Content-Language: en-GB
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

You meant xtables.c as I couldnt find xtables-main.c or am I looking at wrong repo/branch

________________________________________
From: Jan Engelhardt [jengelh@inai.de]
Sent: 08 September 2015 11:55
To: Zaman, Imran
Cc: netfilter-devel@vger.kernel.org
Subject: RE: [PATCH v1 1/1] fix: resource leakage when loading library using dlopen

On Tuesday 2015-09-08 09:02, Zaman, Imran wrote:

>Well! I tend to disagree here..
>
>Any resource should be freed immediately if it is not in use..

Yet they are in use until xtables-main.c:78 or so.

>Do you know when is 'ptr' get free'd and at which point in code?

xtables-main.c:93:      exit(!ret)
---------------------------------------------------------------------
Intel Finland Oy
Registered Address: PL 281, 00181 Helsinki 
Business Identity Code: 0357606 - 4 
Domiciled in Helsinki 

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

