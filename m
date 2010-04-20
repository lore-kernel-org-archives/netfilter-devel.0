From: James King <t.james.king@gmail.com>
Subject: Re: Anyway to add data to connection tracking?
Date: Mon, 19 Apr 2010 19:20:43 -0700
Message-ID: <i2z38bcb3ec1004191920vb17dab2bme72e0fd61c17666d@mail.gmail.com>
References: <i2y8363055a1004191240jeb1bb313r3f414cdc89b0468e@mail.gmail.com>
	 <u2q38bcb3ec1004191435i95b3ebeld75eff9c47f71d70@mail.gmail.com>
	 <h2p8363055a1004191607h6570a249udb26d2f56e1a8abb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Justin Yaple <yaplej@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46390 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034Ab0DTCUo convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Apr 2010 22:20:44 -0400
Received: by vws5 with SMTP id 5so2610802vws.19
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Apr 2010 19:20:43 -0700 (PDT)
In-Reply-To: <h2p8363055a1004191607h6570a249udb26d2f56e1a8abb@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Apr 19, 2010 at 4:07 PM, Justin Yaple <yaplej@gmail.com> wrote:

> My pre-alpha application was entirely written as a kernel module, but
> I am in the process of writing it as a user space service that uses
> libnetfilter_queue to intercept packets, and bring them into user
> space to be processed. =A0This is where I need to keep track of the T=
CP
> options in each of the IP packets and track them for each session.
> One of my goals is that this will run on pretty much any distro
> without needing to recompile the kernel. =A0Being I don't know much
> about netfilter I just was not sure if it were possible to use the
> existing conntrack table from user space.

I'm not sure if you can access/modify the conntrack directly from
userspace, but I know you can listen for conntrack events and maintain
your own table passively.  The userspace version of l7-filter combines
queuing+events in this way, constructing a unique string based on the
flow tuple and using it for the key to a map that holds a custom
per-conntrack structure.  l7-conntrack.* and l7-queue.* are the
interesting bits here, but are missing a bit of locking around the
threaded map access currently.

Cheers,
James
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
