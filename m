From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: policy routing on locally generated packets
Date: Tue, 26 Aug 2003 21:40:10 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0308262137540.16076-100000@filer.marasystems.com>
References: <20030826110913.GI423@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "lartc@manchotnetworks.net" <lartc@manchotnetworks.net>,
   netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
In-Reply-To: <20030826110913.GI423@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 26 Aug 2003, Patrick Schaaf wrote:

> To me, it could/would be the most logical extension to make PREROUTING
> also see outbound locally generated packets, before the routing step.

Problem is that the packet does not really exists yet.. the routing which 
assigns source address is done on the socket, not on a packet. This 
special routing only occurs once per unbound socket.

Exception: This routing occurs on each UDP packet with unspecified source 
address, but again the routing is done separately from the actual packet I 
think..

Regards
Henrik
