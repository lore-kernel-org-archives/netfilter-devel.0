From: Brian G <unixman83@gmail.com>
Subject: How to get access to NAT info from userland
Date: Sat, 02 Apr 2011 03:23:42 -0500
Message-ID: <4D96DD0E.4020404@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54546 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365Ab1DBIXw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Apr 2011 04:23:52 -0400
Received: by iwn34 with SMTP id 34so4156666iwn.19
        for <netfilter-devel@vger.kernel.org>; Sat, 02 Apr 2011 01:23:51 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I have a socket, IPv4. It is being transparent proxied to userland via a 
REDIRECT NAT target.

Is there any getsocketopt() or any syscall so I can get the REAL 
destination address off this socket from userland?

If not, I still need to know the TRUE DESTINATION when using a 
transparent proxy so I know where to send to request. What needs to 
added to the kernel (e.g. like an iptables TARGET) to get this info.

  - Brian G
