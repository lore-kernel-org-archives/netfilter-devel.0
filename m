From: Patrick McHardy <kaber@trash.net>
Subject: Re: [Patch 1/2] libnfnetlink, iface conversion to string
Date: Fri, 19 Jan 2007 16:22:50 +0100
Message-ID: <45B0E24A.7040906@trash.net>
References: <1167257854.31765.21.camel@localhost>	<45940145.3020003@netfilter.org>
	<1167349247.15420.13.camel@localhost>	<20070107142607.GC13543@prithivi.gnumonks.org>	<1168296086.12298.6.camel@localhost>	<20070109115120.GX7655@prithivi.gnumonks.org>	<1169162676.8926.14.camel@localhost>
	<1169163050.8926.16.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Vincent Deffontaines <vincent@inl.fr>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eric Leblond <eric@inl.fr>
In-Reply-To: <1169163050.8926.16.camel@localhost>
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

Eric Leblond wrote:
> Index: src/rtnl.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- src/rtnl.c	(r=C3=A9vision 6736)
> +++ src/rtnl.c	(copie de travail)
> @@ -116,7 +116,7 @@
>          struct sockaddr_nl nladdr;
> =20
>          memset(&nladdr, 0, sizeof(nladdr));
> -	memset(&req, 0, sizeof(req));
> +        memset(&req, 0, sizeof(req));

Reindenting, but fine ..

>          nladdr.nl_family =3D AF_NETLINK;
> =20
>          req.nlh.nlmsg_len =3D sizeof(req);
> @@ -127,11 +127,11 @@
>          req.g.rtgen_family =3D AF_INET;
> =20
>          return sendto(rtnl_fd, (void*)&req, sizeof(req), 0,=20
> -		      (struct sockaddr*)&nladdr, sizeof(nladdr));
> +                (struct sockaddr*)&nladdr, sizeof(nladdr));

This one isn't.

>  }
> =20
>  /* rtnl_receive - receive netlink packets from rtnetlink socket */
> -int rtnl_receive()
> +int rtnl_receive(int rtnl_fd)

header file needs to be fixed as well. Is the global rtnl_fd still
needed?

