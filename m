From: Harald Welte <laforge@gnumonks.org>
Subject: Re: Odp: problem with iplimit
Date: Mon, 21 Oct 2002 19:39:50 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021021173950.GA3039@naboo.club.berlin.ccc.de>
References: <003c01c25b36$a86d6b60$060110ac@localdomain> <20020915102430.C3810@sunbeam.de.gnumonks.org> <004601c25c98$58481aa0$060110ac@localdomain> <20020915135531.S3810@sunbeam.de.gnumonks.org> <006f01c2778a$8f8a6880$060110ac@localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Wojciech Maj <wojtektm@poczta.onet.pl>
Content-Disposition: inline
In-Reply-To: <006f01c2778a$8f8a6880$060110ac@localdomain>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, Oct 19, 2002 at 06:14:11PM +0200, Wojciech Maj wrote:
> Dear Sir
> 
> As You know, Gerd Knorr (the author of iplimit ) doesn't want to maintain
> it any more.
> Could You please have a look at iplimit code? It contain a nasty bug, which
> shows up if I try to limit the number of  parallel connections.
> Simply, sometimes the next incoming connection - which should be
> denied - is accepted. Because of this iplimit is useless.

Can you try to debug the problem further?  What kind of machine are you
using? Is it a SMP box? Is there any particular circumstance when the
problem happens?  Are you sure that connection tracking does really have 
a record for all of the already existing connections (try listing
/proc/net/ip_conntrack)?

> I need it to avoid some abuses in our local network.  Would You help
> me?

Sure, but it would be helpful if you could tell me more about the
problem.

Please Cc' netfilter-devel@lists.netfilter.org in your mails, so other
people can give helpful comments, in case they find something about this
problem.

> thanks in advance
> 
>             Wojtek
> 
> P.S.
> Forgive me my english please.I hope You know what I mean

No problem with your english.  I'm not a native speaker, either.

-- 
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
============================================================================
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M- 
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)
