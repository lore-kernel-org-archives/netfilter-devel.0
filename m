From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: Re: [netfilter-core] bad performance: bug or missing optimisation?
Date: Wed, 27 Aug 2003 12:20:21 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.51.0308271216130.27606@dns.toxicfilms.tv>
References: <20030827074745.A9C242C15B@lists.samba.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Karlis Peisenieks <karlis@mt.lv>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <20030827074745.A9C242C15B@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello,

> > While fighting with ICMP flood we came across strange NAT problem.
<snip>

> > No NAT was taking place, just conntrack and nat modules loaded.
<snip>

> Ah, there are a couple of problems here.
Do you remeber what I reported some time ago about a problem with ICMP
redirects. When the NAT module was loaded, after some time, the kernel
stopped reacting to ICMP redirects sent by one of my routers. When i
unloaded the NAT module, everything came back to normal, and the kernel
reacted to redirects and used to send the packets to the proper IPs.

Has that been investigated?

Regards,
Maciej
