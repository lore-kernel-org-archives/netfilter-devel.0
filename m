From: "David S. Miller" <davem@davemloft.net>
Subject: Re: per-cpu table information
Date: Thu, 16 Sep 2004 12:47:48 -0700
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040916124748.2138bed4.davem@davemloft.net>
References: <41402D9E.5050906@rediffmail.com>
	<20040915223602.GF2678@sunbeam.de.gnumonks.org>
	<20040915154738.7cb24983.davem@davemloft.net>
	<20040916071202.GH2678@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, swapsn@rediffmail.com
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040916071202.GH2678@sunbeam.de.gnumonks.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, 16 Sep 2004 09:12:02 +0200
Harald Welte <laforge@netfilter.org> wrote:

> Anyway, pkttables will simply have a 'matchinfo/targinfo read only'
> policy (everybody who needs a writable memory needs to dynamically
> allocate and do his own locking), and not have per-rule countes anymore.
> This means the whole ruleset is read-only and we don't need any code
> replication.

Sounds great.
