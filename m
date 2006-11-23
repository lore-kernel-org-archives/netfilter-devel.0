From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/4][CONNTRACK] Introduce flag facilities to take over
 TCP connections
Date: Thu, 23 Nov 2006 14:28:09 +0100
Message-ID: <4565A1E9.4060802@trash.net>
References: <4553D2F2.1020107@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <4553D2F2.1020107@netfilter.org>
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

Pablo Neira Ayuso wrote:
> This patch introduces two new flags called IPS_PICKUP that forces the
> protocol handler to pick up the window of valid TCP packets and
> IPS_IN_WINDOW to by pass window checkings.
> 
> Moreover, four new attributes to inject the window scale factor and
> enable SACK are introduced. These new facilities provide the appropiate
> mechanisms to take over TCP connections in failover settings with TCP
> tracking enabled.

I still think a simple flag/mask attribute would be nicer and
would save lots of code. The TCP flag values are already exposed
to userspace. Something like:

CTA_PROTOINFO_TCP_FLAGS_ORIGINAL:

struct tcp_flags {
	u_int32_t flags;
	u_int32_t mask;
};

ct->proto.tcp.seen[].flags &= ~attr->mask;
ct->proto.tcp.seen[].flags |= attr->flags & attr->mask;

Even better might be to nest all directional attributes under
a CTA_ORIGNAL/CTA_REPLY attribute.
