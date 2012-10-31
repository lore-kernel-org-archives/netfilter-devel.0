From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: ipset restore behavior with newer glibc
Date: Wed, 31 Oct 2012 17:41:08 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1210311737030.20899@nerf07.vanv.qr>
References: <50915160.1090908@akamai.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Josh Hunt <johunt@akamai.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:60808 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758048Ab2JaQlJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Oct 2012 12:41:09 -0400
In-Reply-To: <50915160.1090908@akamai.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2012-10-31 17:27, Josh Hunt wrote:

> When doing an ipset restore with newer versions of glibc I'm seeing some extra
> syscall overhead that I was not seeing with glibc 2.4. I was wondering if
> anyone has seen such behavior and could help me understand what is going on?
>
> Here is a snippet of strace during the restore with glibc 2.4:
> http://pastebin.com/qxkPF7FB and one with glibc 2.7:
> http://pastebin.com/wga9SN0E
> I've also seen similar behavior with glibc 2.11.
>
> You'll notice that with the newer version a second netlink socket is created
> and it appears some data is sent and info received back from the kernel

I have observed such as well in other programs as well. Without
looking into this too deeply, I suspect that a program, or a library
on its behalf, is using the interface name<->index resolution
functions if_nametoindex(3) et al, for which netlink is used in
sufficiently new glibc where socket ioctls were (probably) used
previously. Could this be it?
