From: Abraham van der Merwe <abz@frogfoot.net>
Subject: Re: netflow/sflow & Linux
Date: Mon, 22 Mar 2004 17:45:43 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040322154543.GA11903@oasis.frogfoot.net>
References: <20040322110710.GC8314@oasis.frogfoot.net> <Pine.LNX.4.44.0403221428520.19177-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0403221428520.19177-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Henrik                                        >@2004.03.22_15:31:00_+0200

> > Has anyone done any work to enable Linux to do netflow (capturing not
> > processing)?
> 
> See www.ntop.org

Yes, I know about that, but ntop is rather limited because it is just based
on libpcap.

Maybe I should rephrase the question:

Has anyone done any work to do netflow in Linux the "real" way, i.e.

 (a) keep a "flow" in kernel space AND record routing information (e.g. AS
     numbers would by extremely useful although we'd need some way for Zebra
     to pass this information to the kernel).

 (b) export that flow to userspace again.

My main gripe with ntop is that it can't record AS numbers. This is very
useful! It also means that were missing out on connection tracking which
would've been really useful (this is something Cisco, etc can't do yet).

-- 

Regards
 Abraham

TODAY the Pond!
TOMORROW the World!
                -- Frogs (1972)

___________________________________________________
 Abraham vd Merwe - Frogfoot Networks CC
 1st Floor, Albion Springs, 183 Main Road, Newlands
 Phone: +27 21 689 3873 Cell: +27 82 565 4451
 Http: http://www.frogfoot.net/ Email: abz@frogfoot.net
