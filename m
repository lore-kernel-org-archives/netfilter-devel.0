From: "Glover George" <dime@gulfsales.com>
Subject: RE: MSN Messenger ALG
Date: Thu, 27 Jun 2002 12:01:05 -0500
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <000001c21dfc$3d236890$7200a8c0@blue>
References: <20020627112623.GD9003@naboo.rchrd.phub.net.cable.rogers.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: "'Harald Welte'" <laforge@gnumonks.org>,
	"'Amir Khandani'" <amirk@broadcom.com>
In-Reply-To: <20020627112623.GD9003@naboo.rchrd.phub.net.cable.rogers.com>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Yes, SIP can get very hairy, because it's primarily xml -ished based.
The proper way to make MSN Messenger work is using Universal Plug n Play
to do nat traversal.  http://linux-igd.sourceforge.net will make this
work (every feature except file transfer, which we at the UPnP forum are
trying to get Microsoft to hurry up and fix (along with many router
vendors)).  

If there was indeed an SIP conntrack however, it would be so much nicer,
because there are a lot of packages coming out that use SIP but do not
use UPnP.  It's just a matter of sparking enough interest in it to get
someone knowledgeable in netfilter to write one (or someone learning
from scratch).

Glover George
Systems/Networks Administrator
Gulf Sales & Supply, Inc.
dime@gulfsales.com
(228)-762-0268


-----Original Message-----
From: netfilter-devel-admin@lists.samba.org
[mailto:netfilter-devel-admin@lists.samba.org] On Behalf Of Harald Welte
Sent: Thursday, June 27, 2002 6:26 AM
To: Amir Khandani
Cc: netfilter-devel@lists.samba.org
Subject: Re: MSN Messenger ALG

On Wed, Jun 26, 2002 at 11:44:14AM -0700, Amir Khandani wrote:
> Hi,
> Is there a ALG for MSN Messenger in iptables? I need that to get file
> transfer and voice working between NATed clients.

I assume you are talking about the SIP protocol?

No, nobody came up to either write or sponsor support for SIP yet. It's
a fairly complex protocol...

> thanks for any help,
> -amir

-- 
Live long and prosper
- Harald Welte / laforge@gnumonks.org
http://www.gnumonks.org/
========================================================================
====
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O-
M- 
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)
