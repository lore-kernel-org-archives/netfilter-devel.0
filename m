From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH}: Make MARK target terminate (resend)
Date: Wed, 3 Jul 2002 13:24:46 +0200 (CEST)
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <Pine.LNX.4.33.0207031255220.17202-100000@blackhole.kfki.hu>
References: <20020702142447.GI18333@naboo.rchrd.phub.net.cable.rogers.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Harald Welte <laforge@gnumonks.org>
In-Reply-To: <20020702142447.GI18333@naboo.rchrd.phub.net.cable.rogers.com>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 2 Jul 2002, Harald Welte wrote:

> On Mon, Jul 01, 2002 at 09:50:18AM +0200, Balazs Scheidler wrote:
> > On Sat, Jun 29, 2002 at 12:36:36PM +0200, Henrik Nordstrom wrote:
> > > On Saturday 29 June 2002 11.46, Patrick McHardy wrote:
> > > So the question to the Netfilter core team is if it would be OK to add
> > > a new option and "module class" to the userspace tools, and have the

> It is definitely useful.  I'd love to have this additional flexibility.
> A couple of issues, though:
>
> 1) definitely 2.5.x thing - thus it should wait until pkt_tables becomes
>    more apparent
> 2) I think this heavily confuses users, since a target can now be used
>    as a 'match'.  The current concept of netfilter/iptables is very
>    clear and well-defined.  Adding kludges like this sort-of breaks this
>    concept...

Also, no one answered the question yet on how to name an action module
without breaking the current clear distiction in name between match and
target modules.

If the pseudo targets were converted to match modules, most of them
could be unified with an already existing match module, which would
result a more compact codebase (tcpmss/TCPMSS, ttl/TTL, tos/TOS, etc,
etc.). I just repeat myself: the recent match is a nice example for
this approach.

> > - multiple targets
> >
> >   It has been rejected several times with good reasons: too error-prone
> >   for the users and it would require heavy modifications both in the
> >   kernel and the userspace.
>
> the 'too heavy modification' issue is not really a problem anymore,
> since the undergoing 'pkt_tables' rewrite [shared infrastructure for
> iptables, ip6tables, arptables] and the linked-list rewrite.

Then one should consider this approach as well. If we had the possibility
to specify multiple targets then the current clean concepts could be kept
as well.

new action class:
	pro: no ordering problem
	pro: clean separation of functionalities
	con: naming issue

match module:
	pro: no naming issue, current well known concepts can be kept
	pro: couple of modules can be unified
	con: ordering issue

multiple targets:
	pro: no naming issue, current well known concepts can be kept
	pro: no change required in the existing modules
	con: ordering issue (-j ACCEPT -j TTL)

Regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
WWW-Home: http://www.kfki.hu/~kadlec
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
