From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH 2.6] netfilter resync with 2.4.x
Date: Fri, 20 Feb 2004 14:56:41 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040220145641.7b9633e7.davem@redhat.com>
References: <20040220195452.GM4797@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
In-Reply-To: <20040220195452.GM4797@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 20 Feb 2004 20:54:52 +0100
Harald Welte <laforge@gnumonks.org> wrote:

> The attached patch re-syncs 2.6.x netfilter with recent changes in
> 2.4.x.  Let's hope this is the last time we sync in this direction.
> 
> - update listhelp.h to benefit from prefetching
> - more efficient selective_cleanup() implementation in conntrack
> - export number of conntrack buckets via r/o sysctl

Missing linux/sysctl.h change to add the buckets conntrack sysctl number,
conflicted with the C99 patch which I already applied...

But don't worry, I fixed all of these problems and the changes are in :)
