From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Routing decision?
Date: Mon, 15 Sep 2003 21:48:47 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0309152144120.20647-100000@filer.marasystems.com>
References: <3F65E7E7.70105@able.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org, <pieter@able.be>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Wim Ceulemans <wim.ceulemans@able.be>
In-Reply-To: <3F65E7E7.70105@able.be>
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

> Here's why: if you want to mark packets in the OUTPUT chain that are
> http traffic, based on the destination port. And then based on that mark
> send the packets to another routing table added with the ip command.

Then do so. iptables will make the needed re-routing of the packet when 
the nfmark is modified.

But you can't use this to select the source IP address as this has already
been done and must be done before the packet is constructed (and sent to
iptables), however you can use NAT to rewrite the source IP address if not
assigned suitably or alternaively (preferred) have the application use a
suitable source IP address to begin with.

Regards
Henrik
