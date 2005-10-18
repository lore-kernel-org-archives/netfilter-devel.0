From: Pablo Neira <pablo@eurodev.net>
Subject: Re: CONNMARK target without ip_conntrack
Date: Wed, 19 Oct 2005 00:34:03 +0200
Message-ID: <4355785B.5090802@eurodev.net>
References: <20051018221702.GA22386@packetconsulting.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Piotr Chytla <pch@packetconsulting.pl>
In-Reply-To: <20051018221702.GA22386@packetconsulting.pl>
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

Piotr Chytla wrote:
> Mark set/restore/save is set when ip_conntrack structure exist , but
> there is no warning message in logs about not loaded ip_conntrack or
> something similar. Maybe it's wise to put some warning message :
> 
> if (ct) {
> 	[..]
> } else printk(KERN_ERR "CONNMARK: no conntrack!\n");

No. Even with ip_conntrack loaded it could possible that a skb doesn't
have any conntrack associated: in that case it means that the packet is
considered invalid.

--
Pablo
