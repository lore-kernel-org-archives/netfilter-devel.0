From: Alexander Petrenas <zeracles@zeracles.net.ru>
Subject: Kernel 4.1.0 broke the TARPIT & DELUGE targets in
 xtables-addons-2.6
Date: Tue, 23 Jun 2015 00:40:47 +0300
Message-ID: <52756b9a-0699-405b-918c-73bcfafe97bb@zeracles.net.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from zeracles.net.ru ([178.252.70.14]:50670 "EHLO zeracles.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107AbbFVWAd convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Jun 2015 18:00:33 -0400
Received: from localhost ([127.0.0.1])
	by zeracles.net.ru
	for netfilter-devel@vger.kernel.org;
	Tue, 23 Jun 2015 00:41:04 +0300
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi!

Netfilter changes in the recent 4.1.0 kernel update included removal of=
 the BRNF_BRIDGED flag:
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?=
id=3D40451fd013878b005ccae767dfebc07dfecf85d9

Unfortunately, getting rid of BRNF_BRIDGED flag broke the xtables-addon=
s-2.6 package, which now fails to build TARPIT & DELUGE targets with th=
e following errors:

xtables-addons-2.6/extensions/xt_TARPIT.c:253:30: error: =E2=80=98BRNF_=
BRIDGED=E2=80=99 undeclared (first use in this function)
      nskb->nf_bridge->mask & BRNF_BRIDGED))
                              ^

xtables-addons-2.6/extensions/xt_TARPIT.c:282:2: error: too few argumen=
ts to function =E2=80=98NF_HOOK=E2=80=99
  NF_HOOK(NFPROTO_IPV4, NF_INET_LOCAL_OUT, nskb, NULL,
  ^

xtables-addons-2.6/extensions/xt_TARPIT.c:397:2: error: too few argumen=
ts to function =E2=80=98NF_HOOK=E2=80=99
  NF_HOOK(NFPROTO_IPV6, NF_INET_LOCAL_OUT, nskb, NULL,
  ^

scripts/Makefile.build:264: recipe for target 'xtables-addons-2.6/work/=
xtables-addons-2.6/extensions/xt_TARPIT.o' failed

My kernel hacking skills are non-existant (as well as my C skills), so =
I expectedly failed to come up with any patch that would replace BRNF_B=
RIDGED flag with nf_bridge->physoutdev in the following xt_TARPIT.c cod=
e:

#ifdef CONFIG_BRIDGE_NETFILTER
	if (hook !=3D NF_INET_FORWARD || (nskb->nf_bridge !=3D NULL &&
	    nskb->nf_bridge->mask & BRNF_BRIDGED))
#else

http://sourceforge.net/p/xtables-addons/xtables-addons/ci/master/tree/e=
xtensions/xt_TARPIT.c#l253

Can someone please show me how it can be fixed? (and hopefully update x=
tables package with the fix?)

Yours, Alexander Petrenas.

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
