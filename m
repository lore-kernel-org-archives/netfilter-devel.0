From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [RFC] [PATCH] ipset: New set type fullipmap
Date: Fri, 17 Aug 2007 16:59:31 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0708171656390.30502@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0708160857080.13455@titan.stealer.net>
	<Pine.LNX.4.64.0708171306430.5492@fbirervta.pbzchgretzou.qr>
	<Pine.LNX.4.64.0708171338310.14154@titan.stealer.net>
	<Pine.LNX.4.64.0708171458380.30502@fbirervta.pbzchgretzou.qr>
	<Pine.LNX.4.64.0708171510130.14154@titan.stealer.net>
	<Pine.LNX.4.64.0708171541420.30502@fbirervta.pbzchgretzou.qr>
	<Pine.LNX.4.64.0708171550190.14154@titan.stealer.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
To: Sven Wegener <sven.wegener@stealer.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0708171550190.14154@titan.stealer.net>
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


On Aug 17 2007 16:53, Sven Wegener wrote:
>
> The question is, are 8 MiB less memory required for an empty set
> worth the "overhead" the management of a tree structure creates.

Yes! Because you read the bitmap much more often than you modify it
(the only place where (de)allocations are done).

> The all bits set case, that the large index table does with the 8
> MiB without needing additional memory, would require a marker like
> you suggested or we need to use a global allocated tree element
> that has the special meaning to mark the whole subtree as included.
> But that would only work on octet boundary. As always, two sides of
> a coin, but I'll give it a shot. :)

The octet boundary is a good comprimise, I think.



	Jan
-- 
