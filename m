From: Harald Welte <laforge@gnumonks.org>
Subject: Re: conntrack performance/DoS formula
Date: Tue, 2 Jul 2002 16:55:51 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020702145551.GN18333@naboo.rchrd.phub.net.cable.rogers.com>
References: <20020628203624.A4136@oknodo.bof.de> <15644.45834.373409.220647@isis.cs3-inc.com> <20020628213520.C4136@oknodo.bof.de> <15644.53466.193145.914415@isis.cs3-inc.com> <20020628232819.H4136@oknodo.bof.de> <15644.58258.483223.56527@isis.cs3-inc.com> <20020629140729.N4136@oknodo.bof.de> <20020629143406.O4136@oknodo.bof.de> <20020630103131.X4136@oknodo.bof.de> <15647.24217.324807.354846@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick Schaaf <bof@bof.de>, netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Don Cohen <don-nf@isis.cs3-inc.com>
Content-Disposition: inline
In-Reply-To: <15647.24217.324807.354846@isis.cs3-inc.com>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, Jun 30, 2002 at 12:40:09PM -0700, Don Cohen wrote:
> Clearly one easy defense against one easy attack (as was mentioned in 
> private communication) is that whenever you want to add to a bucket
> that is full, you should feel free to throw out the oldest UNREPLIED
> connection in that bucket.  

if we're going to change the overall strategy into limiting the number
of list-entries per bucket, this is definitely the way to go.  just
deleting unreplied in the case ip_conntrack_max is reached doesn't make
sense anymore.

> If you're interested in preventing attacks that consume connection
> table space devoted to "real" connections I have some ideas, but
> that's another large discussion.  If lots of people out there want to
> hear it I'll send to the list, otherwise perhaps it's better off the
> list.

please send it to the list, this way people can later read it for
reference purpose, and you encourage more people to discuss it.

> On a related subject, I'm worried that UNREPLIED might not mean
> what I think it does.  Your data contains things like:
>  tcp 6 387070 ESTABLISHED src=9.163.211.64 dst=165.130.71.38 sport=3228
>  dport=1301 [UNREPLIED] src=165.130.71.38 dst=9.163.211.64 sport=1301
>  dport=3228 use=1
> How can one half of the connection be established while the other half
> is unreplied?  Is this cause in one direction a syn was sent and a
> syn-ack was received, and that makes it established, while in the
> other direction a syn-ack was sent and nothing more was received so
> it's unreplied?  That doesn't make much sense.  They should both be
> established only if the entire handshake is complete, right?

The problem here is most likely that cat /proc/net/ip_conntrack does not
read out the conntrack entries atomically.  

We really should have ctnetlink for gathering the contents of the
conntrack hash table... I'll try to have it ready soon.

> You were describing unreplied connections that hang around for 5 days.
> When I send some random syn's I see stuff like
>  cat /proc/net/ip_conntrack
>  tcp      6 113 SYN_SENT src=10.0.3.2 dst=10.0.2.3 sport=4096 ...
> I'm guessing the 113 is the timeout, and that it was originally set to
> 120, which still seems way too long to me, but a lot better than
> 5 days.

so now send a single ACK packet and see what happens... This is needed
for connection pickup.

-- 
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
============================================================================
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M- 
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)
