From: Harald Welte <laforge@gnumonks.org>
Subject: Re: MSN Messenger ALG
Date: Thu, 27 Jun 2002 20:12:56 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020627181256.GN9003@naboo.rchrd.phub.net.cable.rogers.com>
References: <20020627112623.GD9003@naboo.rchrd.phub.net.cable.rogers.com> <000001c21dfc$3d236890$7200a8c0@blue>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: 'Amir Khandani' <amirk@broadcom.com>,
	netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Glover George <dime@gulfsales.com>
Content-Disposition: inline
In-Reply-To: <000001c21dfc$3d236890$7200a8c0@blue>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, Jun 27, 2002 at 12:01:05PM -0500, Glover George wrote:
> Yes, SIP can get very hairy, because it's primarily xml -ished based.
> The proper way to make MSN Messenger work is using Universal Plug n Play
> to do nat traversal.  http://linux-igd.sourceforge.net will make this
> work (every feature except file transfer, which we at the UPnP forum are
> trying to get Microsoft to hurry up and fix (along with many router
> vendors)).  

For security reason I'd _never ever_ run a upnp igd on any firewall.
This is just insane.  The firewall has no possibility of knowing if the 
upnp request is sent by a 'legitimate application' or by some new
outlook macro virus.

> If there was indeed an SIP conntrack however, it would be so much nicer,
> because there are a lot of packages coming out that use SIP but do not
> use UPnP.  It's just a matter of sparking enough interest in it to get
> someone knowledgeable in netfilter to write one (or someone learning
> from scratch).

the SIP/SDP helper would be the most complex conntrack helper for
netfilter.  Even H.323 is harmless compared to the full SIP/SDP
protocol.  And there are corner cases like encrypted/authenticated SDP
messages where you will never be able to do NAT.


> Glover George
> Systems/Networks Administrator

-- 
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
============================================================================
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M- 
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)
