From: "Ondrej Slanina" <oslanina@kerio.com>
Subject: Fw: Netfilter for Windows
Date: Thu, 15 Apr 2010 11:02:56 +0200
Message-ID: <E1065721E84E443C803CD31BFE864396@kerio.local>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.kerio.com ([195.113.184.2]:59181 "EHLO mx1.kerio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757393Ab0DOJDJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Apr 2010 05:03:09 -0400
Received: from localhost ([127.0.0.1])
	by mx1.kerio.com
	(using TLSv1/SSLv3 with cipher AES256-SHA (256 bits))
	for netfilter-devel@vger.kernel.org;
	Thu, 15 Apr 2010 11:03:07 +0200
Received: from localhost ([127.0.0.1])
	by lumpy.kerio.cz
	(using TLSv1/SSLv3 with cipher RC4-MD5 (128 bits))
	for netfilter-devel@vger.kernel.org;
	Thu, 15 Apr 2010 11:03:00 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,
I just created a basic 'port' of Linux netfilter core modules on MS Windows. 
Now, it's implemented as a single kernel module (IM driver) and userspace 
library which has the same API as libnetfilter_queue. Network filtering is 
now performed only on pre_input and post_output sides. Kernel module now 
includes packet queueing, processing, not as on Linux, where this tasks is 
processed by separate modules. It will be distributed under GPL. I have some 
questions:

1, Can I use 'netfilter' and 'libnetfilter_queue' names for this? For 
example kernel module named netfilter.sys, userspace library named 
libnetfilter_queue.lib, project name netfilter, netfilter for windows or 
something like it?
2, Should I put some notice about origin into source code files ? Something 
like: "Based on Linux netfilter/libnetfilter_queue"  ?

My implementation is now very primitive, but I want to extend it in the 
future.
Best Regards,


Ondrej Slanina
developer
..................................................................
Kerio Technologies s.r.o.
Anglicke nabrezi 1, 301 49 Plzen
Czech Republic
http://www.kerio.com
...................................................................
Connect. Communicate. Collaborate. Securely. 


__________ Informace od ESET NOD32 Antivirus, verze databaze 5029 (20100414) __________

Tuto zpravu proveril ESET NOD32 Antivirus.

http://www.eset.cz





