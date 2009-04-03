From: Kunsheng Chen <kunsheng.chen@yahoo.com>
Subject: Looking for a example of reading incoming IP
Date: Thu, 2 Apr 2009 20:01:31 -0700 (PDT)
Message-ID: <233215.95431.qm@web43411.mail.sp1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from n78.bullet.mail.sp1.yahoo.com ([98.136.44.42]:37295 "HELO
	n78.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751043AbZDCDBe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Apr 2009 23:01:34 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hello everyone,

I am looking for a example of netfilter hook to read the ip address of incoming packets in both PreRoute and PostRoute. 

I searched online for some example but none of them work for the kernel 2.6.29 I am using. I am not sure whether there something has been changed there.

I could set up the hook now but always fail to read the correct ip address. Basically I want to store that ip address into a char array than just print it out. 

Appreciate any help especially some concrete example.


Thanks in advance,


-Kunsheng Chen


      

