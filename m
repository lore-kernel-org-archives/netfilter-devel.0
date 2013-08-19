From: Phil Oester <kernel@linuxace.com>
Subject: Re: NAT stops forwarding ACKs after PMTU discovery
Date: Mon, 19 Aug 2013 07:35:09 -0700
Message-ID: <20130819143509.GA31320@linuxace.com>
References: <521061B4.1030508@fatooh.org>
 <1376839467.21329.36.camel@edumazet-glaptop>
 <alpine.DEB.2.00.1308182314050.25515@blackhole.kfki.hu>
 <1376870425.4226.25.camel@edumazet-glaptop>
 <1376870592.4226.27.camel@edumazet-glaptop>
 <5211DAA6.1070302@fatooh.org>
 <20130819123314.GC3583@cpaasch-mac>
 <1376918657.4226.59.camel@edumazet-glaptop>
 <20130819134919.GF3583@cpaasch-mac>
 <1376920685.4226.61.camel@edumazet-glaptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Paasch <christoph.paasch@uclouvain.be>,
	Corey Hickey <bugfood-ml@fatooh.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Linux Netdev List <netdev@vger.kernel.org>,
	netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:43935 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab3HSOe7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Aug 2013 10:34:59 -0400
Received: by mail-pd0-f180.google.com with SMTP id y10so5282309pdj.39
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Aug 2013 07:34:59 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1376920685.4226.61.camel@edumazet-glaptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 19, 2013 at 06:58:05AM -0700, Eric Dumazet wrote:
> Yeah, but here, this is conntrack who is blocking the thing.
> 
> TCP receiver has no chance to 'fix' it.
> 
> See conntrack is one of those buggy middle box as well.
> 
> So if you want to properly handle this mess, you'll also have to fix
> conntrack.

Better to fix the box which is randomizing the acks and ignoring
the SACKs.  Usually these are older Cisco PIX/ASA devices which just
need a code upgrade.  

Phil
