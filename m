From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 2.4 0/18]: Netfilter resync with 2.6
Date: Mon, 20 Dec 2004 16:55:09 -0800
Message-ID: <20041220165509.152c058a.davem@davemloft.net>
References: <41C67BBB.6010100@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <41C67BBB.6010100@trash.net>
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

On Mon, 20 Dec 2004 08:14:03 +0100
Patrick McHardy <kaber@trash.net> wrote:

> the following 18 patches resync netfilter in 2.4 with 2.6.
> They contains the ICMP+NAT fixes, Yasuyuki's IPv6 fixes
> and two misc. fixes.
> 
> You can pull all changes from bk://212.42.230.204/nf-2.4

Please don't put things like the Bitkeeper/etc/config changeset
in your tree.  I can't pull in changes like that.

Unfortunately, I can't even "bk undo -r" that bogus change since
it's not at the tip of the tree.  And I don't want to "bk cset -x"
the changeset since that leaves the history of this crap in there.

Can you put together a clean tree without the Bitkeeper/etc/config
change in it?  Thanks.
