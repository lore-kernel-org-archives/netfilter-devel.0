From: "Gary W. Smith" <gary@primeexalia.com>
Subject: Modifications to netmap target
Date: Fri, 15 Apr 2005 11:42:09 -0700
Message-ID: <27594E8BA9D5CA458F5EF87D88B6B48F1D4F@pxtvjoexd01.pxt.primeexalia.com>
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

After talking to Jason over on the netfilter users list about netmap =
target I found that it doesn't support the output chain of nat.=20
=20
I was looking through the code and found that it only registers itself =
with the pre and post route chains.  I was wondering if adding support =
for the output chain was as simple as adding the hook for the local_out =
and then ensuring that the correct modifications are made.  The =
following looks logically correct from looking into some of the source =
code for other modules.  Would more be required to make the ouput nat =
work with netmap?
=20
Example.
        if (hook_mask & ~((1 << NF_IP_PRE_ROUTING) | (1 << =
NF_IP_POST_ROUTING))) {
                DEBUGP(MODULENAME":check: bad hooks %x.\n", hook_mask);
                return 0;
        }
to:
        if (hook_mask & ~((1 << NF_IP_PRE_ROUTING) | (1 << =
NF_IP_POST_ROUTING) | (1 << NF_IP_LOCAL_OUT) )) {
                DEBUGP(MODULENAME":check: bad hooks %x.\n", hook_mask);
                return 0;
        }
=20
and=20
   if (hooknum =3D=3D NF_IP_PRE_ROUTING)
                new_ip =3D (*pskb)->nh.iph->daddr & ~netmask;
        else
to:
   if (hooknum =3D=3D NF_IP_PRE_ROUTING || hooknum =3D=3D =
NF_IP_LOCAL_OUT)
                new_ip =3D (*pskb)->nh.iph->daddr & ~netmask;
        else
=20
I put the above changes in and compiled and I was able load the table =
but I'm not sure what the other imacts might be.  Comments would be =
greatly appreciated.
=20
/sbin/iptables -t nat -A PREROUTING -d 10.0.0.56/29  -j NETMAP --to =
10.0.0.80/29
/sbin/iptables -t nat -A POSTROUTING -s 10.0.0.80/29 -j NETMAP --to =
10.0.0.56/29
/sbin/iptables -t nat -A OUTPUT -d 10.0.0.56/29  -j NETMAP --to =
10.0.0.80/29
=20
target     prot opt source               destination        =20
NETMAP     all  --  anywhere             10.0.0.56/29        =
10.0.0.80/29
Chain POSTROUTING (policy ACCEPT)
target     prot opt source               destination        =20
NETMAP     all  --  10.0.0.80/29         anywhere            =
10.0.0.56/29
Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination        =20
NETMAP     all  --  anywhere             10.0.0.56/29        =
10.0.0.80/29
=20
Gary Smith
