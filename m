From: "Zaman, Imran" <imran.zaman@intel.com>
Subject: RE: [PATCH v1 1/1] fix: resource leakage when loading library using
 dlopen
Date: Tue, 8 Sep 2015 07:02:09 +0000
Message-ID: <0851720D2FAA48479DE89E28AEACE10E3B69DAA6@IRSMSX102.ger.corp.intel.com>
References: <1441622536-15123-1-git-send-email-imran.zaman@intel.com>,<alpine.LSU.2.20.1509071238500.579@nerf40.vanv.qr>
 <0851720D2FAA48479DE89E28AEACE10E3B69D763@IRSMSX102.ger.corp.intel.com>,<alpine.LSU.2.20.1509071506190.2437@nerf40.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:12537 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344AbbIHHCM convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Sep 2015 03:02:12 -0400
In-Reply-To: <alpine.LSU.2.20.1509071506190.2437@nerf40.vanv.qr>
Content-Language: en-GB
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Well! I tend to disagree here..

Any resource should be freed immediately if it is not in use.. function does not know how all the variables on heap be handled outside of the function, if those are not dealt internally unless returned in all cases to the function caller.. Besides, static analysis of the code is reporting resource leak at this code block and it should be fixed for the same reason and will be more clearer for callers of this function.
Freeing resource immediately once it is not in use is normal practice and must be followed in all cases as how I see it :) 

Do you know when is 'ptr' get free'd and at which point in code? sorry i m not very familiar with all iptables codebase, so if you can guide me I can sure come up with proper fix for it..

thanks

________________________________________
From: Jan Engelhardt [jengelh@inai.de]
Sent: 07 September 2015 16:08
To: Zaman, Imran
Cc: netfilter-devel@vger.kernel.org
Subject: RE: [PATCH v1 1/1] fix: resource leakage when loading library using dlopen

On Monday 2015-09-07 12:52, Zaman, Imran wrote:

>Aah. ookey.. so it needs to be moved two lines below..

At which point it's almost useless, because the program will end if the
requested extension cannot be loaded.

>What about the caller of the function? is it getting closed at any stage?

Implicitly at program exit.

It's not pretty valgrind-wise, but implicit resource freeing
seems a not-uncommon practice for some programs.
---------------------------------------------------------------------
Intel Finland Oy
Registered Address: PL 281, 00181 Helsinki 
Business Identity Code: 0357606 - 4 
Domiciled in Helsinki 

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

