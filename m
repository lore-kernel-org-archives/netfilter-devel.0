From: "David S. Miller" <davem@davemloft.net>
Subject: Re: Fw: Re: 2.6.11-rc2 TCP ignores PMTU ICMP (Re: Linux 2.6.11-rc2)
Date: Sun, 30 Jan 2005 22:49:55 -0800
Message-ID: <20050130224955.6c6b545c.davem@davemloft.net>
References: <20050127154118.45e59991.davem@davemloft.net>
	<41F992E3.20005@trash.net> <41F99BB8.4070409@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <41F99BB8.4070409@trash.net>
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

On Fri, 28 Jan 2005 02:56:08 +0100
Patrick McHardy <kaber@trash.net> wrote:

> Patrick McHardy wrote:
> 
> > IP (tos 0xd0, ttl  64, id 40755, offset 0, flags [none], length: 88) 
> > 172.16.1.123 > 172.16.1.123: icmp 68: type-#142 for IP (tos 0x10, ttl 
> > 180, id 13605, offset 0, flags [DF], length: 60, bad cksum e8b3 
> > (->73d8)!) 172.16.1.123 > 172.16.195.55:  ip-proto-225 40
> >
> > This patch fixes it.
> 
> This patch on top fixes corrupt checksums of ICMP errors. The
> function returns before recalculating the checksum in some cases.

Both applied, thanks Patrick.
