From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Iptables acting as a load balancer
Date: Wed, 4 Aug 2004 21:40:14 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0408042137370.18805-100000@filer.marasystems.com>
References: <200408041619.SAA09183@mail.nexusat.it>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "'Netfilter Mailinglist'" <netfilter@lists.netfilter.org>,
   "'Netfilter Development Mailinglist'" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Giovanni Costagliola <giovanni.costagliola@nexusat.it>
In-Reply-To: <200408041619.SAA09183@mail.nexusat.it>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 4 Aug 2004, Giovanni Costagliola wrote:

> Q1: Does iptables allow a state-balancing? Or it simple span the packets on
> the range of IPs? (I further guess: Has it any reasonable sense?)

iptables does not have any reasonable sense for load balancing. It is not 
what it is designed for.

> Q2: What happens in the case a target IPs doesn't respond yet? In other
> words Is iptables able to recognize an host failure?

Not the job of iptables, but there is plenty of other software doing this.

> Q3: Provided my needs, and supposing I'll receive negative answers, does
> exists some free/gpled solution feasible to me

For the low-level load balancing look into Linux Virtual Server / IPVS. 
Standard part of the Linux kernel. For the host monitoring see LVS/IPVS 
related software (there is several good options).

> Q4: Provided iptables fit positively to Q1 and Q2, does anyone experimented
> the solution? Any feedback to the regard?

Have played with implementing NAT based load balancing ontop of 
netfilter NAT. It is technically doable but is missing some small pieces 
of accounting to make it work in a nice manner.

Regards
Henrik
