From: Patrick Schaaf <bof@bof.de>
Subject: Re: Security flaw in Stateful filtering ??????
Date: Thu, 6 Jun 2002 21:12:11 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020606211211.B21880@oknodo.bof.de>
References: <3CFF9A00.2070805@cs.auc.dk> <20020606195706.A21880@oknodo.bof.de> <3CFFAB1C.902@cs.auc.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Emmanuel Fleury <fleury@cs.auc.dk>
Content-Disposition: inline
In-Reply-To: <3CFFAB1C.902@cs.auc.dk>; from fleury@cs.auc.dk on Thu, Jun 06, 2002 at 08:34:04PM +0200
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> > The behaviour is intentional. The reason is "connection pickup". Imagine
> > a situation where the firewall reboots. All active conntracking information
> > will be lost. With the observed behaviour, connections are "relearned"
> > on the fly as they create new traffic.
> 
> I simply disagree with you on this point (sorry :-/).

Umm. No need to be sorry. Disagreement are what spans up a problem domain.

> I wouldn't accept to have such a flaw in my firewall just because of
> an hypothetic reboot of one of my gateway !!!!

That's your policy choice. I may have others, in other situations.

> Of course, I could be wrong,

In your policy choice? Unlikely.

> but in this case this 'feature' should be
> highly documented and be disabled as default. IMHO.

Any sensible patch to the current documentation has a good chance of being
applied immediately.

Disabling the current behaviour is out of the question. iptables is used
as-is in the field.

> One of the major argument in favor of the stateful inspection is that
> it prevents from a lot of weird scans (NULL scan, X-MAS scan, ACK scan,
> ...).

My personal "must have" reason is proper per-tcp-connection NAT, i.e. the
ability to change rules without breaking already-active connections.

That's not dependant on reboot/pickup, so I probably personally wouldn't
care in most setups where I used iptables' conntracking in the past.

But if I learned that such a radical change were imminent, I'd be very
alert to recall where it may bite me in my "installed base", and I'd
probably miss one or two.

> Anyway, I should browse the archive of the mailing-list and try to
> convinced myself how foolish I am. :-)

Just remember that you are arguing out of your current view of where to
utilize iptables, and that you can easily implement the no-pickup policy
using a suitable rule "idiom", or using one of the explicit patches.

all the best, and low jitter to your students' measurements
  Patrick