>  {
>  	int status;
>  	char buf[8192];
> Index: src/iftable.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- src/iftable.c	(r=C3=A9vision 6736)
> +++ src/iftable.c	(copie de travail)
> @@ -2,7 +2,7 @@
>   *
>   * (C) 2004 by Astaro AG, written by Harald Welte <hwelte@astaro.com>
>   *
> - * This software is Free Software and licensed under GNU GPLv2.=20
> + * This software is Free Software and licensed under GNU GPLv2.

Please do cleanup in seperate patches.

>   *
>   */
> =20
> @@ -23,8 +23,8 @@
> =20
>  #define iftb_log(x, ...)
> =20
> -struct ifindex_map {
> -	struct ifindex_map *next;
> +struct ifindex_map_t {
> +	struct ifindex_map_t *next;

No useless renaming without a reason please.

> =20
>  	u_int32_t	index;
>  	u_int32_t	type;
> @@ -34,7 +34,7 @@
>  	char		name[16];
>  };
> =20
> -static struct ifindex_map *ifindex_map[16];
> +static struct ifindex_map_t *ifindex_map[16];
> =20
>  /* iftable_dump - Dump the interface table to a given file stream
>   * @outfd:	file stream to which table should be dumped
> @@ -44,7 +44,7 @@
>  	int i;
> =20
>  	for (i =3D 0; i < 16; i++) {
> -		struct ifindex_map *im;
> +		struct ifindex_map_t *im;
>  		for (im =3D ifindex_map[i]; im; im =3D im->next) {
>  			fprintf(outfd, "%u %s", im->index, im->name);
>  			if (!(im->flags & IFF_UP))
> @@ -67,7 +67,7 @@
>  {
>  	unsigned int hash;
>  	struct ifinfomsg *ifi_msg =3D NLMSG_DATA(n);
> -	struct ifindex_map *im, **imp;
> +	struct ifindex_map_t *im, **imp;
>  	struct rtattr *cb[IFLA_MAX+1];
> =20
>  	if (n->nlmsg_type !=3D RTM_NEWLINK)
> @@ -108,7 +108,7 @@
>  		iftb_log(LOG_DEBUG, "creating new iftable (ifindex=3D%u)",
>  			 im->index);
>  	}
> -=09
> +
>  	im->type =3D ifi_msg->ifi_type;
>  	im->flags =3D ifi_msg->ifi_flags;
>  	if (cb[IFLA_ADDRESS]) {
> @@ -129,14 +129,13 @@
>   * @n:		netlink message header of a RTM_DELLINK nlmsg
>   * @arg:	not used
>   *
> - * Delete an entry from the interface table. =20
> + * Delete an entry from the interface table.
>   * Returns -1 on error, 0 if no matching entry was found or 1 on succe=
ss.
>   */
>  int iftable_del(struct nlmsghdr *n, void *arg)
>  {
>  	struct ifinfomsg *ifi_msg =3D NLMSG_DATA(n);
>  	struct rtattr *cb[IFLA_MAX+1];
> -	struct ifindex_map *im;
> =20
>  	if (n->nlmsg_type !=3D RTM_DELLINK) {
>  		iftb_log(LOG_ERROR,
> @@ -157,15 +156,15 @@
> =20
>  	return 1;
>  }
> -=09
> -/* ifindex_2name - get the name for an ifindex
> +
> +/* nl_ifindex_2name - get the name for an ifindex
>   * @index:	ifindex to be resolved
>   *
>   * Return value: character string containing name of interface
>   */
> -char *ifindex_2name(unsigned int index)
> +char *nlif_index_2name(unsigned int index)
>  {
> -	struct ifindex_map *im;
> +	struct ifindex_map_t *im;
> =20
>  	if (index =3D=3D 0)
>  		return "*";
> @@ -183,7 +182,7 @@
>   */
>  int  iftable_up(unsigned int index)
>  {
> -	struct ifindex_map *im;
> +	struct ifindex_map_t *im;
> =20
>  	for (im =3D ifindex_map[index&0xF]; im; im =3D im->next) {
>  		if (im->index =3D=3D index) {
> @@ -208,6 +207,14 @@
>  	if (fini)
>  		goto cleanup;
> =20
> +	memset(ifindex_map,0,sizeof(ifindex_map));

whitespace after comma.

> +
> +	ret =3D rtnl_init();
> +
> +	if (ret =3D=3D -1) {
> +		goto cleanup_none;
> +	}

Please no parens around single expressions.

> +
>  	if (rtnl_handler_register(&handlers[0]) < 0) {
>  		ret =3D -1;
>  		goto cleanup_none;
> @@ -223,7 +230,7 @@
>  		goto cleanup_1;
>  	}
> =20
> -	return 0;
> +	return ret;
> =20
>  #if 0
>  	if (rtnl_wilddump_requet(rtnl_fd, AF_UNSPEC, RTM_GETLINK) < 0) {
> @@ -243,19 +250,30 @@
>  	return ret;
>  }
> =20
> -/* iftable_init - Initialize interface table
> +/** nl_iftable_init - Initialize interface table
> + *
> + * Initialize rtnl interface and interface table
> + *
> + * \return file descriptor to netlink socket
>   */
> -int iftable_init(void)
> +int nlif_table_init(void)
>  {
>  	iftb_log(LOG_DEBUG, "%s", __FUNCTION__);
>  	return init_or_fini(0);
>  }
> =20
> -/* iftable_fini - Destructor of interface table
> +/* nl_iftable_fini - Destructor of interface table
>   */
> -void iftable_fini(void)
> +void nlif_table_fini(void)
>  {
>  	init_or_fini(1);
>  }
> =20
> +/**
> + * \return 0 if OK
> + */
> +int nlif_treat_msg(int fd)
> +{
> +	return rtnl_receive(fd);
> +}
> =20
> Index: src/Makefile.am
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- src/Makefile.am	(r=C3=A9vision 6736)
> +++ src/Makefile.am	(copie de travail)
> @@ -8,4 +8,4 @@
> =20
>  libnfnetlink_la_LDFLAGS =3D -Wc,-nostartfiles	\
>  			  -version-info $(LIBVERSION)
> -libnfnetlink_la_SOURCES =3D libnfnetlink.c=20
> +libnfnetlink_la_SOURCES =3D libnfnetlink.c iftable.c rtnl.c
