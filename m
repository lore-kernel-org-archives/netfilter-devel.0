From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH]: 1st step to remove skb_linearize() in ip6_tables.c
 and optimization
Date: Thu, 24 Jun 2004 19:12:31 +0900 (JST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200406241012.TAA24555@toshiba.co.jp>
References: <200406240404.NAA01264@toshiba.co.jp>
	<1088064830.3104.21.camel@jds.i.dns-hungary.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, laforge@netfilter.org,
        usagi-core@linux-ipv6.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: kisza@securityaudit.hu
In-Reply-To: <1088064830.3104.21.camel@jds.i.dns-hungary.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hi, Andras,

From: Andras Kis-Szabo <kisza@securityaudit.hu>
Date: Thu, 24 Jun 2004 10:13:50 +0200

> Hi Yasuyuki,
> 
> you saved my life :)

I'm glad.

> When I tried to do the same a was not able to track behaviour of
> skb->nh. (There was some grey point, like when the packet leaves the
> machine over the tunnel interface.)

Tunnel interfaces reset nh.raw to new address of network protocol header.
Otherwide kernel can be down in many parts of IPv6 stack.

BTW, if I remember correctly, you also tryed to rewrite match modules which
find extension headers. Have you already finished ? If so, you'll save my life,
too :)

> > 	- In all match module, the only arguments of match() are changed.
> I think it is not a problem since the ip6tables - as I know - not a
> 'core' product. We can break the compatibility / usability of these
> extensions. (And it will push us to fix the problems and sync the
> matches with the IPv4 parts.)
> Could you add an #error string right after the definitions in the
> matches?
>
> In this case the compilation of the matches will cause strange error
> messages - and someone have to answer all of them. An error message
> should help a little bit. (Eg.: Known error point. This part is under
> reconstruction. Please, be patient. etc.)

my patch doesn't remove skb_linearize() and I'll keep it until all IPv6
modules in main kernel has changed. and if match module uses old API,
compilation errors are occurred and user can notice and report that.
Then I think adding #error string to match module is not needed.

But I'm reminded by you that target modules doesn't cause compiling error.

OK, I try to solve this problem... But how same problem was managed when
removing skb_linearize() from "ip_tables.c" ? Maybe the order of arguments
of target() were changed ?

Anyone knows about that ?

-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>
