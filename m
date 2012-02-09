From: Quentin Aebischer <Quentin.Aebischer@USherbrooke.ca>
Subject: Re: [PATCH] conntrackd: basic TIPC implementation for NOTRACK mode
Date: Thu, 09 Feb 2012 15:45:34 -0500
Message-ID: <20120209154534.138455pkg6vo4wco@www.usherbrooke.ca>
References: <20120121085217.4272940o8fmk4v80@www.usherbrooke.ca>
 <20120122174140.GA18764@1984>
 <20120122162720.10123t2longq3zac@www.usherbrooke.ca>
 <20120123100733.GB23857@1984>
 <20120123132537.198937ydqdx1n3gg@www.usherbrooke.ca>
 <20120124010145.GA28314@1984>
 <20120124120058.234342gq75ohof6s@www.usherbrooke.ca>
 <20120126001928.GA10554@1984>
 <20120126211344.33964cmak17akti0@www.usherbrooke.ca>
 <20120208004354.GD29189@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	DelSp=Yes	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpi4.USherbrooke.ca ([132.210.236.3]:32765 "EHLO
	smtpi4.usherbrooke.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757814Ab2BIUpq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Feb 2012 15:45:46 -0500
In-Reply-To: <20120208004354.GD29189@1984>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> a =C3=A9crit=C2=A0:

> On Thu, Jan 26, 2012 at 09:13:44PM -0500, Quentin Aebischer wrote:
>> Ok, time for an other try !
>>
>> From : Quentin Aebischer <quentin.aebischer@usherbrooke.ca>
>>
>> Basic implementation of a TIPC channel for the conntrackd daemon
>> (successfully tested in NOTRACK and FTFW modes).
>>
>> TIPC is a protocol that allows applications in a cluster-based
>> environment to communicate quickly and reliably with other
>> applications in the cluster.
>> It allows both unicast and multicast, reliable/unreliable and
>> datagram/stream oriented communications.
>>
>> One of its main feature's of interest here is to provide sockets
>> that communicates in a connectionless, yet reliable manner that
>> guarantees delivery of every message sent over the network.
>> This can be useful in the context of high-available, cluster-based
>> firewalls where states propagation has to be both fast and reliable.
>>
>> So far, the results are encouraging, though more tests have to
>> performed on different setups to enhance the implementation and
>> track any bugs.
>>
>> An example config file can be found in the doc/sync/tipc directory
>> of the conntrack-tools, along with a README file providing basic
>> installation instructions.
>
> Looks fine. I'm planning to add this to one git branch to test it and
> give it some spins before merging it to master.
>
> Let me know if you have any update in your patch before I do so.

Please use the configuration file from the last patch I sent (previous =
=20
one was an older version that would give you parsing errors, sorry =20
about that).

Regards,

Quentin

> To unsubscribe from this list: send the line "unsubscribe netfilter-d=
evel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
