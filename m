From: "Accardi, Kristen C" <kristen.c.accardi@intel.com>
Subject: RE: connection destruction question
Date: Fri, 19 Mar 2004 10:04:03 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <F3DAEAD1F408F44FA1AF0BFAC11FEF9510DEF1@orsmsx408.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
content-class: urn:content-classes:message
To: "Unit Zero" <onyx@zero.fdns.net>, "Kristen Carlson" <kristenc@cs.pdx.edu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Thank you, that does interest me.  It does seem to match my needs more
closely than the other patch. I also have realized that my approach of
making a helper module to be notified when connections were created
wasn't going to work since I realized it would only be called on the
master connection and not on any of the related connections, and I need
to see state changes for all connections.  I will take a look at the
patch and see if it works out.

By the way, what are your plans for this patch?  I always hate the idea
of using a patch I actually have to maintain myself :), although of
course I will do that if that's what it takes to get my job done.

Kristen



-----Original Message-----
From: netfilter-devel-admin@lists.netfilter.org
[mailto:netfilter-devel-admin@lists.netfilter.org] On Behalf Of Unit
Zero
Sent: Friday, March 19, 2004 7:34 AM
To: Kristen Carlson
Cc: netfilter-devel@lists.netfilter.org
Subject: Re: connection destruction question




On Wed, 10 Mar 2004, Kristen Carlson wrote:

> Hello,
> Is there a way to be notified in a kernel module=20
> when a connection is destroyed?  I have a nice helper
> module that would like to know when connections are destroyed
> so it can do some internal cleanup work.=20
> Thanks,
> Kristen
>=20

Actually I ran into the exact same issue not long ago with a module I've

been working on. My solution was to add a couple lines here and there in

conntrack_core.c and ip_conntrack.h to implement a notifier chain and=20
export register/unregister routines from the ip_conntrack module,
allowing=20
other modules to add callback functions to the chain. The notifier chain

is then called from various parts of the conntrack_core code with an=20
event-code and a struct ip_conntrack ptr reference when conntracks are=20
created, destroyed (either explicitly or by timeout), become confirmed,=20
or become replied.

I've got a small patch that I put together about a month ago which has=20
my modifications described above. I'm pretty sure it will apply cleanly=20
to a 2.4.24-25 kernel source tree, but if not the modifications are
pretty=20
straight forward. Just thought it might be of interest.

- V. M. Condino
