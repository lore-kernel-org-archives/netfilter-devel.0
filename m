From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Does iptable save original destination address so that application
 could retrieve it?
Date: Tue, 6 Apr 2004 00:18:24 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0404060012470.30166-100000@filer.marasystems.com>
References: <BAY7-DAV39pFcgRqaxA00021e1b@hotmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Grace Li <zheyinli@hotmail.com>
In-Reply-To: <BAY7-DAV39pFcgRqaxA00021e1b@hotmail.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 5 Apr 2004, Grace Li wrote:

> Iptables could be instructed to intercept packets arrived on specified
> network interface, change the destination port to a specified local port
> so that the traffic is directed to appropriate application.

Yes.

> For example Squid asks iptables to intercept traffic for port 80 frox
> asks iptable to intercept traffic for port 21, ASSP asks iptable to
> intercept traffic for port 80.

Not exacly.. but yes all these accept having iptables send them redirected 
traffic. It is you who need to insert the iptables rule for doing so.

> My question is how could those application know the source and
> destination IP address of the packet in order to forward them on? Does
> iptable save original source/destination address somewhere so that
> application could retrieve it?

It does, and applications can ask for the original address details with a 
getsockopt call. See the LINUX_NETFILTER version of the clientNatLookup 
call in IPInterception.cc from the Squid-3 source tree for an example. 
Probably documented somewhere also..  the squid clientNatLookup function 
returns 0 if the connection was intercepted, -1 if not (normal 
connection).

Regards
Henrik
