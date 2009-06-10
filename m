From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter: BUG: sleeping function called from invalid context
Date: Wed, 10 Jun 2009 16:27:14 +0200
Message-ID: <4A2FC2C2.7090803@trash.net>
References: <20090610161935.0f8b1949@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050403020802020104070004"
Cc: Eric Leblond <eric@inl.fr>,
	Maran Pakkirisamy <maranpsamy@in.ibm.com>,
	Andreas Krebbel <krebbel1@de.ibm.com>,
	linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59745 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757214AbZFJO1P (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jun 2009 10:27:15 -0400
In-Reply-To: <20090610161935.0f8b1949@osiris.boeblingen.de.ibm.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050403020802020104070004
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Heiko Carstens wrote:
> Maran reported the bug below (vanilla 2.6.30-rc8):
> 
> BUG: sleeping function called from invalid context at /mnt/s390test/linux-2.6-tip/arch/s390/include/asm/uaccess.h:234 
> in_atomic(): 1, irqs_disabled(): 0, pid: 3245, name: sysctl 
> CPU: 1 Not tainted 2.6.30-rc8-tipjun10-02053-g39ae214 #1 
> Process sysctl (pid: 3245, task: 000000007f675da0, ksp: 000000007eb17cf0) 
> 0000000000000000 000000007eb17be8 0000000000000002 0000000000000000  
>        000000007eb17c88 000000007eb17c00 000000007eb17c00 0000000000048156  
>        00000000003e2de8 000000007f676118 000000007eb17f10 0000000000000000  
>        0000000000000000 000000007eb17be8 000000000000000d 000000007eb17c58  
>        00000000003e2050 000000000001635c 000000007eb17be8 000000007eb17c30  
> Call Trace: 
> (Ý<00000000000162e6>¨ show_trace+0x13a/0x148) 
>  Ý<00000000000349ea>¨ __might_sleep+0x13a/0x164 
>  Ý<0000000000050300>¨ proc_dostring+0x134/0x22c 
>  Ý<0000000000312b70>¨ nf_log_proc_dostring+0xfc/0x188 
>  Ý<0000000000136f5e>¨ proc_sys_call_handler+0xf6/0x118 
>  Ý<0000000000136fda>¨ proc_sys_read+0x26/0x34 
>  Ý<00000000000d6e9c>¨ vfs_read+0xac/0x158 
>  Ý<00000000000d703e>¨ SyS_read+0x56/0x88 
>  Ý<0000000000027f42>¨ sysc_noemu+0x10/0x16 
> 
> The code that introduces the bug came in with 17625274 "netfilter:
> sysctl support of logger choice".
> 
> There we have this chunk:
> 
> +               rcu_read_lock();
> +               logger = rcu_dereference(nf_loggers[tindex]);
> +               if (!logger)
> +                       table->data = "NONE";
> +               else
> +                       table->data = logger->name;
> +               r = proc_dostring(table, write, filp, buffer, lenp, ppos);
> +               rcu_read_unlock();
> 
> proc_dostring() will call copy_from_user() while preemption is disabled
> because of rcu_read_lock().
> Looks like somebody needs to fix this ;)

Thanks for the report. This patch should fix it.


--------------050403020802020104070004
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="x"

ZGlmZiAtLWdpdCBhL25ldC9uZXRmaWx0ZXIvbmZfbG9nLmMgYi9uZXQvbmV0ZmlsdGVyL25m
X2xvZy5jCmluZGV4IGJlYjM3MzEuLjJmZWZlMTQgMTAwNjQ0Ci0tLSBhL25ldC9uZXRmaWx0
ZXIvbmZfbG9nLmMKKysrIGIvbmV0L25ldGZpbHRlci9uZl9sb2cuYwpAQCAtMjQ4LDE0ICsy
NDgsMTQgQEAgc3RhdGljIGludCBuZl9sb2dfcHJvY19kb3N0cmluZyhjdGxfdGFibGUgKnRh
YmxlLCBpbnQgd3JpdGUsIHN0cnVjdCBmaWxlICpmaWxwLAogCQlyY3VfYXNzaWduX3BvaW50
ZXIobmZfbG9nZ2Vyc1t0aW5kZXhdLCBsb2dnZXIpOwogCQltdXRleF91bmxvY2soJm5mX2xv
Z19tdXRleCk7CiAJfSBlbHNlIHsKLQkJcmN1X3JlYWRfbG9jaygpOwotCQlsb2dnZXIgPSBy
Y3VfZGVyZWZlcmVuY2UobmZfbG9nZ2Vyc1t0aW5kZXhdKTsKKwkJbXV0ZXhfbG9jaygmbmZf
bG9nX211dGV4KTsKKwkJbG9nZ2VyID0gbmZfbG9nZ2Vyc1t0aW5kZXhdOwogCQlpZiAoIWxv
Z2dlcikKIAkJCXRhYmxlLT5kYXRhID0gIk5PTkUiOwogCQllbHNlCiAJCQl0YWJsZS0+ZGF0
YSA9IGxvZ2dlci0+bmFtZTsKIAkJciA9IHByb2NfZG9zdHJpbmcodGFibGUsIHdyaXRlLCBm
aWxwLCBidWZmZXIsIGxlbnAsIHBwb3MpOwotCQlyY3VfcmVhZF91bmxvY2soKTsKKwkJbXV0
ZXhfdW5sb2NrKCZuZl9sb2dfbXV0ZXgpOwogCX0KIAogCXJldHVybiByOwo=
--------------050403020802020104070004--
