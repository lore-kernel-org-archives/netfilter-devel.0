From: Torsten Luettgert <ml-netfilter@enda.eu>
Subject: TEE broken in 3.6
Date: Tue, 16 Oct 2012 21:13:19 +0200
Message-ID: <20121016211319.3f07a7e3@goldlack.enda.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail1.cbxnet.de ([212.87.33.16]:54295 "EHLO mail1.cbxnet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755961Ab2JPTdl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Oct 2012 15:33:41 -0400
Received: from www.enda.eu ([212.87.38.145] helo=infra.enda.eu)
	by mail1.cbxnet.de with esmtps (TLSv1:DHE-RSA-AES256-SHA:256)
	(Exim 4.76)
	(envelope-from <ml-netfilter@enda.eu>)
	id 1TOCZt-0006OY-DY
	for netfilter-devel@vger.kernel.org; Tue, 16 Oct 2012 21:13:21 +0200
Received: from p4fc5c1da.dip0.t-ipconnect.de ([79.197.193.218] helo=goldlack.enda.eu)
	by infra.enda.eu with esmtpsa (TLSv1:DHE-RSA-AES128-SHA:128)
	(Exim 4.80)
	(envelope-from <ml-netfilter@enda.eu>)
	id 1TOCZs-0004x6-4y
	for netfilter-devel@vger.kernel.org; Tue, 16 Oct 2012 21:13:20 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

today, I found that the TEE target doesn't work any longer in 3.6 and
following kernels. The problem is that it tries to ARP-lookup the
original destination address of the forwarded packet, not the address
of the gateway.

I git bisected and found that this commit broke it:

commit f8126f1d5136be1ca1a3536d43ad7a710b5620f8
Author: David S. Miller <davem@davemloft.net>
Date:   Fri Jul 13 05:03:45 2012 -0700

    ipv4: Adjust semantics of rt->rt_gateway.
    
    In order to allow prefixed routes, we have to adjust how rt_gateway
    is set and interpreted.
    
    The new interpretation is:
    
    1) rt_gateway == 0, destination is on-link, nexthop is iph->daddr
    
    2) rt_gateway != 0, destination requires a nexthop gateway
    
    Abstract the fetching of the proper nexthop value using a new
    inline helper, rt_nexthop(), as suggested by Joe Perches.
    
    Signed-off-by: David S. Miller <davem@davemloft.net>
    Tested-by: Vijay Subramanian <subramanian.vijay@gmail.com>

which seems plausible. I'm not versed enough in netfilter/routing code
to fix it myself. Could any of you wizards help?

Thanks,
Torsten
