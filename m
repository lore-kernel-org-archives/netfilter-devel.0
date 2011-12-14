From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: [PATCH 1/2] netfilter: add extended accounting infrastructure
 over nfnetlink
Date: Wed, 14 Dec 2011 21:23:44 +0800
Message-ID: <CABa6K_EK5LeRcXh_imWF8T5_T29cWgW5E4YrkdaEHuNq_EGQCA@mail.gmail.com>
References: <1323860443-7129-1-git-send-email-pablo@netfilter.org> <1323860443-7129-2-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, kadlec@blackhole.kfki.hu,
	kaber@trash.net, jengelh@medozas.de, thomas.jarosch@intra2net.com
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:48949 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657Ab1LNNYF convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Dec 2011 08:24:05 -0500
Received: by vcbfk14 with SMTP id fk14so583375vcb.19
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Dec 2011 05:24:05 -0800 (PST)
In-Reply-To: <1323860443-7129-2-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Dec 14, 2011 at 7:00 PM,  <pablo@netfilter.org> wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
>
> We currently have two ways to account traffic in netfilter:
>
> - iptables chain and rule counters:
>
> =A0# iptables -L -n -v
> Chain INPUT (policy DROP 3 packets, 867 bytes)
> =A0pkts bytes target =A0 =A0 prot opt in =A0 =A0 out =A0 =A0 source =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 destination
> =A0 =A08 =A01104 ACCEPT =A0 =A0 all =A0-- =A0lo =A0 =A0 * =A0 =A0 =A0=
 0.0.0.0/0 =A0 =A0 =A0 =A0 =A0 =A00.0.0.0/0
>
> - use flow-based accounting provided by ctnetlink:
>
> =A0# conntrack -L
> tcp =A0 =A0 =A06 431999 ESTABLISHED src=3D192.168.1.130 dst=3D212.106=
=2E219.168 sport=3D58152 dport=3D80 packets=3D47 bytes=3D7654 src=3D212=
=2E106.219.168 dst=3D192.168.1.130 sport=3D80 dport=3D58152 packets=3D4=
9 bytes=3D66340 [ASSURED] mark=3D0 use=3D1
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
> This patch adds the extended accounting infrastructure for
> nfnetlink which aims to allow displaying real-time traffic accounting
> without the need of complicated and resource-consuming implementation
> in user-space. Basically, this new infrastructure allows you to creat=
e
> accounting objects. One accounting object is composed of packet and
> byte counters.
>
> In order to manipulate create accounting objects, you require the
> new libnetfilter_acct library. It contains several examples of use:
>
> libnetfilter_acct/examples# ./nfacct-add http-traffic
> libnetfilter_acct/examples# ./nfacct-get
> http-traffic =3D { pkts =3D 000000000000, =A0 bytes =3D 000000000000 =
};
>
> Then, you can use one of this accounting objects in several iptables
> rules using the new NFACCT target (which comes in a follow-up patch):
>

But you can replace nfacct with a separated chain, then the iptables
statistics counter of this chain can be used.

--=20
Regards,
Changli Gao(xiaosuo@gmail.com)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
