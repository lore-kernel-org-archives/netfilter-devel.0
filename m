From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] Netfilter: Don't cachline align slab allocs
Date: Mon, 17 Jan 2005 14:36:14 -0800
Message-ID: <20050117143614.638b474c.davem@davemloft.net>
References: <1105947649.3954.39.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, anton@samba.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <1105947649.3954.39.camel@localhost.localdomain>
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

On Mon, 17 Jan 2005 18:40:49 +1100
Rusty Russell <rusty@rustcorp.com.au> wrote:

> Name: Don't cachline align slab allocs
> Status: Trivial
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> Anton points out that cacheline aligning conntrack entries is a wank.
> He's right: there's lots of them, and they're currently ~200 bytes.
> Same with the cargo-cult programming in ipt_hashlimit.

Applied, thanks.
