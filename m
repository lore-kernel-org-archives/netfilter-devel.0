From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Routing decision?
Date: Thu, 18 Sep 2003 15:10:27 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0309181507020.21129-100000@filer.marasystems.com>
References: <3F699CFF.1020702@able.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org, <dev@able.be>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Wim Ceulemans <wim.ceulemans@able.be>
In-Reply-To: <3F699CFF.1020702@able.be>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 18 Sep 2003, Wim Ceulemans wrote:

> Ok, but the problem is that setting a mark on the packet isn't 
> considered as a change to the packet, since marks only live in
> the kernel and have no effect on the packet.

Changing marks are considered a change in the packet in this context.

If mangle OUTPUT changes any of Source IP, Destination IP, ToS or nfmark
then the packet is automatically rerouted by iptables.

Regards
Henrik
