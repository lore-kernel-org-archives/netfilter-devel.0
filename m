From: Normand <normand@linux.vnet.ibm.com>
Subject: xtables-addons build failed with linux 4.5 header
Date: Wed, 20 Apr 2016 12:49:26 +0200
Message-ID: <57175EB6.8040308@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:41276 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406AbcDTKtd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Apr 2016 06:49:33 -0400
Received: from localhost
	by e06smtp17.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <netfilter-devel@vger.kernel.org> from <normand@linux.vnet.ibm.com>;
	Wed, 20 Apr 2016 11:49:31 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
	by d06dlp03.portsmouth.uk.ibm.com (Postfix) with ESMTP id 642CD1B0806E
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Apr 2016 11:50:12 +0100 (BST)
Received: from d06av11.portsmouth.uk.ibm.com (d06av11.portsmouth.uk.ibm.com [9.149.37.252])
	by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u3KAnRMS7602588
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Apr 2016 10:49:27 GMT
Received: from d06av11.portsmouth.uk.ibm.com (localhost [127.0.0.1])
	by d06av11.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u3KAnRZS012264
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Apr 2016 04:49:27 -0600
Received: from [9.79.73.48] (sig-9-79-73-48.de.ibm.com [9.79.73.48])
	by d06av11.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVin) with ESMTP id u3KAnQt7012186
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Apr 2016 04:49:27 -0600
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi there,
I do not know if problem is already reported, but build of xtables-addons is failing as reported by (1)

(1) https://build.opensuse.org/package/show/security:netfilter/xtables-addons
===
[   81s] gcc -Wp,-MMD,./.libxt_pknock.oo.d,-MT,libxt_pknock.oo -D_LARGEFILE_SOURCE=1 -D_LARGE_FILES -D_FILE_OFFSET_BITS=64 	-D_REENTRANT -I../../include -I/home/abuild/rpmbuild/BUILD/xtables-addons-default-2.10/extensions -Wall -Waggregate-return -Wmissing-declarations 	-Wmissing-prototypes -Wredundant-decls -Wshadow -Wstrict-prototypes 	-Winline -pipe -I/usr/include/iptables -DPIC -fPIC 
-fmessage-length=0 -grecord-gcc-switches -O2 -Wall -D_FORTIFY_SOURCE=2 -fstack-protector -funwind-tables -fasynchronous-unwind-tables -g -o libxt_pknock.oo -c libxt_pknock.c;
[   81s] In file included from /usr/include/iptables/xtables.h:16:0,
[   81s]                  from libxt_pknock.c:15:
[   81s] /usr/include/linux/if.h:71:2: error: redeclaration of enumerator 'IFF_UP'
[   81s]   IFF_UP    = 1<<0,  /* sysfs */
[   81s]   ^
===

-- 
Michel Normand

