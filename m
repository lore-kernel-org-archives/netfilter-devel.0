From: Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: Understanding execution context of netfilter hooks
Date: Fri, 17 Jul 2009 15:57:03 -0700
Message-ID: <20090717155703.0a70a8ae@nehalam>
References: <704c29930907170950l6e2f9881j83dbe338b9c03bdf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Stefan Hellkvist <hellkvist@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.vyatta.com ([76.74.103.46]:45646 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757972AbZGQW5K convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Jul 2009 18:57:10 -0400
In-Reply-To: <704c29930907170950l6e2f9881j83dbe338b9c03bdf@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 17 Jul 2009 18:50:52 +0200
Stefan Hellkvist <hellkvist@gmail.com> wrote:

> Hi,
>=20
> Could anyone help me understand the execution context under which
> netfilter hooks are being executed? I played around with some code in
> order to learn things and noticed that the code executed differently
> in a netfilter hook than in, for instance, the init method of a modul=
e
> and I fail to understand why that is (possibly due to lack of
> understanding of the kernel in general).
>=20
> I can give a very simplified example. Take the following rediculous
> code which reads a few bytes from a file in the file system (yes, a
> very unlikely example I know, but the question about writing or
> reading files from kernel space is not in my interest right now):
>=20
> static void
> readshadow() {
> =C2=A0 struct file *fp;
> =C2=A0 char buf[1024];
>=20
> =C2=A0 fp =3D filp_open("/etc/shadow", O_RDONLY, 0);
> =C2=A0 if (fp !=3D NULL) {
> =C2=A0=C2=A0=C2=A0 int retval =3D kernel_read(fp, 0, buf, 20);
> =C2=A0=C2=A0=C2=A0 if (retval !=3D 20) {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 printk("disaster!\n");
> =C2=A0=C2=A0=C2=A0 }
> =C2=A0=C2=A0=C2=A0 buf[20] =3D '\0';
> =C2=A0=C2=A0=C2=A0 printk("first 20 chars: \"%s\"\n", buf);
> =C2=A0=C2=A0=C2=A0 filp_close(fp, 0);
> =C2=A0 }
> }


One of the repeating mantra's of kernel development is:
 "Don't do file i/o in kernel code."

Your code is wrong not just because kernel i/o can sleep,
but also because there really is not just one namespace,
so what is /etc/shadow!

The right way to do something like this is to read/parse
the file in a utility and pass the necessary data into the
kernel module through other mechanisms (/proc,netlink, debugfs, ...)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
