From: Harald Welte <laforge@gnumonks.org>
Subject: Re: MSN Messenger ALG
Date: Tue, 2 Jul 2002 16:32:09 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020702143209.GK18333@naboo.rchrd.phub.net.cable.rogers.com>
References: <20020627112623.GD9003@naboo.rchrd.phub.net.cable.rogers.com> <000001c21dfc$3d236890$7200a8c0@blue> <20020627194913.A2890@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Glover George <dime@gulfsales.com>,
	'Amir Khandani' <amirk@broadcom.com>, netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Patrick Schaaf <bof@bof.de>
Content-Disposition: inline
In-Reply-To: <20020627194913.A2890@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, Jun 27, 2002 at 07:49:14PM +0200, Patrick Schaaf wrote:
> On Thu, Jun 27, 2002 at 12:01:05PM -0500, Glover George wrote:
> > Yes, SIP can get very hairy, because it's primarily xml -ished based.
> 
> SIP is very similar to HTTP, and thus any special protocol action would
> best be handled by the traditional application level gateway. The REDIRECT
> target can be used to transparently address that gateway.
> 
> There's no need for any new magic within iptables, I think.

yes, there is. Please believe me, I've spent days reading through the
SIP specs and reading all the documents about SIP firewall/NAT
traversal.

People have even written Master Thesis' about this issue, because of
it's complexity.

In the end, a combination of an application-level proxy and the
firewall/nat device is needed, where the proxy is instructing the
firewall/nat device what to do.

> best regards
>   Patrick

-- 
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
============================================================================
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M- 
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)
