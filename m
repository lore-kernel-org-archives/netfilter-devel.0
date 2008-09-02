From: "Nishit Shah" <nishit@elitecore.com>
Subject: RE: iptables error
Date: Tue, 2 Sep 2008 14:27:46 +0530
Message-ID: <001101c90cd9$f84e08f0$e8ea1ad0$@com>
References: <003501c90aa0$59d583a0$0d808ae0$@com> <48BBF039.6090501@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>
To: "'Patrick McHardy'" <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhost.elitecore.com ([203.88.135.194]:51113 "EHLO
	elitecore.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751267AbYIBI4i (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Sep 2008 04:56:38 -0400
In-Reply-To: <48BBF039.6090501@trash.net>
Content-Language: en-us
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thanks :)

Rgds,
Nishit Shah.

-----Original Message-----
From: Patrick McHardy [mailto:kaber@trash.net] 
Sent: Monday, September 01, 2008 7:08 PM
To: Nishit Shah
Cc: netfilter-devel@vger.kernel.org
Subject: Re: iptables error

Nishit Shah wrote:
> Hi,
> 	I am using 2.6.16.13 kernel in smp configuration. Machine is working
> as a gateway and frequent iptables commands are fired as users logged in
and
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

