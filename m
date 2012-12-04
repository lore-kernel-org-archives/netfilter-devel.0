From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: Calling ip_rcv_finish() from a module
Date: Tue, 4 Dec 2012 19:18:53 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1212041918230.18665@nerf07.vanv.qr>
References: <k9fb3k$fd4$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: arif <arif@bansberrysg.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:51779 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751875Ab2LDSSy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Dec 2012 13:18:54 -0500
In-Reply-To: <k9fb3k$fd4$1@ger.gmane.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sunday 2012-12-02 11:38, arif wrote:

> arif@khost:~/src/linux$ global -x ip_rcv_finish
> ip_rcv_finish     319 net/ipv4/ip_input.c static int ip_rcv_finish(struct
> sk_buff *skb)
>
> Now if i want to use this function i need to initialize a pointer to this
> function.
> To be able to do that i need the address of the function.
>
> I've seen that from user space i can read /proc/kallsyms to get an address of a
> symbol. Is their any similar mechanism exist where i can read the symbol table
> to extract a symbol's address from kernel space?

No. The function could be inlined and as such not even exist.
