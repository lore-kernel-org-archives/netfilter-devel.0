From: Justin Yaple <yaplej@gmail.com>
Subject: Re: Anyway to add data to connection tracking?
Date: Mon, 19 Apr 2010 16:07:35 -0700
Message-ID: <h2p8363055a1004191607h6570a249udb26d2f56e1a8abb@mail.gmail.com>
References: <i2y8363055a1004191240jeb1bb313r3f414cdc89b0468e@mail.gmail.com>
	 <u2q38bcb3ec1004191435i95b3ebeld75eff9c47f71d70@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: James King <t.james.king@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gx0-f217.google.com ([209.85.217.217]:37276 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921Ab0DSXHg convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Apr 2010 19:07:36 -0400
Received: by gxk9 with SMTP id 9so3381683gxk.8
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Apr 2010 16:07:35 -0700 (PDT)
In-Reply-To: <u2q38bcb3ec1004191435i95b3ebeld75eff9c47f71d70@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> Accounting, NAT, and the conntrack helpers use ct_extend to store
> private per-conntrack data. =A0For an out of tree module, you'll need=
 to
> maintain a small kernel patch to add an enumeration to
> nf_conntrack_extend.h, and add a function call to init_conntrack() an=
d
> ctnetlink_create_conntrack() to add the private area when the
> conntrack is initialized, as it needs to be allocated before the
> conntrack is confirmed. =A0If your private structure contains any
> pointers, you'll also have specify a destroy callback in your module'=
s
> nf_ct_ext_type structure to make sure memory gets cleaned up properly=
=2E
> =A0nf_conntrack_acct is probably a good module to look at for usage.
>
> HTH,
> James

My pre-alpha application was entirely written as a kernel module, but
I am in the process of writing it as a user space service that uses
libnetfilter_queue to intercept packets, and bring them into user
space to be processed.  This is where I need to keep track of the TCP
options in each of the IP packets and track them for each session.
One of my goals is that this will run on pretty much any distro
without needing to recompile the kernel.  Being I don't know much
about netfilter I just was not sure if it were possible to use the
existing conntrack table from user space.

Justin.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
