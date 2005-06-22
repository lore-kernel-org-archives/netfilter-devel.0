From: Tobias DiPasquale <codeslinger@gmail.com>
Subject: Re: Linux 2.6.12/iptables 1.3.1+CLUSTERIP issues
Date: Wed, 22 Jun 2005 09:07:02 -0400
Message-ID: <876ef97a050622060750b078bd@mail.gmail.com>
References: <876ef97a0506201904a05582a@mail.gmail.com>
	<20050622121509.GG4551@obroa-skai.de.gnumonks.org>
Reply-To: Tobias DiPasquale <codeslinger@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>,
	nf-devel <netfilter-devel@lists.netfilter.org>
In-Reply-To: <20050622121509.GG4551@obroa-skai.de.gnumonks.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On 6/22/05, Harald Welte <laforge@netfilter.org> wrote:=20
> this should never happen.  iptables always prefers
> $KERNEL_DIR/include/linux/netfilter_ipv4 above its local copy.  Are you
> sure KERNEL_DIR was set correctly while compiling iptables?

% cd iptables-1.3.1
% make KERNEL_DIR=3D/usr/src/linux-2.6.12 BINDIR=3D/sbin LIBDIR=3D/lib
MANDIR=3D/usr/share/man INCDIR=3D/usr/include

KERNEL_DIR above is where I had just two minutes before built a brand
new vanilla 2.6.12 kernel from my 2.6.11 config (with ipt_CLUSTERIP as
a module) and installed it. iptables correctly detected all compiled
extensions. Here's the diff between the two versions of the header
files:

adidas~/iptables-1.3.1/include/linux/netfilter_ipv4> diff -u
ipt_CLUSTERIP.h
/usr/src/linux-2.6.12/include/linux/netfilter_ipv4/ipt_CLUSTERIP.h
--- ipt_CLUSTERIP.h     2005-03-07 09:00:35.000000000 -0500
+++ /usr/src/linux-2.6.12/include/linux/netfilter_ipv4/ipt_CLUSTERIP.h
 2005-06-20 16:37:47.000000000 -0400
@@ -18,6 +18,7 @@
 struct ipt_clusterip_tgt_info {
=20
        u_int32_t flags;
+       struct clusterip_config *config;
=20
        /* only relevant for new ones */
        u_int8_t clustermac[6];
@@ -26,12 +27,6 @@
        u_int16_t local_nodes[CLUSTERIP_MAX_NODES];
        enum clusterip_hashmode hash_mode;
        u_int32_t hash_initval;
-
-#ifdef KERNEL_64_USERSPACE_32
-       u_int64_t config;
-#else
-       struct clusterip_config *config;
-#endif
 };
=20
 #endif /*_IPT_CLUSTERIP_H_target*/
adidas~/iptables-1.3.1/include/linux/netfilter_ipv4>

This is on an x86_64 (Athlon64) machine, btw.

> it is an error.  I will investigate any patches / fixes that have been
> sent to the list.

Nice, thanks. The two previous patches I was referring to were:

1. message from you on May 6, 2005, subject "[PATCH 2.6] Two
ipt_CLUSTERIP fixes"; your second patch deals with iptables -D rule
deletion for ipt_CLUSTERIP rules.

2. message from Pablo Neira on March 6, 2005, subject "[PATCH 2/2] fix
CLUSTERIP rule deletion in iptables" containing only an attached patch
file, "fix-cluster-del.patch".

When deleting a rule that uses --new, should you repeat the --new in
the iptables -D command?

> > Anyway, I'm glad that you can now update the node lists dynamically
> > now. This makes it usable.
>=20
> At which point was this not possible?  Or am I missing something?

Sorry, I just wasn't aware of this previously. I misspoke myself. I
was initially confused by the terminology "statically allocated" (in
the iptables man page?) used in referring to how the IP space was
divided between the nodes. Saru had provisions for this, as well, but
I believe they called it something else.
=20
> > I'm planning on writing a userspace driver for this module to make at
> > least the Win2K3 NLB functionality available to Linux users.
>=20
> I am not familiar with that functionality, can you give me a pointer?

Sure, this is a good introductory article:

http://www.west-wind.com/presentations/loadbalancing/NetworkLoadBalancingWi=
ndows2003.asp

Win2K3 NLB seems to have two modes: multicast (akin to CLUSTERIP) and
unicast, the latter of which I'm not really sure how it works. The
best I can figure, since it requires a dedicated interface for the
virtual IP, is that the "master" simply turns into a router that
routes requests to the other dedicated NICs in the cluster when the
traffic is not destined to the master. Those clusters then forward the
traffic from the dedicated NIC to the primary NIC for normal
processing.

Can you think of any other way this might work (my buddy and I can't)?
Would it be of any benefit to mirror this functionality in CLUSTERIP?
(they claim that they unicast mode is the faster of the two, in terms
of aggregated throughput)

--=20
[ Tobias DiPasquale ]
0x636f6465736c696e67657240676d61696c2e636f6d
