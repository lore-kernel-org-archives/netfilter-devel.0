From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: iptables (1.4.2 release) failed to run on embedded system with
 "can't initialize iptables table `filter'"
Date: Fri, 21 Nov 2008 17:07:41 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0811211659001.12307@fbirervta.pbzchgretzou.qr>
References: <op.uky4wc2dqigx4y@cyprus.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: David Wu <davidwu@arcturusnetworks.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:44853 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbYKUQHn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Nov 2008 11:07:43 -0500
In-Reply-To: <op.uky4wc2dqigx4y@cyprus.local>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2008-11-21 15:51, David Wu wrote:

> My question:
>   1 why tries to allocate 0 size memory, it is useful?

        array_elems = (h->num_chains / list_length) + 
                      (h->num_chains % list_length ? 1 : 0); 
        array_mem   = sizeof(h->chain_index) * array_elems; 


Logically,
array_mem == 0  =>  (sizeof(h->chain_index) == 0) ^ (array_elems == 0).
And given that sizeof() is unlikely to return 0 here, array_elems must 
be 0. And the only way array_elems can be 0 is that h->num_chains < 
list_length && h->num_chains == 0.  Buf if you have 0 chains to start 
with, it sounds like it really could not get the filter to table to 
work. gdb will help.

>   2 is there any problem to the iptables program in my change?
>     I may have to rebuild the toolchain so malloc will return a live
> pointer for 0 size allocation.
>   3 I have got the error
>     ip_tables: ERROR target: invalid size 30 != 32
>     from 1.3.7 and 1.4.2 (didn't try other versions) and sent to this list
> a question before but haven't received any answer

It needs the same ABI, as was answered before:

http://marc.info/?l=netfilter-devel&m=122309437709848&w=2
