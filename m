From: "Preston A. Elder" <prez@srealm.net.au>
Subject: Re: [netfilter-core] iptables/conntrack in enterprise environment.
Date: Thu, 29 May 2003 08:09:52 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200305290810.16531.prez@srealm.net.au>
References: <200305290113.58552.prez@srealm.net.au> <20030529083953.GB2461@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: netfilter@lists.netfilter.org,
	netfilter-devel@lists.netfilter.org, coreteam@netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030529083953.GB2461@sunbeam.de.gnumonks.org>
Content-Description: clearsigned data
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

=2D----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On Thursday 29 May 2003 04:39 am, Harald Welte wrote:
> On Thu, May 29, 2003 at 01:13:47AM -0400, Preston A. Elder wrote:
> > Hi,
> >
> > I am in an enterprise environment and I'm having some problems with
> > conntrack specifically.
> >
> > They're running 2.4.20 kernels (mostly vanilla) with iptables 1.2.7a.
>
> Do not use 2.4.20 if you want to use connection tracking.  2.4.20
> connection tracking is totally broken due to a change introduced in the
> core kernel.
>
> Please do always use patch-o-matic from CVS.  The patch you want to
> apply for fixing this bug is 10_confirm_fix.patch
This patch was applied already.  Infact, I'm using Gentoo (but using the=20
'vanilla' kernel from gentoo, so its not got every patch under the sun), an=
d=20
I specifically picked out and applied the followint patches:
018_gcc31-compile-optimizations
021_ecc-20020904
701_iptables-20_iptables-proc
702_iptables-24_conntrack-nosysctl
722_iptables-tcplimit
724_iptables-u32
741_iptables-ip_conntrack_find
742_iptables-ip_ct_refresh_optimization
744_iptables-03_ip_conntrack_proto_tcp-lockfix
747_iptables-06_ftp-conntrack-msg-fix
748_iptables-07_ECN-tcpchecksum-littleendian-fix
752_iptables-10_confirm_fix
753_iptables-10_local-nat-expectfn
759_iptables-24_conntrack-modify-after-free-fix
760_iptables-25_ip_tables-comment-fix
766_iptables-33_ipqueue_memoryleak
764_iptables-31_nat_parse_fix
770_iptables-ip_conntrack-timeouts
900_quick-fixes
902_minor_fixes

Please let me know if you think one is missing I should try.

> Also, considering
>
> > echo 524280 >/proc/sys/net/ipv4/ip_conntrack_max
>
> without using a larger hash size (modprobe ip_conntrack hashsize=3Dfoo,
> wherer foo should be a prime number and in the range of 524280/2)
I'll try this and report back.

> > to be re-directed to a local port, which is achieved with the command:
> > /sbin/iptables -t nat -A PREROUTING -j DNAT -i eth0 -p tcp -d <ip-range>
> > - --destination-port 1024:65535 --to-destination <local_ip>:<local_port>
> >
> > Every inbound connection incurs an entry in the connection tracking
> > table.  It seems, however, that we may be overloading the conntrack
> > system.
>
> I've seen systems with way more conntrack entries and higher bandwith.
> Using NAT however, might have a big performance impact.
Well, this system itself isn't doing 'nat', however, by implication, the ab=
ove=20
rule makes every connection nat'd.

> > The conntrack table itself very quickly grows - but it does not clean
> > itself up when the connection itself dissapears, instead it waits for
> > some pre-determined timeout value,
>
> With a non-broken kernel it is 2 minutes, that is TIME_WAIT of a TCP
> socket.
That was not my point.  My point was, for up to 5 days later, the system st=
ill=20
has entries in the conntrack table (listed as 'ESTABLISHED'), which have be=
en=20
dead and gone for a long time, conntrack does not realise that connection i=
s=20
utterly closed, and it should drop its conntrack entry.  I'm not as worried=
=20
about the lower-value timeouts, but as I said, I saw ALOT of established=20
connections hanging around in the conntrack table (making the conntrack tab=
le=20
about 200,000 entries long, give or take), most of which were entries for=20
connections already closed.

=2D --=20
PreZ
Systems Administrator
Shadow Realm

PGP FingerPrint: B3 0C F3 32 DE 5A 7D 90  26 F6 FA 38 CC 0A 2D D8
=46inger prez@srealm.net.au for full PGP public key.

Shadow Realm, a hobbyist ISP supplying real internet services.
http://www.srealm.net.au
=2D----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE+1finKFp14D8AGEQRAmT5AJ48csFfxVIMJQykL5mhG7VQzx/79wCgjmQ1
drFKsTbUeJ8F0EEicWgBosQ=3D
=3DQWoJ
=2D----END PGP SIGNATURE-----
