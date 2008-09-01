From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables error
Date: Mon, 01 Sep 2008 15:38:01 +0200
Message-ID: <48BBF039.6090501@trash.net>
References: <003501c90aa0$59d583a0$0d808ae0$@com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Nishit Shah <nishit@elitecore.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35376 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbYIANiL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Sep 2008 09:38:11 -0400
In-Reply-To: <003501c90aa0$59d583a0$0d808ae0$@com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Nishit Shah wrote:
> Hi,
> 	I am using 2.6.16.13 kernel in smp configuration. Machine is working
> as a gateway and frequent iptables commands are fired as users logged in and
> logged out.
> 
>       I got following error in between
> 
> [root@manage /root]# iptables -nvx -L INPUT
> ERROR: 7 not a valid target)
> Aborted (core dumped)
> 
> So, I tried to flush INPUT and got following
> 
> [root@manage /root]# iptables -F INPUT 
> iptables: Too many levels of symbolic links
> 
> following is a message I got in /var/log/messages
> 
> Aug 26 14:38:30 1219741710 kernel: iptables: loop hook 1 pos 0 00000022.

That kernel version has an iptables locking bug that might
lead to corruption. Latest 2.6.16 version has this fixed.
