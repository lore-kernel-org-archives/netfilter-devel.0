From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [netfilter-core] bad performance: bug or missing optimisation?
Date: Fri, 29 Aug 2003 15:23:37 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030829052521.57DA12C0BD@lists.samba.org>
References: <Pine.LNX.4.51.0308271216130.27606@dns.toxicfilms.tv>
Cc: Karlis Peisenieks <karlis@mt.lv>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Maciej Soltysiak <solt@dns.toxicfilms.tv>
In-reply-to: Your message of "Wed, 27 Aug 2003 12:20:21 +0200."
             <Pine.LNX.4.51.0308271216130.27606@dns.toxicfilms.tv>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

In message <Pine.LNX.4.51.0308271216130.27606@dns.toxicfilms.tv> you write:
> Do you remeber what I reported some time ago about a problem with ICMP
> redirects. When the NAT module was loaded, after some time, the kernel
> stopped reacting to ICMP redirects sent by one of my routers. When i
> unloaded the NAT module, everything came back to normal, and the kernel
> reacted to redirects and used to send the packets to the proper IPs.

Hi Maciej,

	Definitely a different problem.  ICMP errors are handled
very differently from pings.  I assume you were actually doing NAT at
the time?

Rusty.
--
  Anyone who quotes me in their sig is an idiot. -- Rusty Russell.
