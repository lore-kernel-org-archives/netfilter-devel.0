From: John M Flinchbaugh <glynis@butterfly.hjsoft.com>
Subject: Re: kernel crash
Date: Thu, 29 May 2003 17:20:16 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030529212016.GA7740@butterfly.hjsoft.com>
References: <3ED67067.6080605@eburg.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary=LQksG6bCIzRHxTLp;
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
In-reply-to: <3ED67067.6080605@eburg.com>
To: Gordon Messmer <yinyang@eburg.com>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 29, 2003 at 01:41:11PM -0700, Gordon Messmer wrote:
> May 28 16:18:08 tog-wakko4 kernel: LIST_DELETE:=20
ip_conntrack_core.c:303=20
> `&ct->tuplehash[IP_CT_DIR_REPLY]'(f687fbc4) not in &ip_conntrack_hash=20
> [hash_conntrack(&ct->tuplehash[IP_CT_DIR_REPLY].tuple)].
> May 28 16:18:52 tog-wakko4 kernel: LIST_DELETE:=20
ip_conntrack_core.c:303=20
> `&ct->tuplehash[IP_CT_DIR_REPLY]'(f687cd24) not in &ip_conntrack_hash=20
> [hash_conntrack(&ct->tuplehash[IP_CT_DIR_REPLY].tuple)].
> May 28 16:18:52 tog-wakko4 kernel: LIST_DELETE:=20
ip_conntrack_core.c:303=20
> `&ct->tuplehash[IP_CT_DIR_REPLY]'(f687ce64) not in &ip_conntrack_hash=20
> [hash_conntrack(&ct->tuplehash[IP_CT_DIR_REPLY].tuple)].

what iptables statements are you running at startup?

i had a similar problem, i think, last summer due to _overlapping_ nat
rules causing a race condition.  i'm not sure anyone ever knew what to
do about it, but i did find that tweaking some rules kept the bug from
being triggered.

http://marc.theaimsgroup.com/?l=3Dnetfilter-devel&m=3D102750186506947&w=3D2

i used to use:
iptables -t nat -A POSTROUTING -j SNAT --to 64.192.31.41
iptables -t nat -A POSTROUTING -j SNAT --to 192.168.1.1
iptables -t nat -A POSTROUTING -j SNAT --to 127.0.0.1

and now i use something very similar to (now i have 3 ifs):
iptables -t nat -A POSTROUTING -j SNAT -o eth0 --to 64.192.31.41
iptables -t nat -A POSTROUTING -o eth1 -s 192.168.1.0/24 \
	 -j SNAT --to 192.168.1.1
iptables -t nat -A POSTROUTING -o eth2 -s 192.168.2.0/24 \
	 -j SNAT --to 192.168.2.1

i've formulated the opinion that the first set of rules would match a
packet on multiple rules and mangle the packet more than once, while
the new rule set only matches packets going certain directions, so a
packet only matches one rule.

i think these multiple matches caused a race condition and hung the
machine.  does this make any sense to anyone?

the idea of these rules is to mangle the destination of a packet that
came in on an interface and got forwarded back out the same interface.
this allows a port forward to work from any network, even if it's the
same network.  here's my example:
iptables -t nat -A PREROUTING -p tcp \
	--destination 64.192.31.41 --destination-port 2080 \
	-j DNAT --to 192.168.1.2:80

with the SNATs above, this connection works:
    192.168.1.2 -> 64.192.31.41:2080 -> 192.168.1.2:80
and return:
    192.168.1.2 <- 64.192.31.41 <- 192.168.1.2:80

if i only did the SNAT on the external ip, then the forward would only
work when the connection came from the outside.
a connection from the intranet would:
    192.168.1.2 -> 64.192.31.41:2080 -> 192.168.1.2:80
and return:
    192.168.1.2 <- 192.168.1.2:80=20
the return path wouldn't match up and thus the packets were just lost.
--=20
____________________}John Flinchbaugh{______________________
| glynis@hjsoft.com         http://www.hjsoft.com/~glynis/ |
~~Powered by Linux: Reboots are for hardware upgrades only~~

--LQksG6bCIzRHxTLp
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE+1nmQCGPRljI8080RAuYMAJ9omv1tRyofCE+tz7DRJg5qUSzt6ACfXLFt
2gOBRvU+jym2AR010vUvT4A=
=jcCv
-----END PGP SIGNATURE-----

--LQksG6bCIzRHxTLp--
