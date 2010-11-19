From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: xtables - how to use kernel headers not located in /usr/include/
 ?
Date: Fri, 19 Nov 2010 11:05:55 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1011191105250.29615@obet.zrqbmnf.qr>
References: <AANLkTimyOo-GMg0CYnnBs4QDeneq5XGV4YO8kVNLL116@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Jan Andrejkovic <jandrejk@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:41105 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752492Ab0KSKF4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Nov 2010 05:05:56 -0500
In-Reply-To: <AANLkTimyOo-GMg0CYnnBs4QDeneq5XGV4YO8kVNLL116@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2010-11-19 04:30, Jan Andrejkovic wrote:

>Hi guys,
>
>I'm trying to cross-compile xtables 1.4.7 for my arm device, I get
>compilation error:
>/usr/include/netinet/ip.h:47: error: redefinition of =E2=80=98struct i=
phdr=E2=80=99
>
>I think the error is related with the fact that kernel source I need
>to compile with is located elsewhere and not in /usr/include

iptables no longer needs the kernel source to compile.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
