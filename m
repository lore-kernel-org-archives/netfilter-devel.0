From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] nfsim TCP related fixes
Date: Tue, 22 Feb 2005 02:24:41 +1100
Message-ID: <1108999481.16083.1.camel@localhost.localdomain>
References: <Pine.LNX.4.58.0502210859300.834@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.58.0502210859300.834@blackhole.kfki.hu>
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

On Mon, 2005-02-21 at 09:07 +0100, Jozsef Kadlecsik wrote:
> Hi,
> 
> I discovered two TCP related bugs in gen_ip: TCP SEQ and ACK numbers were
> converted from string to u_int16_t instead of u_int32_t and full length
> TCP options could not be specified.

Don't think so: string_to_number uses int.  You couldn't specify >
2billion though.  We should just make string_to_number() use unsigned
since noone wants -ve numbers anyway.  Other fix looks fine: feel free
to simply commit.

Rusty.
-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
