From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/1] Re: dangerous? Setting mark in nat table
Date: Wed, 14 Mar 2007 14:08:22 +0100
Message-ID: <45F7F3C6.3060908@trash.net>
References: <et6fp4$l04$1@sea.gmane.org>		<Pine.LNX.4.61.0703131632190.18488@yvahk01.tjqt.qr>		<45F6CD7C.40708@ufomechanic.net>		<Pine.LNX.4.61.0703131717440.18488@yvahk01.tjqt.qr>		<1173868532.26913.39.camel@henriknordstrom.net>		<45F7D657.8070907@trash.net>	<1173876211.26913.73.camel@henriknordstrom.net>
	<45F7F027.9050300@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Jan Engelhardt <jengelh@linux01.gwdg.de>,
	Henrik Nordstrom <henrik@henriknordstrom.net>
To: Amin Azez <azez@ufomechanic.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45F7F027.9050300@ufomechanic.net>
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

Amin Azez wrote:
> Signed-off-by: Sam Liddicott <azez@ufomechanic.net>
> ------------------------------------------------------------------------
> 
> Index: linux-2.6.17.1/net/netfilter/xt_CONNMARK.c
> Index: linux-2.6.17.1/net/netfilter/xt_MARK.c

There are quite a few more that are restricted to mangle without
good reason:

net/netfilter/xt_CLASSIFY.c:            .table          = "mangle",
net/netfilter/xt_CONNSECMARK.c:         .table          = "mangle",
net/netfilter/xt_DSCP.c:                .table          = "mangle",
net/netfilter/xt_MARK.c:                .table          = "mangle",
net/netfilter/xt_SECMARK.c:             .table          = "mangle",
net/ipv4/netfilter/ipt_ECN.c:   .table          = "mangle",
net/ipv4/netfilter/ipt_TOS.c:   .table          = "mangle",
net/ipv4/netfilter/ipt_TTL.c:   .table          = "mangle",
net/ipv6/netfilter/ip6t_HL.c:   .table          = "mangle",

If we're going to remove this, I think we should do it for all of them.
The manpages also need to be updated.
