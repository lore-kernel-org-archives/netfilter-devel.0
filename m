From: Willy Tarreau <willy@w.ods.org>
Subject: Re: [PATCH] modification in current protocol helper API to handle error/unclean packets
Date: Mon, 21 Jun 2004 06:20:46 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040621042046.GA17389@alpha.home.local>
References: <40CCECFF.9070907@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
   Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
Content-Disposition: inline
In-Reply-To: <40CCECFF.9070907@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Pablo,

On Mon, Jun 14, 2004 at 02:10:39AM +0200, Pablo Neira wrote:
 
> This way, Jozsef could call unclean() here in his tcp-window-tracking 
> patch and we won't need to add protocol specific function to the core of 
> the conntrack system like icmp_error_track to handle special ICMP 
> messages. We could also check for unclean udp and icmp packets.

There is something else I've been thinking about for a long time. In all
my configs, I first match the packet against 'unclean' in the PREROUTING
chain, and since I also use tcp_window-tracking, the check is performed
twice (at least on TCP). Wouldn't it be interesting to put a flag somewhere
on the packet being evaluated to mark it 'already checked', and that a few
matches could set ? That way, we could avoid the same test being done twice.

Just a few thoughts anyway.

Cheers,
Willy
