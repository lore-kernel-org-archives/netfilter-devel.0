From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Problen with transpartent proxy
Date: Mon, 3 Nov 2003 12:41:09 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0311031239070.23240-100000@filer.marasystems.com>
References: <1464.192.168.0.240.1067723204.squirrel@192.168.0.1>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: pivik@intelserv.kiev.ua
In-Reply-To: <1464.192.168.0.240.1067723204.squirrel@192.168.0.1>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, 1 Nov 2003 pivik@intelserv.kiev.ua wrote:

> I need LOG all forward packets using -j LOG for billing reason.
> 
> I need have in the LOG address of a source. With out SQUID all ok!
> iptables -I FORWARD -j LOG
> 
> But after I have setup transparent proxy all source addresses changed to
> address of my proxy server :((.

Correct, and you need to be using the Squid access log for billing of the 
proxied traffic.

Somewhat related note: transparent interception of traffic is generally an
evil hack and does break things. If possible the browsers should be
configured to use the proxy for best functionality.

Regards
Henrik
