From: "Gary W. Smith" <gary@primeexalia.com>
Subject: Proposed netmap patch
Date: Tue, 12 Jul 2005 10:16:24 -0700
Message-ID: <57F9959B46E0FA4D8BA88AEDFBE582909ED9@pxtbenexd01.pxt.primeexalia.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
To: <netfilter-devel@lists.netfilter.org>
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

=20
Hello,=20
=20
I'm not sure how to get this reviewed/applied so I'll just toss it to =
the list.  I had a need to use NETMAP but found it lacking the OUTPUT =
chain of the nat filter.  So I added it.  I have been running it for =
some time and it seems to work great.  Anyways, here is the patch that I =
used.  I found it useful.
=20
If you would like to review this and possibly commit it to CVS then by =
all means...
=20
Gary
=20
=20
--- linux-2.6.9.orig/net/ipv4/netfilter/ipt_NETMAP.c    2004-10-18 =
14:54:20.000000000 -0700
+++ linux-2.6.9/net/ipv4/netfilter/ipt_NETMAP.c 2005-04-15 =
10:31:44.719492104 -0700
@@ -46,7 +46,7 @@
                DEBUGP(MODULENAME":check: size %u.\n", targinfosize);
                return 0;
        }
-       if (hook_mask & ~((1 << NF_IP_PRE_ROUTING) | (1 << =
NF_IP_POST_ROUTING))) {
+       if (hook_mask & ~((1 << NF_IP_PRE_ROUTING) | (1 << =
NF_IP_POST_ROUTING) | (1 << NF_IP_LOCAL_OUT))) {
                DEBUGP(MODULENAME":check: bad hooks %x.\n", hook_mask);
                return 0;
        }
@@ -81,7 +81,7 @@
=20
        netmask =3D ~(mr->range[0].min_ip ^ mr->range[0].max_ip);
=20
-       if (hooknum =3D=3D NF_IP_PRE_ROUTING)
+       if (hooknum =3D=3D NF_IP_PRE_ROUTING || hooknum =3D=3D =
NF_IP_LOCAL_OUT)
                new_ip =3D (*pskb)->nh.iph->daddr & ~netmask;
        else
                new_ip =3D (*pskb)->nh.iph->saddr & ~netmask;
=20
