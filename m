From: Willy Tarreau <willy@w.ods.org>
Subject: Re: [PATCH] modification in current protocol helper API to handle error/unclean packets
Date: Tue, 22 Jun 2004 06:39:28 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040622043928.GA21406@alpha.home.local>
References: <Pine.LNX.4.44.0406211102000.23953-100000@filer.marasystems.com> <Pine.LNX.4.33.0406211240500.31871-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Henrik Nordstrom <hno@marasystems.com>, Pablo Neira <pablo@eurodev.net>,
   Martin Josefsson <gandalf@wlug.westbo.se>,
   Patrick McHardy <kaber@trash.net>,
   Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33.0406211240500.31871-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Jozsef,

On Mon, Jun 21, 2004 at 12:51:41PM +0200, Jozsef Kadlecsik wrote:
 
> So you could live happily if such packets are marked as INVALID by
> conntrack, which implies then that the ICMP code/type checking would be
> acceptable as well? [Pablo's patch did not want to drop the packets but
> mark as INVALID.]
> 
> It's time to add documentation exactly which packets are dropped or marked
> as INVALID by conntrack.

May I ask that we could have a new result other than INVALID for such
packets ? It's becoming difficult to differenciate :

  - valid packets for which there is no session
  - valid packets for which there is a session but which are invalid wrt
    this session (wrong flags, sequence numbers, retransmits, ...)
  - invalid packets (in the 'unclean' sense)

and it's either not possible to differentiate between :
  - suspicious packets which we must let go through to try to re-establish
    a session or close a session (eg SYN), which currently generate a
    message such as "INVALID SYN (ignored)"
  - totally valid packets.

Perhaps we would need to add NOSESSION for the first case, keep INVALID
for the second case, add UNCLEAN for the third case, and IGNORED for the
fourth case. We could even add this only to ctstate so that setups relying
on the state match don't see any change.

It would really help for complicated setups and for people who want a
high level of tracability, such as a bank I know of.

Any thoughts ?

Regards,
Willy
