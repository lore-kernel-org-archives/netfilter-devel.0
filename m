From: Harald Welte <laforge@gnumonks.org>
Subject: Re: Security flaw in Stateful filtering ??????
Date: Sat, 8 Jun 2002 09:44:17 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020608074417.GC1109@naboo.de.gnumonks.org>
References: <3D007FF0.2080304@cs.auc.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Mikkel Christiansen <mixxel@cs.auc.dk>
Content-Disposition: inline
In-Reply-To: <3D007FF0.2080304@cs.auc.dk>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, Jun 07, 2002 at 11:42:08AM +0200, Mikkel Christiansen wrote:
> Hi 
> 
> I'm still not sure I quite understand what actions an 
> ACK packet from an unregistered connection causes when 
> running in connection-pickup mode. Mainly, I'm interested
> in knowing whether it causes a new connection to be 
> registered in the connnection table or not?

yes, of course, it causes a new conntrack table entry to be created.
the entry will be UNREPLIED.  So in case the other end behind the
firewall will reply with an ACK packet, we call the connection
ESTABLISHED.

In case we run out of conntrack entries, the UNREPLIED entries are
deleted, because they _could_ be from an ACK scan.

> Thanks for all the feedback - atleast to us - this is 
> a quite interesting discussion.

... a discussion which has happened multiple times before.

look in the mailinglist archives and search for conntrack entries with
high timeount and UNREPLIED state.

> -Mikkel

-- 
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
============================================================================
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M- 
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)
