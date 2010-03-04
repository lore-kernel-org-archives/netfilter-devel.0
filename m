From: Patrick McHardy <kaber@trash.net>
Subject: Re: git.netfilter.org upload-pack seems busy
Date: Thu, 04 Mar 2010 11:27:13 +0100
Message-ID: <4B8F8B01.8060108@trash.net>
References: <alpine.LSU.2.01.1003031855490.26350@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60789 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab0CDK1O (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Mar 2010 05:27:14 -0500
In-Reply-To: <alpine.LSU.2.01.1003031855490.26350@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Hi,
> 
> 
> today I notice that cloning from git.netfilter.org has a slow start 
> (affects conntrack-tools and iptables, perhaps others). Not sure what it 
> does - directory indexing? Anyway, this is the interesting part of the 
> strace log:
> 
> 
> 
> 
> 1267638794.328685 execve("/usr/bin/git", ["git", "clone", "git://git.netfilter.org/conntrac"...], [/* 76 vars */]) = 0
> ...
> 1267638794.392196 socket(PF_INET6, SOCK_STREAM, IPPROTO_TCP) = 3
> 1267638794.392227 connect(3, {sa_family=AF_INET6, sin6_port=htons(9418), inet_pton(AF_INET6, "2001:780:45:1d:20d:93ff:fe9b:e443", &sin6_addr), sin6_flowinfo=0, sin6_scope_id=0}, 28) = 0
> 1267638794.666742 dup(3)                = 4
> 1267638794.666782 write(4, "003cgit-upload-pack /conntrack-t"..., 60) = 60
> 1267638794.666846 read(3, "007c", 4)    = 4
> 1267638874.678481 read(3, "58b363d32bf9b8b504c5664ae4d8b3bb"..., 120) = 120
> 1267638874.678549 read(3, "003f", 4)    = 4
> ...
> 1267638876.552753 exit_group(0)         = ?
> 
> 
> Note the high delay between the git-upload-pack request and the
> resulting answer.

Its pretty quick here. Perhaps try IPv4.
