From: Balazs Scheidler <bazsi@balabit.hu>
Subject: Re: NAT for IPv6
Date: Thu, 20 Nov 2003 18:48:47 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031120174847.GA2254@balabit.hu>
References: <20031120150641.GB1330@balabit.hu> <Pine.LNX.4.44.0311201643140.12803-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Harald Welte <laforge@netfilter.org>,
	Maciej Soltysiak <solt@dns.toxicfilms.tv>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0311201643140.12803-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, Nov 20, 2003 at 04:48:37PM +0100, Henrik Nordstrom wrote:
> On Thu, 20 Nov 2003, Balazs Scheidler wrote:
> 
> > s/transition-nat\./transition-nat, and local NAT necessary for TPROXY to work./
> 
> TPROXY is a prime example of breaking the end-to-end MUST requirement of
> IPv4 networking. Such abuses of the IPv4 protocol is actually among the 
> worst.
> 
> TPROXY like designs should at best be seen as a temporary solution to a
> problem, not a permanent solution.

And what do you think of the problem is? We are using TPROXY to create proxy
based firewalls, analyzing the network flows at the application level.
Proxies run in userspace moving a complex function out of the kernel (NAT
helpers)

TPROXY is not only meant to transparently proxy HTTP. Performing virus
checking in a POP3 flow encrypted using SSL is not possible using packet
filtering. (but it is using proxies)

> Lets at least try to solve the kinds of problems TPROXY and similar tools 
> tries to solve in the IPv4 protocol by using the capabilities and 
> opportunities provided by the IPv6 transition before starting to break the 
> design of the IP protocol again.

I still can't see what you think the "kinds of problems TPROXY and silimar
tools try to solve" is.

We (and our customers) have the following requirements:

- application layer verification (URL filtering, virus checking, tasks that
  are difficult/impossible to solve from kernel space)
- transparency
  - because there are protocols which do not have a proxy mode 
  - because they do not want to reconfigure their clients when a firewall
    is installed.

I can see cases when end-to-end IP connections are a must, but there are
other cases when proxying is the only viable solution, and I can't see why
we can't have a solution for both worlds.

-- 
Bazsi
PGP info: KeyID 9AF8D0A9 Fingerprint CD27 CFB0 802C 0944 9CFD 804E C82C 8EB1
