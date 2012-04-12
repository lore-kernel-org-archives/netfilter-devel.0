From: Eric Leblond <eric@regit.org>
Subject: Re: [PATCH v2.1] conntrack: add /proc entry to disable helper by
 default
Date: Thu, 12 Apr 2012 18:06:11 +0200
Message-ID: <1334246771.6042.13.camel@tiger.regit.org>
References: <1332917824-4839-1-git-send-email-eric@regit.org>
	 <1332940790-18337-1-git-send-email-eric@regit.org>
	 <1332940790-18337-2-git-send-email-eric@regit.org>
	 <20120412152651.GA10677@1984>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-h88qCwnLpHw7qhZPbwPK"
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:58474 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932965Ab2DLQHY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Apr 2012 12:07:24 -0400
In-Reply-To: <20120412152651.GA10677@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-h88qCwnLpHw7qhZPbwPK
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

On Thu, 2012-04-12 at 17:26 +0200, Pablo Neira Ayuso wrote:
> Hi Eric,
>=20
> On Wed, Mar 28, 2012 at 03:19:50PM +0200, Eric Leblond wrote:
> > This patch gives the user different methods to disable
> > the attachment of helper to all connections on a given
> > port. The idea is to allow the user to choose with the CT target
> > the helper assignement he wants to have.
> >=20
> > First method it to use the 'nf_conntrack_helper' option on the
> > nf_conntrack module and set it to 0. As this is a constraint to do
> > this at the time of the loading, a /proc entry is also available.
> > Setting sys/net/netfilter/nf_conntrack_auto_assign_helper to 0 will
> > disable the automatic assignement of the helper.
>=20
> I have modified your patch a bit, please find the one I plan to apply
> enclosed to this email.
>=20
> I have also heavily rewritten the description. I decided to keep you
> as author, if you're OK with it.

OK for authoring. I really like more the new description :)

>=20
> Regarding this:
> http://www.netfilter.org/news.html#2012-04-03
>=20
> I'll expand those news to be a bit more verbose, as it will be the
> reference the patch will point to.

Seems a good idea.

>=20
> You can find the list of changes below.
>=20
> > ---
> >  include/net/netfilter/nf_conntrack_helper.h |    3 +
> >  include/net/netns/conntrack.h               |    2 +
> >  net/netfilter/nf_conntrack_core.c           |    6 ++
> >  net/netfilter/nf_conntrack_helper.c         |   82 +++++++++++++++++++=
+++++++-
> >  4 files changed, 92 insertions(+), 1 deletions(-)
> >=20
> > diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/=
netfilter/nf_conntrack_helper.h
> > index 5767dc2..a1f9955 100644
> > --- a/include/net/netfilter/nf_conntrack_helper.h
> > +++ b/include/net/netfilter/nf_conntrack_helper.h
> > @@ -63,6 +63,9 @@ static inline struct nf_conn_help *nfct_help(const st=
ruct nf_conn *ct)
> >  extern int nf_conntrack_helper_init(void);
> >  extern void nf_conntrack_helper_fini(void);
> > =20
> > +extern int nf_conntrack_helper_init_net(struct net *net);
> > +extern void nf_conntrack_helper_fini_net(struct net *net);
>=20
> I have modified this, so now nf_conntrack_helper_[init|fini] take
> struct net instead. Thus, we don't need these new functions.

Really fine, I did not want to change existing things in my version to
avoid to break something but the change you propose brind some
homogeneity with other Netfilter subsystem.

