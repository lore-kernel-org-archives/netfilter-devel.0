From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH 2.4] netfilter listhelp.c: fix erroneous (const)
Date: Fri, 20 Feb 2004 10:40:39 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040220104039.0a370308.davem@redhat.com>
References: <20040220182818.GL4797@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040220182818.GL4797@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 20 Feb 2004 19:28:18 +0100
Harald Welte <laforge@netfilter.org> wrote:

> Please apply the following fix to your 2.4.x tree, it fixes an erroneous
> 'const' qualifier introduced by one of our last patches.

Applied, thanks.

> A 2.6.x re-sync (probably the last one that syncs from 2.4 to 2.6 and
> not the other way around) will follow in a couple of minutes.

Bring it on :-)
