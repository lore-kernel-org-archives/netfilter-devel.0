From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2.4 0/18]: Netfilter resync with 2.6
Date: Tue, 21 Dec 2004 10:41:40 +0100
Message-ID: <41C7EFD4.9080006@trash.net>
References: <41C67BBB.6010100@trash.net>
	<20041220165509.152c058a.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20041220165509.152c058a.davem@davemloft.net>
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

David S. Miller wrote:

> Please don't put things like the Bitkeeper/etc/config changeset
> in your tree.  I can't pull in changes like that.
> 
> Unfortunately, I can't even "bk undo -r" that bogus change since
> it's not at the tip of the tree.  And I don't want to "bk cset -x"
> the changeset since that leaves the history of this crap in there.

Oops, sorry, I can't even remeber when I put this in.

> 
> Can you put together a clean tree without the Bitkeeper/etc/config
> change in it?  Thanks.

Sure, but it might take a few days.

Regards
Patrick
