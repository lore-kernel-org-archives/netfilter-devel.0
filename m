From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: String match then SNAT from find
Date: Sun, 14 Mar 2004 01:08:51 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0403140106450.17900-100000@filer.marasystems.com>
References: <Pine.LNX.4.44.0403122223210.16818-100000@Trademart-1.ednet.ns.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: James MacLean <macleajb@ednet.ns.ca>
In-Reply-To: <Pine.LNX.4.44.0403122223210.16818-100000@Trademart-1.ednet.ns.ca>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 12 Mar 2004, James MacLean wrote:

> Method was to use Squid to add the X-Forwarded-For: <ip> header, then in 
> POSTROUTING, use it to set the SNAT address. Would this even work?

Won't work. You need to apply NAT on the initial SYN packet of the 
session, and this is before the X-Forwarded-For header is seen...

As for the rest of your questions.. a target can act as a match. If you in 
a target finds that you do not really want to act on this packet then 
return IPT_CONTINUE and iptables continues with the next rule.

Regards
Henrik
