From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: xtables: add cluster match
Date: Wed, 18 Feb 2009 11:14:49 +0100
Message-ID: <499BDF99.9040906@trash.net>
References: <20090214192936.11718.44732.stgit@Decadence>	<49994643.8010001@trash.net> <499971CC.6040903@netfilter.org>	<49997247.3010105@trash.net> <4999787C.7050203@netfilter.org>	<499982CB.7020503@netfilter.org> <499981FA.3040106@trash.net>	<499A9597.4070608@netfilter.org> <499A9689.7090208@trash.net>	<499AC0B3.5040902@netfilter.org> <m3mycksv84.fsf@neo.luffy.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Vincent Bernat <bernat@luffy.cx>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48077 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbZBRKOw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Feb 2009 05:14:52 -0500
In-Reply-To: <m3mycksv84.fsf@neo.luffy.cx>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Vincent Bernat wrote:
> OoO  En ce d=E9but  d'apr=E8s-midi nuageux  du mardi  17 f=E9vrier  2=
009, vers
> 14:50, Pablo Neira Ayuso <pablo@netfilter.org> disait :
>=20
>> Re-adjusting cluster-total-nodes and cluster-local-nodes options (eg=
=2E if
>> one cluster node goes down and there are only two nodes alive, chang=
e
>> the rule-set to have only two nodes) seems indeed the natural way to=
 go
>> since the alive cluster nodes would share the workload that the fail=
ing
>> node has left. However, as said, existing failover daemons only sele=
ct
>> one new master to recover what a failing node was doing, thus, only =
one
>> runs the script to inject the states into the kernel.
>=20
> Moreover, some of  them (the one that are using  VRRP for example) do=
n't
> report the total number of nodes  still alive. As a user, I would pre=
fer
> a simple /proc interface to add/remove a node.

That "simple" argument really doesn't cut it, there's nothing inherentl=
y
more complicated in executing an iptables command compared to executing
an echo command. Most likely some program is going to do it anyways.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
