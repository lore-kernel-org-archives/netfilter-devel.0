From: Amin Azez <azez@ufomechanic.net>
Subject: Re: [PATCH 1/2] flow match
Date: Mon, 11 Jul 2005 16:08:47 +0100
Message-ID: <42D28B7F.7090103@ufomechanic.net>
References: <20050628234912.GB23662@wsc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20050628234912.GB23662@wsc.edu>
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

Thanks Josh;

Veridict:

Useful=Yes

The first patch applies OK. but the second (timer patch) gives compile
errors thus:

net/ipv4/netfilter/ipt_timer.c: In function `match':
net/ipv4/netfilter/ipt_timer.c:34: structure has no member named
`read_locked_map'
net/ipv4/netfilter/ipt_timer.c:34: structure has no member named
`write_locked_map'
net/ipv4/netfilter/ipt_timer.c:34: structure has no member named `l'
net/ipv4/netfilter/ipt_timer.c:34: structure has no member named
`read_locked_map'
net/ipv4/netfilter/ipt_timer.c:40: structure has no member named
`read_locked_map'
net/ipv4/netfilter/ipt_timer.c:40: structure has no member named
`read_locked_map'
net/ipv4/netfilter/ipt_timer.c:40: structure has no member named `l'
net/ipv4/netfilter/ipt_timer.c: In function `checkentry':
net/ipv4/netfilter/ipt_timer.c:59: structure has no member named
`read_locked_map'
net/ipv4/netfilter/ipt_timer.c:59: structure has no member named
`write_locked_map'
net/ipv4/netfilter/ipt_timer.c:59: structure has no member named `l'
net/ipv4/netfilter/ipt_timer.c:59: structure has no member named
`read_locked_map'
net/ipv4/netfilter/ipt_timer.c:61: structure has no member named
`read_locked_map'
net/ipv4/netfilter/ipt_timer.c:61: structure has no member named
`read_locked_map'
net/ipv4/netfilter/ipt_timer.c:61: structure has no member named `l'
make[3]: *** [net/ipv4/netfilter/ipt_timer.o] Error 1
make[2]: *** [net/ipv4/netfilter] Error 2
make[1]: *** [net/ipv4] Error 2
make: *** [net] Error 2

amin

Josh Samuelson wrote:
> Greetings all,
> 
> This patch requires Pablo Neira's conntrack event API patch.  It's been
> many months since I've posted, but I've been tracking the changes that
> have been made and making the necessary revisions to the code.
> Thanks Pablo for the heads-up on my silly misuses of the locks,
> hopefully I've got those cleared up. :)  I also added the ability to
> track new and established flows to the module.  Also I used
> Patrick McHardy's iterative state method of looping over the hashes
> for the proc files.  I figured it was high time to submit it again.
> 
> Quoting the man page for the match:
> 
>   This module allows you to match a packet when the specified number of
>   known protocol connections is exceeded.  The matches can be made
>   against generic IP, ICMP, TCP or UDP flow counters.  This match can be
>   used in all tables but raw.
> 
>   Matches when >= n flows exist
> 
>   --DIR-PROTOCOL[-TYPE] [!] n
>       where DIR is orig or repl for original and reply directions
>       respectively.  PROTOCOL is ip, icmp, tcp or udp.  TYPE is n or
>       e.  TYPE n is for new connections.  TYPE e is for established
>       connections.  Specifying no TYPE results in the comparison being
>       made for all PROTOCOL connections regardless of TYPE.
> 
> The patch should apply to 2.6.12 and iptables v1.3.1.  Though I'll
> be away from my email for the next week, I would appreciate any
> feedback.  Questions?  Comments?  Useful/Not?
