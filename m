From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: searching tuples in conntrack
Date: Sun, 7 Oct 2012 13:44:32 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1210071338390.16946@nerf07.vanv.qr>
References: <CA+Z0r8MVyzWP_uM+Ryge5YY8Dr9XO+Uh1x0g7Zc8FBp16mMAGQ@mail.gmail.com> <alpine.LNX.2.01.1209262231180.30346@nerf07.vanv.qr> <CA+Z0r8P6zFL0jE3soO+OubGg0buzRE7ZiHAMxXZPMNrJH6tiig@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: =?UTF-8?Q?Miguel_Alejandro_Gonz=C3=A1lez?= <maggonzz@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:42932 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779Ab2JGLoj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 7 Oct 2012 07:44:39 -0400
In-Reply-To: <CA+Z0r8P6zFL0jE3soO+OubGg0buzRE7ZiHAMxXZPMNrJH6tiig@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2012-10-07 07:51, Miguel Alejandro Gonz=C3=A1lez wrote:
>
>I'm having some problems creating a function like count_them and the h=
ash
>table it uses. My module is a target extension and connlimit is a matc=
h
>extension.

And why would that be a problem?

>So correct me if I'm wrong... basically connlimit creates the hash tab=
le
>with struct xt_connlimit_info *info =3D par->matchinfo as a parameter,=
 but I
>don't have such info because i'm making a target extension...

par->targinfo is the block of parameters received from userspace
for targets.

>How can I initialize the hash table like in connlimit_mt_check() if I =
don't
>work with const struct xt_mtchk_param *par?

    =E2=86=92   info->data =3D kmalloc(sizeof(myprivatestuff), GFP_KERN=
EL);    =20

Note how this does not have much to do with matchinfo.
It's simply an assignment.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
