From: Gong Su <gongsu@lightforge.cs.columbia.edu>
Subject: Re: local NAT
Date: Thu, 12 Jun 2003 18:11:57 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200306122211.h5CMBwa10020@lightforge.cs.columbia.edu>
References: <20030611120649.GK32593@sunbeam.de.gnumonks.org>
Reply-To: "Gong Su" <gongsu@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nils Radtke <Nils.Radtke@Think-Future.de>,
   netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-reply-to: Your message of "Wed, 11 Jun 2003 14:06:49 +0200."
             <20030611120649.GK32593@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Harald, excuse my jumping in, I do this all the time. ;-)
Here is why. A establishes a connection to B. Then A is suspended
and reconnected at C. Normally the connection A<->B seen by
the transport would be dropped. Well, not if you let the transport
keep thinking the connection A<->B is still there, but translate
it into C<->B underneath. That is, on C you SNAT A<->B into C<->B
for outgoing traffic; on B you SNAT C<->B back into A<->B for
incoming traffic (and you to DNAT appropriately for the reverse
traffic of course). This will transparently migrating an existing
connection A<->B from A to C (B remains stationary) without ever
touching the transport that I'm doing. I'm currently using a patch
I made myself to do it. But it would be great if you could incorporate
it into netfilter base. It also feels kinda strange that current
netfilter local NAT only works for "half" of the traffic, i.e.,
outgoing only. Hope what I described makes sense to you.

Thanks,
-- 
/Gong


Thus did Harald Welte <laforge@netfilter.org> write:
*>
*>--rCwQ2Y43eQY6RBgR
*>Content-Type: text/plain; charset=us-ascii
*>Content-Disposition: inline
*>Content-Transfer-Encoding: quoted-printable
*>
*>On Sat, Jun 07, 2003 at 11:50:04PM +0200, Nils Radtke wrote:
*>>   Question:
*>>   Is there code around implementing the feature of SNATting incoming
*>>   packets for local processes?
*>
*>not that I am aware of.  And I can still not imagine a setup where this
*>would make any sense.  Please enlighten me.
*>
*>>       Nils Radtke
*>
