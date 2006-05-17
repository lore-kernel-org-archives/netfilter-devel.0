From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] fix mem-leak in netfilter
Date: Tue, 16 May 2006 23:59:10 -0700 (PDT)
Message-ID: <20060516.235910.71774114.davem@davemloft.net>
References: <20060515204142.GO7774@kenobi.snowman.net>
	<20060515210342.GP7774@kenobi.snowman.net>
	<446AC1FB.5070406@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: sfrost@snowman.net, gcoady.lk@gmail.com, laforge@netfilter.org,
	netfilter-devel@lists.netfilter.org,
	linux-kernel@vger.kernel.org, marcelo@kvack.org, willy@w.ods.org,
	azez@ufomechanic.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <446AC1FB.5070406@trash.net>
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

From: Patrick McHardy <kaber@trash.net>
Date: Wed, 17 May 2006 08:26:03 +0200

> Stephen Frost wrote:
> > Looking at this again...  The ttl isn't copied into 'ttl' unless the
> > check_set has TTL turned on.  This means that the overwritting was fine,
> > if you accept that you can only ever match on TTL, or never match on it.
> > That doesn't seem right to me.  The TTL in the table should always be
> > kept up-to-date and the only question is if the current rule requires it
> > for a match or not.
> 
> 
> OK, updated patch attached. The TTL is now always kept up-to-date.

Looks nice.

Is there any reasonable reason to allow ip_pkt_list_tot to ever be
larger than say 255?  If we can accept that limit, we can shrink
the recent_entry considerably by packing the index and nstamps
into a single word next to ttl.
