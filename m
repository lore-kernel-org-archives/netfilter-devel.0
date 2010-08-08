From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: newbie: writing custom target, need help with getting it to
 work
Date: Sun, 8 Aug 2010 22:28:42 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1008082225540.14264@obet.zrqbmnf.qr>
References: <00fe01cb3737$19358d20$4ba0a760$@com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Yossi Weihs <yw@seafire.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:59545 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754269Ab0HHU2o (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 8 Aug 2010 16:28:44 -0400
In-Reply-To: <00fe01cb3737$19358d20$4ba0a760$@com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sunday 2010-08-08 22:20, Yossi Weihs wrote:

>Hi List,
>
>I have been working on a custom netfilter target to help with some in-=
house
>testing. I?m running Fedora 13 and building within xtables-addons v 1.=
2.6 ;
>I have gotten both the kernel module and library to build correctly wi=
thin
>the xtables-addons build enviroment, and am inserting the kernel modul=
e with
>no errors. When trying to create a rule with my target, I get the cryp=
tic
>error:
>
>iptables --verbose --table filter --insert INPUT --protocol TCP -m sta=
te
>--state ESTABLISHED --jump TAP --device TAPPY
>TAP=C2=A0 tcp opt -- in * out *=C2=A0 0.0.0.0/0=C2=A0 -> 0.0.0.0/0=C2=A0=
 state ESTABLISHED TAP
>dev:TAPPY=20
>iptables: No chain/target/match by that name.

When you want iptables to recognize (the user portion) of Xt-a's extra=20
modules, you need to point to it via the XTABLES_LIBDIR environment=20
variable.

XTABLES_LIBDIR=3D$HOME/xta/extensions:/usr/lib(64)/xtables iptables -S

Don't forget usr/lib/xtables otherwise it won't find the tcp match and=20
all the ones that already ship with iptables.

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
