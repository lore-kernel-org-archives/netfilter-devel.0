From: "G.W. Haywood" <ged@jubileegroup.co.uk>
Subject: Re: [ANNOUNCE] ipset-2.3.3
Date: Mon, 21 Jul 2008 18:35:25 +0100 (BST)
Message-ID: <Pine.LNX.4.58.0807211828380.17282@mail3.jubileegroup.co.uk>
References: <Pine.LNX.4.64.0807192259320.24664@blackhole.kfki.hu>
 <Pine.LNX.4.58.0807201524360.8513@mail3.jubileegroup.co.uk>
 <Pine.LNX.4.64.0807201824590.25442@blackhole.kfki.hu>
 <Pine.LNX.4.58.0807210815530.30128@mail3.jubileegroup.co.uk>
 <Pine.LNX.4.64.0807211633550.26314@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from jubileegroup.co.uk ([217.147.177.250]:40807 "EHLO
	mail3.jubileegroup.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbYGURf1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jul 2008 13:35:27 -0400
In-Reply-To: <Pine.LNX.4.64.0807211633550.26314@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jozsef,

On Mon, 21 Jul 2008, Jozsef Kadlecsik wrote:

> On Mon, 21 Jul 2008, G.W. Haywood wrote:
>
> > Is there any chance of being able to compile a non-modular 2.4 kernel
> > with the released ipsets, or am I on my own with that?
>
> With ipset-2.3.3a you should be able to compile a non-modular kernel.
> I.e. you can configure the features of the patched kernel as you want and
> it should be compiled cleanly.

Bless my soul, so it does!  It might be worth making an adjustment in the
README, it seems to imply that only 2.6 kernels can be compiled non-modular.
I had tried anyway, with 2.4.36.6 and 2.3.3, but of course it failed - and I
didn't try again with 2.3.3a. :(

Thanks very much. :)

--

73,
Ged.
