From: "David S. Miller" <davem@davemloft.net>
Subject: Re: per-cpu table information
Date: Wed, 15 Sep 2004 15:47:38 -0700
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040915154738.7cb24983.davem@davemloft.net>
References: <41402D9E.5050906@rediffmail.com>
	<20040915223602.GF2678@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, swapsn@rediffmail.com
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040915223602.GF2678@sunbeam.de.gnumonks.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, 16 Sep 2004 00:36:02 +0200
Harald Welte <laforge@netfilter.org> wrote:

> Because we don't need any locking and we don't have cache line ping-pong
> between the CPU's, if there is no shared data.

In my opinion the disadvantages (both in code complexity and table
update cost) far outweigh whatever speed gains you this obtains.
