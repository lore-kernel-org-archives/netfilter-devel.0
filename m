From: Stefan Hellkvist <hellkvist@gmail.com>
Subject: Understanding execution context of netfilter hooks
Date: Fri, 17 Jul 2009 18:50:52 +0200
Message-ID: <704c29930907170950l6e2f9881j83dbe338b9c03bdf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f228.google.com ([209.85.218.228]:33415 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934746AbZGQQuy convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Jul 2009 12:50:54 -0400
Received: by bwz28 with SMTP id 28so850162bwz.37
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Jul 2009 09:50:53 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Could anyone help me understand the execution context under which
netfilter hooks are being executed? I played around with some code in
order to learn things and noticed that the code executed differently
in a netfilter hook than in, for instance, the init method of a module
and I fail to understand why that is (possibly due to lack of
understanding of the kernel in general).

I can give a very simplified example. Take the following rediculous
code which reads a few bytes from a file in the file system (yes, a
very unlikely example I know, but the question about writing or
reading files from kernel space is not in my interest right now):

static void
readshadow() {
=A0 struct file *fp;
=A0 char buf[1024];

=A0 fp =3D filp_open("/etc/shadow", O_RDONLY, 0);
=A0 if (fp !=3D NULL) {
=A0=A0=A0 int retval =3D kernel_read(fp, 0, buf, 20);
=A0=A0=A0 if (retval !=3D 20) {
=A0=A0=A0=A0=A0 printk("disaster!\n");
=A0=A0=A0 }
=A0=A0=A0 buf[20] =3D '\0';
=A0=A0=A0 printk("first 20 chars: \"%s\"\n", buf);
=A0=A0=A0 filp_close(fp, 0);
=A0 }
}


The code opens a file, reads a few bytes from it and then closes the
file after having logged the bytes with printk.

If this method is run within for instance the init method of the
module it performs as expected (it reads the file and shows the right
bytes in the log). If it however is called from within a netfilter
hook (registered for instance on NF_INET_LOCAL_OUT), such as this:

static unsigned int
hook(unsigned int hooknum,
     struct sk_buff *skb,
     const struct net_device *in,
     const struct net_device *out,
     int (*okfn) (struct sk_buff *)) {

  readshadow();
  return NF_ACCEPT;
}


Then it will fail with an "Oops: 0000 [#2]" "BUG: unable to handle
kernel NULL pointer dereference at 0000000f" when you trigger it with
some network traffic. The last call in the stack-trace of the OOPS
shows vfs_read (called by kernel_read) being the culprit (possibly
because it's being executed in the wrong context).

So, the question, as mentioned in the beginning. What context is the
hook executing in which causes the code to behave differently from
when it executed in the module init method for instance?

Kindest regards,
Stefan
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
