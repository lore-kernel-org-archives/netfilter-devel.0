From: Rick Jones <rick.jones2@hp.com>
Subject: Re: [RFC] don't copy the whole table to all the other CPUs
Date: Wed, 17 Nov 2010 10:03:56 -0800
Message-ID: <4CE4190C.800@hp.com>
References: <AANLkTinBSZPAMKb7J0aBb4_xBv_QPnXTZAE9c+8=cnHz@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:9950 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935136Ab0KQSD6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Nov 2010 13:03:58 -0500
In-Reply-To: <AANLkTinBSZPAMKb7J0aBb4_xBv_QPnXTZAE9c+8=cnHz@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Changli Gao wrote:
> When reviewing the iptables code, I find there is one exact copy of
> table on every possible CPU for parallel processing. However, only
> counters are private, and the others are the same. It is a wast of
> memory. I know the current implementation maybe good for NUMA, but I
> don't think NUMA is common, and I doubt its benefit. I'll try to
> convert the code use one shared table, but private counters.
> 
> Any comment?

Others have already commented on how the code is changing and whether or not 
what is done is necessary for good performance in the face of NUMA, but I wanted 
to point-out that NUMA is quite common.  Just in the x86 space, virtually 
anything with two or more sockets sold starting with Nehalem-EP (?) is a NUMA 
system, and one can go farther back than that when one goes to Barcelona. 
Per-processor memory controllers and more than one processor implies NUMA.

rick jones

