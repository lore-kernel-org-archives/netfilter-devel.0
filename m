From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: iptables: iptc_init segfault
Date: Sun, 15 Nov 2009 11:04:00 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0911151103220.21283@obet.zrqbmnf.qr>
References: <328fe7150911142309r7f3f3dd1mcaeb400a65947666@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: basteon <basteon@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:37941 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752535AbZKOKD7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 15 Nov 2009 05:03:59 -0500
In-Reply-To: <328fe7150911142309r7f3f3dd1mcaeb400a65947666@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sunday 2009-11-15 08:09, basteon wrote:

>g'time of day to every1,
>I tried todo iptables initailazation in my application, but
>untortunately received seghault, why it's happening?

Because your code is faulty. Had you compiled with -Wall you would have=
=20
gotten

z.c:9: warning: =E2=80=98handle=E2=80=99 is used uninitialized in this =
function

>Which's way I can realy initialize libiptq and xtables in my program?
>int main(int argc, char *argv[]){
>char **table;
>table =3D &argv[2];
>struct iptc_handle **handle;
>printf("A %s\n",*table);
>*handle =3D iptc_init(*table);
>printf("B\n");
>}
>--
>To unsubscribe from this list: send the line "unsubscribe netfilter-de=
vel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
