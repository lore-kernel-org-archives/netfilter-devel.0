From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Routing decision?
Date: Mon, 15 Sep 2003 16:34:10 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0309151632240.16959-100000@filer.marasystems.com>
References: <3F65BBC2.8030208@able.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Wim Ceulemans <wim.ceulemans@able.be>
In-Reply-To: <3F65BBC2.8030208@able.be>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 15 Sep 2003, Wim Ceulemans wrote:

> In paragraph 6.2 of the iptables-tutorial the following is said:
> "The OUTPUT chain is used for altering locally generated packets (i.e., 
> on the firewall) before they get to the routing decision.

Yes.

> But in paragraph 3.1, the "Traversing of tables and chains" diagram, we 
> see the "Routing decision" is listed after the "Local process" and
> BEFORE! the packet goes to the output chain.
> 
> So which one is right? Does the routing decision take place after or 
> before the packet travels through the output chain?

Both, depending on the situation.

if the local endpoint of the socket sending the packet is bound then
routing occurs after OUTPUT.

If the local endpoint of the socket is NOT bound then routing occurs 
before OUTPUT to assign the source address.

Regards
Henrik
