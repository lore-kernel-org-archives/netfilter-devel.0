From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH 2.6] netfilter conntrack optimization (LIST_DELETE)
Date: Sun, 24 Aug 2003 05:00:53 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030824050053.1747dfe7.davem@redhat.com>
References: <20030824085742.GQ6750@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030824085742.GQ6750@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 24 Aug 2003 10:57:42 +0200
Harald Welte <laforge@netfilter.org> wrote:

> The following patch against 2.6.0-test4 (courtesy of Patrick McHardy)
> optimizes the conntrack code.  In the old implementation, the hash function
> was passed to the LIST_DELETE macro, which resulted in it being called
> two times instead of one.

Applied to 2.6.x

> This patch also applies to 2.4.x - but I think we should wait for
> 2.4.23-preX to come up first.  Do you want me to re-submit it for
> 2.4.23-preX, once it shows up?

... and queued for 2.4.23-preX
