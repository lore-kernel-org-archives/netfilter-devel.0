From: Harald Welte <laforge@netfilter.org>
Subject: Re: Fun for netfilter developers :)
Date: Tue, 6 May 2003 20:32:23 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030506183223.GJ14822@sunbeam.de.gnumonks.org>
References: <20030506161515.GH14822@sunbeam.de.gnumonks.org> <20030506171550.GD23689@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ucgz5Oc/kKURWzXs"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
Content-Disposition: inline
In-Reply-To: <20030506171550.GD23689@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Ucgz5Oc/kKURWzXs
Content-Type: multipart/mixed; boundary="FCKy2vjPBX+S/5dE"
Content-Disposition: inline


--FCKy2vjPBX+S/5dE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 06, 2003 at 07:15:50PM +0200, Patrick Schaaf wrote:
> On Tue, May 06, 2003 at 06:15:15PM +0200, Harald Welte wrote:
> > Fun for netfilter developers :)
>=20
> I would love to laugh, but I cannot easily find out what to make
> of that 4k binary file (extension 'rpm', presumably the source)
> that they link to. The tools (rpm and alien) that my Debian has
> for dealing with RPMs, look scary to me (require superuser...)

A source RPM does not need superuser privilege to be installed, since=20
'rpm -i' will just extract the source and the SPEC file.

See the attached source file, as it is contained in that .src.rpm file.

> I know I could learn a lot about RPM. I managed without, up to now.

You've missed something.  Well, but I'm a real RPM-lover.  I use debian
only because I want to have the same distribution on all of my systems
(sparc32,sparc64,ppc,x86) and there's a dpkg for almost anything.

Please _do not_ follow up onto the list about the package manager
subject, as it is totally off topic.

> So, sorry, I cannot laugh. I can only step down this soapbox, again :)

Maybe now you can laugh.  At least they did care about T/TCP.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--FCKy2vjPBX+S/5dE
Content-Type: text/x-csrc; charset=us-ascii
Content-Disposition: attachment; filename="tcp_sec.c"
Content-Transfer-Encoding: quoted-printable

/*
 * TCP security netfilter hook=20
 *
 * Handles following TCP security issues :
 * CERT VU#464113 - tcp SYN with FIN/RST packets not discarded.=20
 *
 * Co-exists with all other standard netfilter modules.=20
 * Written by Ashish Kalra, the SCO Group ( ashishk@sco.com )
 */

#include <linux/module.h>
#include <linux/netfilter.h>
#include <linux/netfilter_ipv4/ip_tables.h>
#include <linux/skbuff.h>
#include <linux/ip.h>
#include <linux/tcp.h>

/* new tcp options ( for t/tcp ) */
#define CC_opt		11		/* connection count */
#define CCnew_opt	12		/* new connection count */
#define CCecho_opt	13		/* connection count echo */

#define EOL		0		/* End-of-TCP options list (EOL) */

nf_hookfn tcp_sec_hook;

static struct nf_hook_ops tcp_sec_ops[]
=3D { { { NULL, NULL }, tcp_sec_hook, PF_INET, NF_IP_LOCAL_IN, NF_IP_PRI_FI=
LTER },
};

unsigned int
tcp_sec_hook(unsigned int hook,
	 struct sk_buff **pskb,
	 const struct net_device *in,
	 const struct net_device *out,
	 int (*okfn)(struct sk_buff *))
{
	struct iphdr *iph;
	struct tcphdr *tcph;
	struct sk_buff *skb_in =3D *pskb;

	iph =3D skb_in->nh.iph;

	if (iph->protocol =3D=3D IPPROTO_TCP) {
		tcph =3D (struct tcphdr *)((__u32 *) iph+iph->ihl );

		/*
		 * T/TCP control segments can have SYN & FIN together to
		 * reduce overall TCP segments, i.e, SYN+FIN is legal=20
		 * especially for T/TCP segments. Discarding SYN+FIN packets
		 * will break T/TCP, hence checking if the packet contains
		 * new TCP - TTCP/TAO (TCP accelerated open) options, then allow
		 * the packet, if not discard it.
		 */
		if (tcph->syn && tcph->fin) {=20
			unsigned int opt_offset =3D sizeof(struct tcphdr);
			unsigned char *optp =3D (unsigned char *)tcph;

			while (opt_offset < (tcph->doff << 2)) {
				/*	printk(KERN_ALERT "opt =3D %d\n",
							optp[opt_offset]); */
				switch (optp[opt_offset]) {
					case CC_opt:=20
					case CCnew_opt:
					case CCecho_opt:
						return NF_ACCEPT;
					case EOL:
						return NF_DROP;
					default :
						;
				}

				if (optp[opt_offset] < 2) ++opt_offset;
				else opt_offset +=3D optp[opt_offset+1]?:1;
			}
			return NF_DROP;=20
		}

		if (tcph->syn && tcph->rst) {
			/* printk(KERN_ALERT "tcp syn+rst segment\n"); */
			return NF_DROP;
		}

		/* No need to check for SYN+ACK, as initial SYN to open a
		 * connection is one of the few segments that does not contain
		 * an ACK. Linux TCP will anyway discard any ACK packet it=20
		 * receives in LISTEN state
		 */
	}

	return NF_ACCEPT;
}


static int tcp_sec_init(void)
{
	int ret;

	ret =3D nf_register_hook(tcp_sec_ops);
	if (ret < 0) {
		printk(KERN_ALERT "nf_register_hook failed\n");
		return -ENODEV;
	}
	return 0;
}

static void tcp_sec_cleanup_module (void)
{
	nf_unregister_hook(tcp_sec_ops);
}

module_init(tcp_sec_init);
module_exit(tcp_sec_cleanup_module);

--FCKy2vjPBX+S/5dE--

--Ucgz5Oc/kKURWzXs
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+t/+3XaXGVTD0i/8RAnrQAJ9hyqCnZa2lgce5CAdUBy8Ao2WKuQCgq/rD
gsqvcpVDh7EpnN84Btj3naw=
=DWnC
-----END PGP SIGNATURE-----

--Ucgz5Oc/kKURWzXs--
