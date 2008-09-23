From: "Julius Volz" <juliusv@google.com>
Subject: Getting IPVS and Netfilter SNAT to play together
Date: Tue, 23 Sep 2008 12:13:51 +0200
Message-ID: <f4845fc0809230313y14e69dc6s7b5e3e2f33f6beae@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Simon Horman" <horms@verge.net.au>,
	"Joseph Mack NA3T" <jmack@wm7d.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:8080 "EHLO
	smtp-out3.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750869AbYIWKN6 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Sep 2008 06:13:58 -0400
Received: from wpaz37.hot.corp.google.com (wpaz37.hot.corp.google.com [172.24.198.101])
	by smtp-out.google.com with ESMTP id m8NADrDj001524
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Sep 2008 11:13:53 +0100
Received: from mu-out-0910.google.com (mufg7.prod.google.com [10.102.183.7])
	by wpaz37.hot.corp.google.com with ESMTP id m8NADJ5E012086
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Sep 2008 03:13:51 -0700
Received: by mu-out-0910.google.com with SMTP id g7so1702180muf.1
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Sep 2008 03:13:51 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I already mentioned this on netdev and lvs-devel a while ago, but it's
a pretty specifc Netfilter-internals question, so I might have better
luck getting an answer here.

Generally, I was trying to get IPVS to work together with netfilter
SNAT. Currently, IPVS actively prevents the packets it manipulates
from being processed by Netfilter NAT in POSTROUTING by returning
NF_STOP from a POSTROUTING hook.

So I just removed this IPVS hook function that stops the further
POSTROUTING processing. I then added a normal SNAT rule to POSTROUTING
like this:

$ iptables =96t nat =96A POSTROUTING =96o eth1 =96j SNAT =96-to <snat_i=
p>

Without any IPVS, SNAT works without any problems. As expected, only
the first (SYN) packet of a connection appears on the POSTROUTING
chain.

However, with packets passing first through IPVS, the behavior gets wei=
rd:

The first SYN and the SYN/ACK of a TCP connection through IPVS do
_not_ traverse the NAT chain in POSTROUTING at all (verified by LOG
target, which produces no output), so their source is not rewritten
(resulting just in normal IPVS DNAT). However, the client's ACK
response to the SYN/ACK _does_ finally appear in this table and only
this third packet is SNATed correctly. The backend server then replies
with an RST, since it doesn't know a connection from the SNATed
source. The packet trace on the director looks like this:

CIP: client IP
VIP: virtual service IP
DIP: director (load balancer) IP
RIP: real server (backend) IP

Packet 1:
=3D=3D=3D=3D=3D=3D=3D
CIP =3D> VIP SYN (eth0, before IPVS)
CIP =3D> RIP SYN (eth1, after IPVS)

Packet 2:
=3D=3D=3D=3D=3D=3D=3D
RIP =3D> CIP SYN/ACK (eth1, before IPVS)
VIP =3D> CIP SYN/ACK (eth0, after IPVS)

Packet 3:
=3D=3D=3D=3D=3D=3D=3D
CIP =3D> VIP ACK (eth0, before IPVS)
DIP =3D> RIP ACK (eth1, after IPVS) - this is the first successfully
SNATed packet! Why?

Packet 4:
=3D=3D=3D=3D=3D=3D=3D
RIP =3D> DIP RST - real server doesn't know this connection from the DI=
P

Any ideas why the first packets never appear in the POSTROUTING chain
but the ACK does? I do not understand this, since IPVS injects all
handled packets into the OUTPUT chain, whereafter they should traverse
POSTROUTING... maybe someone with more understanding of Netfilter can
shed some light on this?

Thanks,
Julius

--=20
Julius Volz - Corporate Operations - SysOps

Google Switzerland GmbH - Identification No.: CH-020.4.028.116-1
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
