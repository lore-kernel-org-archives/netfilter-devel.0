From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2] Cleanup returnvalues of protocolhandlers
Date: Sun, 19 Sep 2004 22:41:20 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <414DEEF0.8020508@trash.net>
References: <1095597972.8380.16.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <1095597972.8380.16.camel@tux.rsn.bth.se>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Martin Josefsson wrote:

>Hi Patrick
>
>Here's the second of two patches based on Pablo Neiras patch.
>
>This adds new defines to be returned from conntrack protocol modules in
>order to make it clear what they want. Most importantly, they get rid of
>the confusing mixing of positive and negative returnvalues.
>  
>
A couple of conversion where missing in ip_conntrack_proto_icmp.c,
I've added them to the patch. BTW: shouldn't we return CONNTRACK_INVALID
for all invalid icmp packets ? icmp_error returns CONNTRACK_INVALID for
these packets, icmp_error_message (after simple 1:1 conversion) returns
CONNTRACK_CONT.

Regards
Patrick