>=20
> > +
> >  extern int nf_conntrack_broadcast_help(struct sk_buff *skb,
> >  				       unsigned int protoff,
> >  				       struct nf_conn *ct,
> > diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrac=
k.h
> > index 7a911ec..7e21aec 100644
> > --- a/include/net/netns/conntrack.h
> > +++ b/include/net/netns/conntrack.h
> > @@ -26,11 +26,13 @@ struct netns_ct {
> >  	int			sysctl_tstamp;
> >  	int			sysctl_checksum;
> >  	unsigned int		sysctl_log_invalid; /* Log invalid packets */
> > +	int			sysctl_auto_assign_helper;
> >  #ifdef CONFIG_SYSCTL
> >  	struct ctl_table_header	*sysctl_header;
> >  	struct ctl_table_header	*acct_sysctl_header;
> >  	struct ctl_table_header	*tstamp_sysctl_header;
> >  	struct ctl_table_header	*event_sysctl_header;
> > +	struct ctl_table_header	*helper_sysctl_header;
> >  #endif
> >  	char			*slabname;
> >  };
> > diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_connt=
rack_core.c
> > index cbdb754..b30d845 100644
> > --- a/net/netfilter/nf_conntrack_core.c
> > +++ b/net/netfilter/nf_conntrack_core.c
> > @@ -1357,6 +1357,7 @@ static void nf_conntrack_cleanup_net(struct net *=
net)
> >  	nf_conntrack_tstamp_fini(net);
> >  	nf_conntrack_acct_fini(net);
> >  	nf_conntrack_expect_fini(net);
> > +	nf_conntrack_helper_fini_net(net);
> >  	kmem_cache_destroy(net->ct.nf_conntrack_cachep);
> >  	kfree(net->ct.slabname);
> >  	free_percpu(net->ct.stat);
> > @@ -1587,9 +1588,14 @@ static int nf_conntrack_init_net(struct net *net=
)
> >  	ret =3D nf_conntrack_timeout_init(net);
> >  	if (ret < 0)
> >  		goto err_timeout;
> > +	ret =3D nf_conntrack_helper_init_net(net);
> > +	if (ret < 0)
> > +		goto err_helper;
> > =20
> >  	return 0;
> > =20
> > +err_helper:
> > +	nf_conntrack_helper_fini_net(net);
> >  err_timeout:
> >  	nf_conntrack_timeout_fini(net);
> >  err_ecache:
> > diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_con=
ntrack_helper.c
> > index 436b7cb..d27252e 100644
> > --- a/net/netfilter/nf_conntrack_helper.c
> > +++ b/net/netfilter/nf_conntrack_helper.c
> > @@ -34,6 +34,67 @@ static struct hlist_head *nf_ct_helper_hash __read_m=
ostly;
> >  static unsigned int nf_ct_helper_hsize __read_mostly;
> >  static unsigned int nf_ct_helper_count __read_mostly;
> > =20
> > +static bool nf_ct_auto_assign_helper __read_mostly =3D 1;
> > +module_param_named(nf_conntrack_helper, nf_ct_auto_assign_helper, bool=
, 0644);
> > +MODULE_PARM_DESC(nf_conntrack_helper, "Assign helper to connection bas=
ed on port (default 1)");
>=20
> I have modified the description.

This one is fine for me.

>=20
> > +
> > +#ifdef CONFIG_SYSCTL
> > +static struct ctl_table helper_sysctl_table[] =3D {
> > +	{
> > +		.procname	=3D "nf_conntrack_auto_assign_helper",
>=20
> I have renamed this to "nf_conntrack_helper"

OK, it was a little long and now it is homogenous with module option.

>=20
> > +		.data		=3D &init_net.ct.sysctl_auto_assign_helper,
> > +		.maxlen		=3D sizeof(unsigned int),
> > +		.mode		=3D 0644,
> > +		.proc_handler	=3D proc_dointvec,
> > +	},
> > +	{}
> > +};
> > +
> > +static int nf_conntrack_helper_init_sysctl(struct net *net)
> > +{
> > +	struct ctl_table *table;
> > +
> > +	table =3D kmemdup(helper_sysctl_table, sizeof(helper_sysctl_table),
> > +			GFP_KERNEL);
> > +	if (!table)
> > +		goto out;
> > +
> > +	table[0].data =3D &net->ct.sysctl_auto_assign_helper;
> > +
> > +	net->ct.helper_sysctl_header =3D register_net_sysctl_table(net,
> > +			nf_net_netfilter_sysctl_path, table);
> > +	if (!net->ct.helper_sysctl_header) {
> > +		printk(KERN_ERR "nf_conntrack_helper: can't register to sysctl.\n");
> > +		goto out_register;
> > +	}
> > +	return 0;
> > +
> > +out_register:
> > +	kfree(table);
> > +out:
> > +	return -ENOMEM;
> > +}
> > +
> > +static void nf_conntrack_helper_fini_sysctl(struct net *net)
> > +{
> > +	struct ctl_table *table;
> > +
> > +	table =3D net->ct.helper_sysctl_header->ctl_table_arg;
> > +	unregister_net_sysctl_table(net->ct.helper_sysctl_header);
> > +	kfree(table);
> > +}
> > +#else
> > +static int nf_conntrack_helper_init_sysctl(struct net *net)
> > +{
> > +	return 0;
> > +}
> > +
> > +static void nf_conntrack_helper_fini_sysctl(struct net *net)
> > +{
> > +}
> > +#endif /* CONFIG_SYSCTL */
> > +
> > +
> > =20
>=20
> I removed these extra empty lines.

OK, and sorry for that.
>=20
> >  /* Stupid hash, but collision free for the default registrations of th=
e
> >   * helpers currently in the kernel. */
> > @@ -118,6 +179,7 @@ int __nf_ct_try_assign_helper(struct nf_conn *ct, s=
truct nf_conn *tmpl,
> >  {
> >  	struct nf_conntrack_helper *helper =3D NULL;
> >  	struct nf_conn_help *help;
> > +	struct net *net =3D nf_ct_net(ct);
> >  	int ret =3D 0;
> > =20
> >  	if (tmpl !=3D NULL) {
> > @@ -127,8 +189,10 @@ int __nf_ct_try_assign_helper(struct nf_conn *ct, =
struct nf_conn *tmpl,
> >  	}
> > =20
> >  	help =3D nfct_help(ct);
> > -	if (helper =3D=3D NULL)
> > +
> > +	if (net->ct.sysctl_auto_assign_helper && helper =3D=3D NULL)
> >  		helper =3D __nf_ct_helper_find(&ct->tuplehash[IP_CT_DIR_REPLY].tuple=
);
> > +
> >  	if (helper =3D=3D NULL) {
> >  		if (help)
> >  			RCU_INIT_POINTER(help->helper, NULL);
> > @@ -324,6 +388,10 @@ int nf_conntrack_helper_init(void)
> >  	if (!nf_ct_helper_hash)
> >  		return -ENOMEM;
> > =20
> > +	printk(KERN_INFO "nf_conntrack: automatic assignation of helper to"
> > +	       " connection will be disabled soon. Set nf_conntrack_helper"
> > +	       " option to 1 to keep old behavior.\n");
>=20
> We spot this message only once now. So we don't disturb all Linux
> kernel users with this message, only those using conntrack helpers.

OK.

> > +
> >  	err =3D nf_ct_extend_register(&helper_extend);
> >  	if (err < 0)
> >  		goto err1;
> > @@ -335,8 +403,20 @@ err1:
> >  	return err;
> >  }
> > =20
> > +int nf_conntrack_helper_init_net(struct net *net)
> > +{
> > +	net->ct.sysctl_auto_assign_helper =3D nf_ct_auto_assign_helper;
> > +
> > +	return nf_conntrack_helper_init_sysctl(net);
> > +}
> > +
> >  void nf_conntrack_helper_fini(void)
> >  {
> >  	nf_ct_extend_unregister(&helper_extend);
> >  	nf_ct_free_hashtable(nf_ct_helper_hash, nf_ct_helper_hsize);
> >  }
> > +
> > +void nf_conntrack_helper_fini_net(struct net *net)
> > +{
> > +	nf_conntrack_helper_fini_sysctl(net);
> > +}
> > --=20
> > 1.7.9.1
> >=20
>=20
> BTW, you may notice a glitch in my patch. There's two
> nf_conntrack_timeout_fini() invocation in the error path of
> nf_conntrack_init_net. That's already corrected in davem's tree but it
> didn't reached linux-next tree yet.

Good you mention it, I was going to do a remark ;)

Thanks a lot for the improvements!

BR,
--=20
Eric Leblond=20
Blog: http://home.regit.org/ - Portfolio: http://regit.500px.com/

--=-h88qCwnLpHw7qhZPbwPK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAk+G/XMACgkQnxA7CdMWjzLSugCdEredaMOL6Hog1Nzl0sI1pcu4
uEgAn1MrhWKPON/E97gaSV7XuF24Yicn
=TbHN
-----END PGP SIGNATURE-----

--=-h88qCwnLpHw7qhZPbwPK--

