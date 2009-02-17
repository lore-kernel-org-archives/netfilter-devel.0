From: Vincent Bernat <bernat@luffy.cx>
Subject: Re: [PATCH] netfilter: xtables: add cluster match
Date: Tue, 17 Feb 2009 20:45:47 +0100
Message-ID: <m3mycksv84.fsf@neo.luffy.cx>
References: <20090214192936.11718.44732.stgit@Decadence>
	<49994643.8010001@trash.net> <499971CC.6040903@netfilter.org>
	<49997247.3010105@trash.net> <4999787C.7050203@netfilter.org>
	<499982CB.7020503@netfilter.org> <499981FA.3040106@trash.net>
	<499A9597.4070608@netfilter.org> <499A9689.7090208@trash.net>
	<499AC0B3.5040902@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bart.luffy.cx ([78.47.78.131]:46658 "EHLO bart.luffy.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752318AbZBQTwl convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Feb 2009 14:52:41 -0500
In-Reply-To: <499AC0B3.5040902@netfilter.org> (Pablo Neira Ayuso's message of
	"Tue, 17 Feb 2009 14:50:43 +0100")
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

OoO  En ce d=C3=A9but  d'apr=C3=A8s-midi nuageux  du mardi  17 f=C3=A9v=
rier  2009, vers
14:50, Pablo Neira Ayuso <pablo@netfilter.org> disait=C2=A0:

> Re-adjusting cluster-total-nodes and cluster-local-nodes options (eg.=
 if
> one cluster node goes down and there are only two nodes alive, change
> the rule-set to have only two nodes) seems indeed the natural way to =
go
> since the alive cluster nodes would share the workload that the faili=
ng
> node has left. However, as said, existing failover daemons only selec=
t
> one new master to recover what a failing node was doing, thus, only o=
ne
> runs the script to inject the states into the kernel.

Moreover, some of  them (the one that are using  VRRP for example) don'=
t
report the total number of nodes  still alive. As a user, I would prefe=
r
a simple /proc interface to add/remove a node.
--=20
Make sure all variables are initialised before use.
            - The Elements of Programming Style (Kernighan & Plauger)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
