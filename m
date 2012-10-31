From: Josh Hunt <johunt@akamai.com>
Subject: ipset restore behavior with newer glibc
Date: Wed, 31 Oct 2012 11:27:12 -0500
Message-ID: <50915160.1090908@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from prod-mail-xrelay06.akamai.com ([96.6.114.98]:44446 "EHLO
	prod-mail-xrelay06.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758048Ab2JaQfC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Oct 2012 12:35:02 -0400
Received: from prod-mail-xrelay06.akamai.com (localhost.localdomain [127.0.0.1])
	by postfix.imss70 (Postfix) with ESMTP id EDBA01655FB
	for <netfilter-devel@vger.kernel.org>; Wed, 31 Oct 2012 16:27:13 +0000 (GMT)
Received: from prod-mail-relay03.akamai.com (prod-mail-relay03.akamai.com [172.27.8.26])
	by prod-mail-xrelay06.akamai.com (Postfix) with ESMTP id E35AF16560E
	for <netfilter-devel@vger.kernel.org>; Wed, 31 Oct 2012 16:27:13 +0000 (GMT)
Received: from [0.0.0.0] (caldecot.sanmateo.corp.akamai.com [172.22.186.166])
	by prod-mail-relay03.akamai.com (Postfix) with ESMTP id 8B5AE2FD51
	for <netfilter-devel@vger.kernel.org>; Wed, 31 Oct 2012 16:27:13 +0000 (GMT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When doing an ipset restore with newer versions of glibc I'm seeing some 
extra syscall overhead that I was not seeing with glibc 2.4. I was 
wondering if anyone has seen such behavior and could help me understand 
what is going on?

Here is a snippet of strace during the restore with glibc 2.4: 
http://pastebin.com/qxkPF7FB and one with glibc 2.7: 
http://pastebin.com/wga9SN0E
I've also seen similar behavior with glibc 2.11.

You'll notice that with the newer version a second netlink socket is 
created and it appears some data is sent and info received back from the 
kernel and that socket is closed. This creating and closing of sockets 
continues until the restore operation completes. This causes the restore 
to grow from taking ~1 second to ~5 seconds. This is not a huge deal, 
but I'm more curious as to why this behavior has changed.

These runs were done with ipset v6.11 and kernel 3.2. It appears to me 
this is a glibc change b/c if I swap out only that component I see this 
change in behavior.

Thanks
Josh
