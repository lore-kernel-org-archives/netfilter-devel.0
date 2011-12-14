From: Pete Holland <pholland27@gmail.com>
Subject: Re: [PATCH 0/2] [RFC] Extended accounting infrastructure for iptables
Date: Wed, 14 Dec 2011 11:29:42 -0800
Message-ID: <CANtneHJWwcyYhq0U4p6_nc9nDRfpv0_mwGZm_DKr1pHd+urU4w@mail.gmail.com>
References: <1323860443-7129-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, kadlec@blackhole.kfki.hu,
	kaber@trash.net, jengelh@medozas.de, thomas.jarosch@intra2net.com
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54486 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757872Ab1LNT3o convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Dec 2011 14:29:44 -0500
Received: by eaaj10 with SMTP id j10so1137208eaa.19
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Dec 2011 11:29:42 -0800 (PST)
In-Reply-To: <1323860443-7129-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a great idea, thank you!  This is a problem I'm trying to
solve right now and have found that using the rule counters is clunky
and restrictive.  Specifically, this provides the kind of
functionality that's needed to support changing the rule definitions
without losing the accounting information.

Quick question, would this be limited to the filter table, or would we
be able to use the target (or match as I saw suggested) in other
tables?
This would be most useful if it were available in the mangle (so we
could mark+account in one spot... and if it were a match, in one rule)
and nat tables (so we can account for traffic pre and post NAT
treatment).

- Pete

On Wed, Dec 14, 2011 at 3:00 AM,  <pablo@netfilter.org> wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
>
> Hi!
>
> We currently have two ways to account traffic in netfilter:
>
> - iptables chain and rule counters:
>
> =A0# iptables -L -n -v
> Chain INPUT (policy DROP 3 packets, 867 bytes)
> =A0pkts bytes target =A0 =A0 prot opt in =A0 =A0 out =A0 =A0 source =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 destinat
> =A0 =A08 =A01104 ACCEPT =A0 =A0 all =A0-- =A0lo =A0 =A0 * =A0 =A0 =A0=
 0.0.0.0/0 =A0 =A0 =A0 =A0 =A0 =A00.0.0.0/
>
> - use flow-based accounting provided by ctnetlink:
>
> =A0# conntrack -L
> tcp =A0 =A0 =A06 431999 ESTABLISHED src=3D192.168.1.130 dst=3D212.106=
=2E219.168 sport=3D58
>
> While trying to display real-time accounting statistics, we require
> to pool the kernel periodically to obtain this information. This is
> OK if the number of flows is relatively low. However, in case that
> the number of flows is huge, we can spend a considerable amount of
> cycles to iterate over the list of flows that have been obtained.
>
> Moreover, if we want to obtain the sum of the flow accounting results
> that match some criteria, we have to iterate over the whole list of
> existing flows, look for matchings and update the counters.
>
> This patchset adds the extended accounting infrastructure in
> kernel-space. It is composed of one nfnetlink interface that
> allows you to create, to update and to retrieve accounting objects.
> These objects can be used to account traffic with the flexibility
> that iptables rules provide (by means of the new NFACCT target).
>
> Quick example of use:
>
> 1) You create the accounting object:
>
> libnetfilter_acct/examples# ./nfacct-add http-traffic
>
> 2) Add the iptables rules for traffic you want to account:
>
> # iptables -I INPUT -p tcp --sport 80 -j NFACCT --nfacct-name http-tr=
affic
> # iptables -I OUTPUT -p tcp --dport 80 -j NFACCT --nfacct-name http-t=
raffic
>
> 3) Retrieve the counters.
>
> libnetfilter_acct/examples# ./nfacct-get
> http-traffic =3D { pkts =3D 000000000125, =A0 bytes =3D 000000023162 =
};
>
> You can also atomically retrieve and zero counters in case that you
> want to collect information periodically.
>
> This comes with the user-space libnetfilter_acct library:
>
> http://1984.lsi.us.es/git/libnetfilter_acct/
>
> [Note: The current library API is still quite preliminary. I plan
> to heavily rework it]
>
> And the NFACCT extension for user-space iptables is here:
>
> http://1984.lsi.us.es/git/iptables/commit/?id=3D850104ff9d619a7e0bc56=
1aa16fee838fcd1937c
>
> Comments welcome!
>
> Pablo Neira Ayuso (2):
> =A0netfilter: add extended accounting infrastructure over nfnetlink
> =A0netfilter: xtables: add NFACCT target to support extended accounti=
ng
>
> =A0include/linux/netfilter/Kbuild =A0 =A0 =A0 =A0 =A0 | =A0 =A02 +
> =A0include/linux/netfilter/nfnetlink.h =A0 =A0 =A0| =A0 =A03 +-
> =A0include/linux/netfilter/nfnetlink_acct.h | =A0 34 +++
> =A0include/linux/netfilter/xt_NFACCT.h =A0 =A0 =A0| =A0 17 ++
> =A0net/netfilter/Kconfig =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0=
 18 ++
> =A0net/netfilter/Makefile =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0 =A0=
2 +
> =A0net/netfilter/nfnetlink_acct.c =A0 =A0 =A0 =A0 =A0 | =A0352 ++++++=
++++++++++++++++++++++++
> =A0net/netfilter/xt_NFACCT.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 78 =
+++++++
> =A08 files changed, 505 insertions(+), 1 deletions(-)
> =A0create mode 100644 include/linux/netfilter/nfnetlink_acct.h
> =A0create mode 100644 include/linux/netfilter/xt_NFACCT.h
> =A0create mode 100644 net/netfilter/nfnetlink_acct.c
> =A0create mode 100644 net/netfilter/xt_NFACCT.c
>
> --
> 1.7.2.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-d=
evel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
