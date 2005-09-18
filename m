From: "David S. Miller" <davem@davemloft.net>
Subject: Re: netfilter QUEUE target and packet socket interactions buggy or
 not
Date: Sun, 18 Sep 2005 00:27:30 -0700 (PDT)
Message-ID: <20050918.002730.74976897.davem@davemloft.net>
References: <4326FF69.9060004@trash.net> <871x3p875j.fsf@aka.i.naked.iki.fi>
	<432C58F5.8030306@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, naked@iki.fi
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <432C58F5.8030306@trash.net>
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
Date: Sat, 17 Sep 2005 19:57:09 +0200

> Nuutti Kotivuori wrote:
> > Just to reiterate, I still haven't been able to reproduce this on the
> > mainline kernel, only with RHEL 4 kernels. So if you want to skip
> > this, that's fine.
> 
> I didn't have a chance to look at your mails yet. I'll do so now, maybe
> it rings a bell.

I think the key datapoint right now is that they have a network
tap on the device active.  There could be something awry in the
AF_PACKET code of dev_queue_xmit_nit(), or similar, that doesn't
do SKB refcounting correctly.

Nuutti is it possible to test without the pcap packet tap active
on the interface?  That would help us enormously in narrowing down
where the problem might be.  If we can definitely put the blame
on the pcap being active, we can probably fix this very fast.
