From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH 2.6] netfilter NAT optimization
Date: Sun, 24 Aug 2003 04:58:14 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030824045814.2c36068c.davem@redhat.com>
References: <20030824085600.GP6750@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030824085600.GP6750@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 24 Aug 2003 10:56:00 +0200
Harald Welte <laforge@netfilter.org> wrote:

> The following patch against 2.6.0-test4 (courtesy of Patrick McHardy)
> optimizes the NAT code.  In the old implementation, the hash function
> was passed to the LIST_DELETE macro, which resulted in it being called
> two times instead of one.

Applied to 2.6.x, thanks.

> This patch also applies to 2.4.x - but I think we should wait for
> 2.4.23-preX to come up first.  Do you want me to re-submit it for
> 2.4.23-preX, once it shows up?

I also put this into my 2.4.23-preX tree, don't worry about it.
:-)
