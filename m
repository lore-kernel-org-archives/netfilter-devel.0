From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH}: Make MARK target terminate (resend)
Date: Tue, 2 Jul 2002 17:45:23 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020702154523.GO18333@naboo.rchrd.phub.net.cable.rogers.com>
References: <200206291236.36997@henrik.marasystems.com> <Pine.LNX.4.33.0207011037260.12444-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Henrik Nordstrom <hno@marasystems.com>,
	netfilter-devel <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33.0207011037260.12444-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, Jul 01, 2002 at 11:47:09AM +0200, Jozsef Kadlecsik wrote:
> On Sat, 29 Jun 2002, Henrik Nordstrom wrote:
> 
> [...]
> > I proposed adding a new class of iptables things between matches and
> > targets, being neither a match for filtering or a target that
> > determines the ultimate fate of the packet. The names proposed for
> > these in the discussion was modifiers or actions.
> 
> I believe we have four possibilities
> 
> - multiple targets
> 
>   It has been rejected several times with good reasons: too error-prone
>   for the users and it would require heavy modifications both in the
>   kernel and the userspace.

the 'too heavy modification' issue is not really a problem anymore,
since the undergoing 'pkt_tables' rewrite [shared infrastructure for
iptables, ip6tables, arptables] and the linked-list rewrite.

> - a new class: actions
> 
>   With the new class, we would have to following skeleton of a rule:
> 
> 	IP match data
> 	list of matches
> 	list of actions
> 	single target
> 
>   Using any action would make sense only when the target is ACCEPT and
>   alike, so the actions function as 'always true' matches.
> 
>   One also has to note, that we have a nice, visible separation of matches
>   and targets by name: matches are lowercased, while targets are
>   uppercased. How could actions be fit into this scheme? How could one
>   decide by glimpse that we are speaking about a match, action or
>   target?
> 
>   [I'd name the new class as 'action' instead of 'modifier', because '-m'
>   is reserverd but '-a' is not.]

this sounds the most reasonable idea to me. 

> In my opinion the match solution would be better, cleaner.

I think introducing actions would be the way to go. but I'm not really
convinced of any of the 'solutions'.

> Regards,
> Jozsef

-- 
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
============================================================================
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M- 
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)
