From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Help: how to track two way connection?
Date: Fri, 9 Apr 2004 11:25:46 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0404091124520.21525-100000@filer.marasystems.com>
References: <009f01c41e04$e825a460$7a03a8c0@edimax.com.tw>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Peter <peter@edimax.com.tw>
In-Reply-To: <009f01c41e04$e825a460$7a03a8c0@edimax.com.tw>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 9 Apr 2004, Peter wrote:

> There are two Ethernet interfaces in the NAT router and surely this
> router splits the network into two network segments, say segment A (WAN
> side) and segment B (LAN side). There is a well known port (say P1) need
> to be tracked at segment A and another well known port (say P2) need to
> be tracked at segment B after port A has been tracked. I can register
> the tracking port P1 at segment A in init() functions of both
> ip_conntrack and ip_nat modules and the router works as expected. But I
> can NOT register P2 at segment B, nor P1, P2 simultaneously.

Sounds like the job of a NAT helper module. See the netfilter hacking 
howto and the existing NAT helpers for detail.

Regards
Henrik
