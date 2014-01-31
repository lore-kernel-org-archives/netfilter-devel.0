From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH]: libnetfilter_log: Uninitialized values in
 libnetfilter_log.c
Date: Fri, 31 Jan 2014 12:12:28 +0100
Message-ID: <20140131111228.GA6863@localhost>
References: <CA+J3vc+YmPjtr2sJqR39cQSLOO+xmVK=RLChSRgv_+LN2tuRsQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Ivan Homoliak <xhomol11@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49597 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932170AbaAaLMv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 31 Jan 2014 06:12:51 -0500
Content-Disposition: inline
In-Reply-To: <CA+J3vc+YmPjtr2sJqR39cQSLOO+xmVK=RLChSRgv_+LN2tuRsQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 31, 2014 at 11:39:09AM +0100, Ivan Homoliak wrote:
> Unitialized values in libnetfilter.log.c which were discovered by
> valgrind and ulogd.
>=20
> Signed-off-by: Ivan Homoliak <xhomol11@gmail.com>
> ---
>=20
> Valgrinds output:
>=20
> =3D=3D13821=3D=3D Syscall param socketcall.sendto(msg) points to unin=
itialised byte(s)
> =3D=3D13821=3D=3D    at 0x3E93AF6E83: __sendto_nocancel (in /usr/lib6=
4/libc-2.17.so)
> =3D=3D13821=3D=3D    by 0x5433E81: nfnl_send (libnfnetlink.c:391)
> =3D=3D13821=3D=3D    by 0x5435C0E: nfnl_query (libnfnetlink.c:1569)
> =3D=3D13821=3D=3D    by 0x522E4E6: __build_send_cfg_msg (libnetfilter=
_log.c:143)
> =3D=3D13821=3D=3D    by 0x522E87E: nflog_bind_group (libnetfilter_log=
=2Ec:413)
> =3D=3D13821=3D=3D    by 0x5029F3B: start (ulogd_inppkt_NFLOG.c:573)
> =3D=3D13821=3D=3D    by 0x403E5D: create_stack_start_instances (ulogd=
=2Ec:918)
> =3D=3D13821=3D=3D    by 0x4041B4: create_stack (ulogd.c:1010)
> =3D=3D13821=3D=3D    by 0x4078D6: config_parse_file (conffile.c:225)
> =3D=3D13821=3D=3D    by 0x404411: parse_conffile (ulogd.c:1088)
> =3D=3D13821=3D=3D    by 0x405478: main (ulogd.c:1573)
> =3D=3D13821=3D=3D  Address 0x7feffff69 is on thread 1's stack
> =3D=3D13821=3D=3D  Uninitialised value was created by a stack allocat=
ion
> =3D=3D13821=3D=3D    at 0x522E45B: __build_send_cfg_msg (libnetfilter=
_log.c:129)
> =3D=3D13821=3D=3D
> =3D=3D13821=3D=3D Syscall param socketcall.sendto(msg) points to unin=
itialised byte(s)
> =3D=3D13821=3D=3D    at 0x3E93AF6E83: __sendto_nocancel (in /usr/lib6=
4/libc-2.17.so)
> =3D=3D13821=3D=3D    by 0x5433E81: nfnl_send (libnfnetlink.c:391)
> =3D=3D13821=3D=3D    by 0x5435C0E: nfnl_query (libnfnetlink.c:1569)
> =3D=3D13821=3D=3D    by 0x522E9A0: nflog_set_mode (libnetfilter_log.c=
:481)
> =3D=3D13821=3D=3D    by 0x5029FA2: start (ulogd_inppkt_NFLOG.c:581)
> =3D=3D13821=3D=3D    by 0x403E5D: create_stack_start_instances (ulogd=
=2Ec:918)
> =3D=3D13821=3D=3D    by 0x4041B4: create_stack (ulogd.c:1010)
> =3D=3D13821=3D=3D    by 0x4078D6: config_parse_file (conffile.c:225)
> =3D=3D13821=3D=3D    by 0x404411: parse_conffile (ulogd.c:1088)
> =3D=3D13821=3D=3D    by 0x405478: main (ulogd.c:1573)
> =3D=3D13821=3D=3D  Address 0x7feffff9d is on thread 1's stack
> =3D=3D13821=3D=3D  Uninitialised value was created by a stack allocat=
ion
> =3D=3D13821=3D=3D    at 0x50293D0: ??? (in /usr/lib/ulogd/ulogd_inppk=
t_NFLOG.so)
>=20
>=20
> Version: libnetfilter_log-1.0.1
> File: libnetfilter_log.c
> GCC: 4.8.2 20131212 (Red Hat 4.8.2-7)
> OS: Fedora release 19 (Schr=F6dinger's Cat)
> Kernel: 3.12.5-200.fc19.x86_64

> --- ./src/libnetfilter_log.c	2010-11-04 00:19:45.000000000 +0100
> +++ ../../libnetfilter_log-1.0.1/src/libnetfilter_log.c	2014-01-03 10=
:48:34.592783388 +0100
> @@ -133,6 +133,8 @@ __build_send_cfg_msg(struct nflog_handle
>  		struct nlmsghdr nmh;
>  	} u;
>  	struct nfulnl_msg_config_cmd cmd;
> +       =20
> +        memset(&u, 0, sizeof(u)); //ihomoliak	       =20

Could you remove the comment on the right side?

While at it, please, don't convert tabs to spaces.

Thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
