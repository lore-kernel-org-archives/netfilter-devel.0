From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: H.239 support in the H.323 helper?
Date: Sat, 26 Sep 2009 12:17:47 +0300
Message-ID: <20090926091747.GV31123@reaktio.net>
References: <alpine.DEB.2.00.0909221132150.16779@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jing Min Zhao <zhaojingmin@users.sourceforge.net>,
	netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from reaktio.net ([194.89.68.22]:46188 "EHLO ydin.reaktio.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890AbZIZJl6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 26 Sep 2009 05:41:58 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0909221132150.16779@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Sep 22, 2009 at 11:44:45AM +0200, Jozsef Kadlecsik wrote:
> Hi,
> 
> With the H.323 conntrack helper enabled on a machine running Gnugk, it 
> cannot establish multiple channels for conferencing and presentation with 
> a Polycom MGC MCU. The device wants to use H.239 and the helper cannot 
> decode/interpret the protocol:
> 
> Sep 21 13:41:48 caladan kernel: nf_ct_h323: incomplete TPKT (fragmented?)
> 
> Could you consider to add H.239 support to the H.323 helper?
> 

Hello.

I don't know if anyone is working on adding H.239, but you could always
start working on it yourself. You seem to have the needed equipment to
test it :)

-- Pasi

