From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: about the tcp connection state
Date: Sun, 15 Feb 2004 23:57:29 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0402152337450.2594-100000@filer.marasystems.com>
References: <20040215183662.SM00868@guozheng>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: chuanbo zheng <zhengcb@netpower.com.cn>
In-Reply-To: <20040215183662.SM00868@guozheng>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 15 Feb 2004, chuanbo zheng wrote:

> I noticed in the difination of tcp_conntracks, tcp_conntracks[0][2][TCP_CONNTRACK_NONE]
> will be TCP_CONNTRACK_ESTABLISHED. then when an ACK packet without SYN is received by
> netfilter, the state would be directly changed to ESTABLISHED. Is there reason for doing
> like this?

I think you are confusing to different ESTABLISHED concepts here.

TCP_CONNTRACK_ESTABLISHED is just the TCP state of the tracked connection,
not the conntrack state. The two are not related other than timeouts.

The conntrack state of this packet is still NEW, as it would be for a SYN, 
as traffic has only been seen in one direction.

Note: conntrack is not about firewalling, it is about classifying traffic
into connections.

Regards
Henrik
