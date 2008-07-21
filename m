From: "G.W. Haywood" <ged@jubileegroup.co.uk>
Subject: Re: [ANNOUNCE] ipset-2.3.3
Date: Mon, 21 Jul 2008 08:21:18 +0100 (BST)
Message-ID: <Pine.LNX.4.58.0807210815530.30128@mail3.jubileegroup.co.uk>
References: <Pine.LNX.4.64.0807192259320.24664@blackhole.kfki.hu>
 <Pine.LNX.4.58.0807201524360.8513@mail3.jubileegroup.co.uk>
 <Pine.LNX.4.64.0807201824590.25442@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from jubileegroup.co.uk ([217.147.177.250]:36133 "EHLO
	mail3.jubileegroup.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801AbYGUHVV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jul 2008 03:21:21 -0400
In-Reply-To: <Pine.LNX.4.64.0807201824590.25442@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jozsef,

Thanks for the very quick replies.

On Sun, 20 Jul 2008, Jozsef Kadlecsik wrote:
>
> On Sun, 20 Jul 2008, G.W. Haywood wrote:
>
> > ip_set.c: In function `ip_set_register_set_type':
> > ip_set.c:329: parse error before ',' token
> > ip_set.c: In function `ip_set_create':
> > ip_set.c:840: parse error before ',' token
>
> Do you compile your kernel without modules?

All my production kernels are compiled without modules, but in this
case I had enabled modules in the kernel .config file - otherwise I
could not have expected it to build.  (Obviously:)

> I have just released 2.3.3a which should fix it. Please give it a try.

That's fine now.

Is there any chance of being able to compile a non-modular 2.4 kernel
with the released ipsets, or am I on my own with that?

--

73,
Ged.
