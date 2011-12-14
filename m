From: Anand Raj Manickam <anandrm@gmail.com>
Subject: Re: [PATCH 0/2] [RFC] Extended accounting infrastructure for iptables
Date: Wed, 14 Dec 2011 19:07:36 +0530
Message-ID: <CAEyr1FSqC44pWk4RmTJs-Lo_reMOoGKd1AN5gLcsKi8VVgALew@mail.gmail.com>
References: <1323860443-7129-1-git-send-email-pablo@netfilter.org>
	<CABa6K_Ffexe2SsaxyRPLBEjf1WOfSEgzJ4fa5L81QZs6JvXsVA@mail.gmail.com>
	<20111214133010.GA3155@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Changli Gao <xiaosuo@gmail.com>, netfilter-devel@vger.kernel.org,
	kadlec@blackhole.kfki.hu, kaber@trash.net, jengelh@medozas.de,
	thomas.jarosch@intra2net.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48874 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755283Ab1LNNhi convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Dec 2011 08:37:38 -0500
Received: by eaaj10 with SMTP id j10so746882eaa.19
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Dec 2011 05:37:36 -0800 (PST)
In-Reply-To: <20111214133010.GA3155@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Great Stuff!

On Wed, Dec 14, 2011 at 7:00 PM, Pablo Neira Ayuso <pablo@netfilter.org=
> wrote:
> On Wed, Dec 14, 2011 at 09:12:52PM +0800, Changli Gao wrote:
>> On Wed, Dec 14, 2011 at 7:00 PM, =A0<pablo@netfilter.org> wrote:
>> > From: Pablo Neira Ayuso <pablo@netfilter.org>
>> >
>> > Hi!
>> >
>> > We currently have two ways to account traffic in netfilter:
>> >
>> > - iptables chain and rule counters:
>> >
>> > =A0# iptables -L -n -v
>> > Chain INPUT (policy DROP 3 packets, 867 bytes)
>> > =A0pkts bytes target =A0 =A0 prot opt in =A0 =A0 out =A0 =A0 sourc=
e =A0 =A0 =A0 =A0 =A0 =A0 =A0 destinat
>> > =A0 =A08 =A01104 ACCEPT =A0 =A0 all =A0-- =A0lo =A0 =A0 * =A0 =A0 =
=A0 0.0.0.0/0 =A0 =A0 =A0 =A0 =A0 =A00.0.0.0/
>> >
>> > - use flow-based accounting provided by ctnetlink:
>> >
>> > =A0# conntrack -L
>> > tcp =A0 =A0 =A06 431999 ESTABLISHED src=3D192.168.1.130 dst=3D212.=
106.219.168 sport=3D58
>> >
>> > While trying to display real-time accounting statistics, we requir=
e
>> > to pool the kernel periodically to obtain this information. This i=
s
>> > OK if the number of flows is relatively low. However, in case that
>> > the number of flows is huge, we can spend a considerable amount of
>> > cycles to iterate over the list of flows that have been obtained.
>> >
>> > Moreover, if we want to obtain the sum of the flow accounting resu=
lts
>> > that match some criteria, we have to iterate over the whole list o=
f
>> > existing flows, look for matchings and update the counters.
>> >
>> > This patchset adds the extended accounting infrastructure in
>> > kernel-space. It is composed of one nfnetlink interface that
>> > allows you to create, to update and to retrieve accounting objects=
=2E
>> > These objects can be used to account traffic with the flexibility
>> > that iptables rules provide (by means of the new NFACCT target).
>> >
>> > Quick example of use:
>> >
>> > 1) You create the accounting object:
>> >
>> > libnetfilter_acct/examples# ./nfacct-add http-traffic
>> >
>> > 2) Add the iptables rules for traffic you want to account:
>> >
>> > # iptables -I INPUT -p tcp --sport 80 -j NFACCT --nfacct-name http=
-traffic
>> > # iptables -I OUTPUT -p tcp --dport 80 -j NFACCT --nfacct-name htt=
p-traffic
>> >
>>
>> Why not use the counters of iptables instead?
>>
>> iptables-save -c
>
> If you want to obtain the sum of the counters that match some criteri=
a,
> you have to iterate over the whole list of existing rules, look for
> matchings and update the counters.
>
> Moreover, if you have a large rule-set, polling periodically
> iptables-save -c can be expensive.
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
