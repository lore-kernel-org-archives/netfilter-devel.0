From: Patrick McHardy <kaber@trash.net>
Subject: Re: New target: can't delete rule
Date: Thu, 08 Sep 2005 00:34:52 +0200
Message-ID: <431F6B0C.7070303@trash.net>
References: <1126116594.3690.35.camel@Pentium> <431F6A0E.1090707@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Gervasio Bernal <gervasiobernal@speedy.com.ar>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <431F6A0E.1090707@eurodev.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Pablo Neira wrote:
> I bet that you have a pointer in the private info section of the target.
> See that iptables sets that pointer to NULL at rule creation.
> Afterwards, once checkentry() is called, such pointer won't be NULL
> anymore.
> 
> At removal, the rule built by iptables sets that pointer to NULL. Such
> rule will be compared with the ruleset hold in kernel space but no
> matches will be found since the pointers mismatch.
> 
> This problem is well known and it's very easy to fix up (look for
> userspacesize and offsetof in iptables/extensions). See ipt_limit,
> ipt_CLUSTERIP...

Thanks, I didn't know about this problem. We should really focus on
a netlink interface to iptables once nf_conntrack is in, even without
pkttables.
