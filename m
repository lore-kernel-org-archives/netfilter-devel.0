From: "Glover George" <dime@gulfsales.com>
Subject: RE: MSN Messenger ALG
Date: Fri, 28 Jun 2002 08:46:57 -0500
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <000901c21eaa$4826ef60$7200a8c0@blue>
References: <20020627181256.GN9003@naboo.rchrd.phub.net.cable.rogers.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "'Amir Khandani'" <amirk@broadcom.com>,
	<netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: "'Harald Welte'" <laforge@gnumonks.org>
In-Reply-To: <20020627181256.GN9003@naboo.rchrd.phub.net.cable.rogers.com>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

As previously stated before.  We make no assumption that this is secure.
UPnP is finishing up a security mechanism to add on to the UPnP spec for
version 1.0, and version 2.0 of UPnP is not far off, so security
mechanisms are being put in place.   But for the moment, AS WITH
ANYTHING, if you take proper precautions to ensure that your rules in
iptables will prevent any untrusted machines from access UPnP gateway in
the first place, then you don't have these problems.  Sure an app could
request it, but so what?  An app could fake itself into being h.323 as
well.  

A UPnP IGD in version 1.0 is always simply a connectivity device, with
NO implications that it is secure.  The DOCS state it, the website
states it, UPnP forum states it, as well as I and many of my colleagues
on this list.

If there was ever an assumption that it is 100% secure, sorry for
misleading.  Nothing is 100% secure.

Glover George
Systems/Networks Administrator
Gulf Sales & Supply, Inc.
dime@gulfsales.com
(228)-762-0268


-----Original Message-----
From: Harald Welte [mailto:laforge@gnumonks.org] 
Sent: Thursday, June 27, 2002 1:13 PM
To: Glover George
Cc: 'Amir Khandani'; netfilter-devel@lists.samba.org
Subject: Re: MSN Messenger ALG

On Thu, Jun 27, 2002 at 12:01:05PM -0500, Glover George wrote:
> Yes, SIP can get very hairy, because it's primarily xml -ished based.
> The proper way to make MSN Messenger work is using Universal Plug n
Play
> to do nat traversal.  http://linux-igd.sourceforge.net will make this
> work (every feature except file transfer, which we at the UPnP forum
are
> trying to get Microsoft to hurry up and fix (along with many router
> vendors)).  

For security reason I'd _never ever_ run a upnp igd on any firewall.
This is just insane.  The firewall has no possibility of knowing if the 
upnp request is sent by a 'legitimate application' or by some new
outlook macro virus.

> If there was indeed an SIP conntrack however, it would be so much
nicer,
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
- Harald Welte / laforge@gnumonks.org
http://www.gnumonks.org/
========================================================================
====
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O-
M- 
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)
