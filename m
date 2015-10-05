From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH libmnl 1/2] socket: introduce mnl_socket_open2()
Date: Mon, 5 Oct 2015 20:50:14 +0200 (CEST)
Message-ID: <alpine.LSU.2.20.1510052047000.11268@nerf40.vanv.qr>
References: <cover.1443815157.git.g.nault@alphalink.fr> <8ecf77e50d2acd0b20bdd18038b8e25fd6c86ec0.1443815157.git.g.nault@alphalink.fr> <alpine.DEB.2.10.1510051925090.13013@blackhole.kfki.hu> <20151005181429.GB2882@alphalink.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@vger.kernel.org
To: Guillaume Nault <g.nault@alphalink.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:40224 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131AbbJESuP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Oct 2015 14:50:15 -0400
In-Reply-To: <20151005181429.GB2882@alphalink.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2015-10-05 20:14, Guillaume Nault wrote:
>> 
>> I think this breaks library ABI: you should introduce a new revision 
>> instead.
>> 
>AFAIK, this revision hasn't been part of any official release yet.
>That's why I've exported mnl_socket_open2() there. I don't mind
>incrementing the ABI version, but should we really do that for every
>commit exporting a new function between two releases?

Not for every commit, indeed no. That would lead to a needlessy
larger (and deeper) symvers DAG, and therefore more to process for
dynamic and runtime linkers. Not much, but it would pile up
for x->\infty. This is also why the entire DAG should be flattened
again when setting -version-info C:R:A back to a new *:0:0.
