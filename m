From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Handling Port-Unreachable Response to UDP
Date: Tue, 29 Jul 2003 01:00:57 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0307290100140.2829-100000@filer.marasystems.com>
References: <Pine.LNX.4.51.0307281716420.11010@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Tim Burress <tim@variosecure.net>, <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Maciej Soltysiak <solt@dns.toxicfilms.tv>
In-Reply-To: <Pine.LNX.4.51.0307281716420.11010@dns.toxicfilms.tv>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 28 Jul 2003, Maciej Soltysiak wrote:

> Hmm, how about having a configurable amount of UDP related ICMPs for
> retransmision handling, then destroying the conntrack entry.
> If we're flooded the packets will not get matched after some threshold
> (say 3), and possible retransmissions will get through.

Isn't that sort of what we have today (a short timeout after ICMP 
unreachable)

Regards
Henrik
