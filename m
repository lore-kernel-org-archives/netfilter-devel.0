From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: NAT for IPv6
Date: Thu, 20 Nov 2003 16:48:37 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0311201643140.12803-100000@filer.marasystems.com>
References: <20031120150641.GB1330@balabit.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>,
   Maciej Soltysiak <solt@dns.toxicfilms.tv>,
   <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Balazs Scheidler <bazsi@balabit.hu>
In-Reply-To: <20031120150641.GB1330@balabit.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 20 Nov 2003, Balazs Scheidler wrote:

> s/transition-nat\./transition-nat, and local NAT necessary for TPROXY to work./

TPROXY is a prime example of breaking the end-to-end MUST requirement of
IPv4 networking. Such abuses of the IPv4 protocol is actually among the 
worst.

TPROXY like designs should at best be seen as a temporary solution to a
problem, not a permanent solution.

Note that I here speak about the IP level, not the implementation quality 
of the TPROXY support in netfilter/iptables. 

Lets at least try to solve the kinds of problems TPROXY and similar tools 
tries to solve in the IPv4 protocol by using the capabilities and 
opportunities provided by the IPv6 transition before starting to break the 
design of the IP protocol again.

Regards
Henrik
