From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH 2.6] optimization of ip_conntrack_proto_tcp:tcp_packet()
Date: Mon, 29 Mar 2004 20:17:22 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040329201722.7a22cf7c.davem@redhat.com>
References: <20040329103348.GC1528@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040329103348.GC1528@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 29 Mar 2004 12:33:48 +0200
Harald Welte <laforge@netfilter.org> wrote:

> This is the first in a set of 2.6.x optimization patches.  Obviosly,
> they are meant for 2.6.6, not 2.6.5.  Please apply to your tree, thanks.
> 
> A: Pablo Neira
> D: This patch cleans up tcp_packet().  No semantical change, just juggling
> D: code pieces.  

I'm going to applies these to my 2.6.6 netfilter pending tree.

BUT!  Please think about these changes very carefully.  The order
of testing these state pieces in the TCP header is important.

For example, how it is valid, in this change, to blindly accept a
RESET packet to kill a conntrack entry before verifying the sequence
number(s) (as appropriate per rfc793 rules)?

This looks really suspicious to me.
