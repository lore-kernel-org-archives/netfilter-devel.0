From: arif <arif@bansberrysg.com>
Subject: Calling ip_rcv_finish() from a module
Date: Sun, 02 Dec 2012 16:38:45 +0600
Message-ID: <k9fb3k$fd4$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33790 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753321Ab2LBKo7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 2 Dec 2012 05:44:59 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gnnd-netfilter-devel@m.gmane.org>)
	id 1Tf72m-0002kj-Rg
	for netfilter-devel@vger.kernel.org; Sun, 02 Dec 2012 11:45:04 +0100
Received: from 103.23.169.14 ([103.23.169.14])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Sun, 02 Dec 2012 11:45:04 +0100
Received: from arif by 103.23.169.14 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Sun, 02 Dec 2012 11:45:04 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

arif@khost:~/src/linux$ global -x ip_rcv_finish
ip_rcv_finish     319 net/ipv4/ip_input.c static int 
ip_rcv_finish(struct sk_buff *skb)

Now if i want to use this function i need to initialize a pointer to 
this function.

To be able to do that i need the address of the function.

I've seen that from user space i can read /proc/kallsyms to get an 
address of a symbol. Is their any similar mechanism exist where i can 
read the symbol table to extract a symbol's address from kernel space?

cheers
arif

