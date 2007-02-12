From: David Miller <davem@davemloft.net>
Subject: Re: netfilter tables config problem
Date: Mon, 12 Feb 2007 12:23:24 -0800 (PST)
Message-ID: <20070212.122324.112265617.davem@davemloft.net>
References: <20061222183312.f3cf3220.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netdev@vger.kernel.org, netfilter-devel@lists.netfilter.org
To: randy.dunlap@oracle.com
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20061222183312.f3cf3220.randy.dunlap@oracle.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Fri, 22 Dec 2006 18:33:12 -0800

> 
> (on 2.6.20-rc1-git8)
> 
> It's possible to have
> CONFIG_NETFILTER_XTABLES=y
> and
> CONFIG_IP6_NF_MATCH_IPV6HEADER=m,
> 
> which causes this build error:
> net/built-in.o: In function `hashlimit_match':
> xt_hashlimit.c:(.text+0x1c887): undefined reference to `ipv6_find_hdr'
> make: *** [.tmp_vmlinux1] Error 1
> 
> Clean build if I set
> CONFIG_IP6_NF_MATCH_IPV6HEADER=y.
> 
> .config (for i386) attached.

I'm pretty sure we fixed that one already.  Randy do you have some
objection to testing 2.6.20-final when discoving such bugs? :-)

