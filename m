From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: [PATCH 0/2] [RFC] Extended accounting infrastructure for iptables
Date: Wed, 14 Dec 2011 21:12:52 +0800
Message-ID: <CABa6K_Ffexe2SsaxyRPLBEjf1WOfSEgzJ4fa5L81QZs6JvXsVA@mail.gmail.com>
References: <1323860443-7129-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, kadlec@blackhole.kfki.hu,
	kaber@trash.net, jengelh@medozas.de, thomas.jarosch@intra2net.com
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:37241 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419Ab1LNNNO convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Dec 2011 08:13:14 -0500
Received: by vcbfk14 with SMTP id fk14so576855vcb.19
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Dec 2011 05:13:13 -0800 (PST)
In-Reply-To: <1323860443-7129-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Dec 14, 2011 at 7:00 PM,  <pablo@netfilter.org> wrote:
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

Why not use the counters of iptables instead?

iptables-save -c

--=20
Regards,
Changli Gao(xiaosuo@gmail.com)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
