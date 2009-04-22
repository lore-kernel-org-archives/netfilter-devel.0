From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter conntrack tcp lock
Date: Wed, 22 Apr 2009 18:04:20 +0200
Message-ID: <49EF4004.6040303@trash.net>
References: <20090421210412.268fc4e7@nehalam> <49EEA3B1.9030803@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Stephen Hemminger <shemminger@vyatta.com>,
	"Paul E. McKenney" <paulmck@us.ibm.com>,
	netfilter-devel@vger.kernel.org
To: Eric Dumazet <dada1@cosmosbay.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58813 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbZDVQEZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Apr 2009 12:04:25 -0400
In-Reply-To: <49EEA3B1.9030803@cosmosbay.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Dumazet wrote:
> Stephen Hemminger a =E9crit :
>> Not sure what the performance impact would be but simply changing tc=
p_lock
>> (in nf_conntrack_proto_tcp) to a spin_lock might get a performance b=
oost.
>> I thought I heard Paul say read_locks are way slower than spin_lock.
>>
>> Alternatively, going to some form of bit based hash lock might work.
>>
> I thought Patrick was OK with adding a spinlock into each nf_conn str=
uct ?
> (We shrunk this struct with the rcu_head removal)

Yes, my main concern was the further size increase.

> A straight forward locking schem. We have spinlocks everywhere in ker=
nel afterall, and
> conntracking deserves this.
> =20
> Just resubmit one of your prior patch perhaps ? I can dig it in a cou=
ple of hours eventually.

Yes, please.

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
