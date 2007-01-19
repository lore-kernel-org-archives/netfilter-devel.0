From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [patch] netfilter: implement TCPMSS target for IPv6
Date: Fri, 19 Jan 2007 13:27:23 +0900 (JST)
Message-ID: <200701190427.l0J4ROP3004489@toshiba.co.jp>
References: <20070114192011.GA6270@clipper.ens.fr> <45ABCB29.7080600@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: david.madore@ens.fr, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <45ABCB29.7080600@trash.net>
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


Hi, Patrick,

From: Patrick McHardy <kaber@trash.net>
Date: Mon, 15 Jan 2007 19:42:49 +0100

> David Madore wrote:
> > Implement TCPMSS target for IPv6 by shamelessly copying from
> > Marc Boucher's IPv4 implementation.
> 
> 
> This is an x_tables port of the TCPMSS target. Care to give it a try?
> I believe Yasuyuki is currently working on proper x_tables support
> for userspace, but that might still take a while, so If you send me
> your userspace port I'll add it to SVN for the time being.

Have you already completed removing unmaintained extensions for iptables ?
If so, I'll rebase my tree and send patches.

-- Yasuyuki Kozakai
