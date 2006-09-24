From: Thomas Mader <thezema@gmail.com>
Subject: Re: remove connections notification by conntrack?
Date: Sun, 24 Sep 2006 11:51:18 +0200
Message-ID: <200609241151.31689.thezema@gmail.com>
References: <200609221359.22676.thezema@gmail.com>
	<200609231123.09148.thezema@gmail.com>
	<4515F71A.8070409@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1808600.GH3pGbPLe7";
	protocol="application/pgp-signature"; micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <4515F71A.8070409@netfilter.org>
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

--nextPart1808600.GH3pGbPLe7
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sunday 24 September 2006 05:10, Pablo Neira Ayuso wrote:
> events & IPCT_DESTROY
>
> > 		printk("We have been notified that connection %d was deleted!\n",
> > ct->id); }
> >
> > 	return 0;
> > }
> >
> >
> > static struct notifier_block ctnl_notifier =3D {
> > 	.notifier_call =3D ipaddr_conntrack_event,
> > };
> >
> >
> > static int __init init(void)
> > {
> > 	int ret;
> > 	need_conntrack();
> > 	ret =3D ip_conntrack_register_notifier(&ctnl_notifier);
> > 	if (ret < 0) {
> > 		printk("ipaddr_init: cannot register notifier.\n");
> > 		goto err_unreg_notifier;
> > 	}
> > 	//ip_conntrack_destroyed =3D destroyed_connect;
> >
> > 	printk(KERN_CRIT "init!\n");
> >    	return ipt_register_match(&ipaddr_match);
> >
> > err_unreg_notifier:
> > 		ip_conntrack_unregister_notifier(&ctnl_notifier);
> > 		return 1;
> > }
> >
> > But the problem remains the same. It works for TCP and I get properly
> > notified about those but not about UDP.
>
> Try with what I told you above and let me know if it works

No it doesn't. I tried "events & IPCT_DESTROY" already and it didn't work. =
Now=20
I tested it once again with same result.


--nextPart1808600.GH3pGbPLe7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iQIVAwUARRZVIxjLzKnHCDEhAQICOw/+O2FIb3RZ5jrq+VXdew3AtwdWzdrjxGsq
sBWNtK0xFdOzyxGINZfk1PpbHOYDFWTXRlhIJbwWzlL9HTBRuXE9gk+qJs5jrUBv
XQSaAZmuMqUKBnuKn7+cW2zyjfvHUBjKjZh9CtBHUj760rowYEQVqLHtNpC8FjJm
ixQtONnaYcYuNouDlwWBkXcFmfGoFQW4NXpLLMXdBlWSBWhn4h2oJxr3T1pME2Ct
5i5eoBEFBNPppPwNFdJZoAsxcNY4hPjwOoG42t1NqknqaynCoMNBqLEoWfjOZMKV
3fqA05BWUUfuJZyr22NlvgX4JAmgIElVKHEPSgFqSa1kg/9XrCL8TmTFot9i2VUD
pjFedA6N0BOa3uji+iqCLOb/5b4QQYcXpW0Q2BXMX4QC/lagqZmHpWG5krwrzR60
hpM0mlUjo5lJ6MJpYgJ+4/++vPPR3bPATdQh6gEFHqxCjqHAQn3m13VvnbGGrZhU
taTNwxVMgtR3hLWokE7yOZxFpspBi0pmuCbz3vDZYPCzzp4yeNecStuozF+TuAMN
RkAjIYpR0/18c7UJ8UsolfVT65ZSHWoeegIAyaJ+qgLGNovDVU5awwF/UlsKC0kn
GSKmw6F9g6Cnoygs/+dS1pvLpSAH1dZF1kY50MyqSWYYMszkGdIkULbUI812c4yL
y2VAhXAB2r0=
=oNiy
-----END PGP SIGNATURE-----

--nextPart1808600.GH3pGbPLe7--
