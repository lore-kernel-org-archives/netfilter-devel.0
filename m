From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: multicast group traffic filtering
Date: Mon, 22 Dec 2003 12:03:00 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0312221153050.22245-100000@filer.marasystems.com>
References: <3FE6BF3C.9030400@binary-one.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jon Webb <jon_webb@binary-one.com>
In-Reply-To: <3FE6BF3C.9030400@binary-one.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 22 Dec 2003, Jon Webb wrote:

> not part of that group. I know that the matching code is able to match 
> on a multicast packet type, but I need to match on a specific group.

I thougt multicast groups was just IP addresses in the multicast class of
IP addresses... doesn't using the --destination match work?

But you really should be having this kinds of filters in the IGMP router
to not route memberships for other multicast groups. There is no good in
requesting multicast messages from your neighbors if you then decide to
immediately drop the same..

> or some sort of IGMP connection tracking/handling.

What would one connection track in multicast? Last time I looked there was 
no connections, just unspecified flows of traffic within each group.

Regards
Henrik
