From: "Darrell A. Escola" <darrell-netfilter@descola.net>
Subject: Re: Is it possible
Date: Fri, 5 Jul 2002 16:32:03 -0700
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020705233203.GA20658@descola.net>
References: <001701c2247b$47f8a4d0$3a6fa8c0@cnu00ip>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Peter Gosens <ptha@mac.com>
Content-Disposition: inline
In-Reply-To: <001701c2247b$47f8a4d0$3a6fa8c0@cnu00ip>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

iptables will only see the ip address - if it is http(s) traffic, apache(-ssl)
can deal with virtual host-names using the same ip address.

Darrell

On Sat, Jul 06, 2002 at 01:25:41AM +0200, Peter Gosens wrote:
> Is it possible to make iptables forward packets based on hostname. 
> 
> I've one.cc.com and two.cc.com three.cc.com pointing to 213.93.43.28 .
> And I want that traffic with one.cc.com is going to 213.93.43.84.
> But the two.cc.com and three.cc.com traffic need to be forwarded to an
> internal network ip (suchs as 192.168.100.2).
> 
> Is this possible with iptables. Or do I have to add an loadbalancer or
> use an proxy. I also thought about using ipv6, but it has an lack of
> supporting program's.
> 
> If you have any other idea's about this matter. Please tell me.
> 
> Peter Gosens
