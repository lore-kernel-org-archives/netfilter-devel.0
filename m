From: Oskar Andreasson <blueflux@koffein.net>
Subject: Re: can tcp stream reassembly be done in netfilter
Date: Wed, 27 Aug 2003 10:35:10 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.53.0308271030240.2748@oskar-lap.agatha>
References: <200308261011937.SM00856@zhengcb>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: zhengchuanbo <zhengcb@netpower.com.cn>
In-Reply-To: <200308261011937.SM00856@zhengcb>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 26 Aug 2003, zhengchuanbo wrote:

> 	Can netfilter do the tcp stream reassembly? I mean something like
> what snort do in the stream process. I wish this could be done in the
> kernel.

No, netfilter is a packet filter. It works on a per packet basis, below
the transport layer. Actually it does do some work on the transport layer,
but not much, and definitely not a lot of work on the application layers.

All of this comes down to one thing, netfilter simply doesnt care about
streams. That's when you should use snort or proxy solutions of one sort
or another.

>
> regards,
> chuanbo zheng
> zhengchuanbo@sina.com
>
>
>
>
>
>
>
>

----
Oskar Andreasson
http://www.frozentux.net
http://iptables-tutorial.frozentux.net
http://ipsysctl-tutorial.frozentux.net
mailto:blueflux@koffein.net
