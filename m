From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH 2.6] netfilter /proc/net/ip_conntrack locking fix
Date: Wed, 28 Jan 2004 16:01:49 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040128160149.65b3854b.davem@redhat.com>
References: <20040127214559.GD11761@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040127214559.GD11761@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 27 Jan 2004 22:45:59 +0100
Harald Welte <laforge@netfilter.org> wrote:

> Please apply the following fix to your 2.6.x tree.
> 
> Name: Grab ip_conntrack_expect_tuple_lock in list_conntracks
> Author: Rusty Russell
> Status: Experimental

Applied, thanks.

But please in the future, when providing patch authors give me an
email address to use.  Luckily I know Rusty's so this one I could
handle :)
