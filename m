From: Poltorak Serguei <poltorak@df.ru>
Subject: Re: target MARK in filter table?
Date: Tue, 15 Jul 2003 08:26:17 +0400 (MSD)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.3.95.1030715080541.10486A-100000@cannabis.dataforce.net>
References: <20030714080503.GE6538@naboo>
Reply-To: Poltorak Serguei <poltorak@df.ru>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20030714080503.GE6538@naboo>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

;The idea is to have targets for filtering in the filter table - and
;anything that modifies the packet [or potentially affect other kernel
;subsystems such as policy routing] in 'mangle'.
And if I'm using fwmark mechanism not to change packet, but to
mark it and remember that this one I need to treat differantly.

May be you know a better way to do it...
In my case i need to know if the examined packet had entered into a chain
or it didn't mached all of them. Because it may traverse 0,1 or 2 chains.
I'm marking the packet on the entrance of each chain and checking at the
end of FORWARD if it is marked. I'm marking packets i don't disallow, but
i'm not sure to accept, and if no chain will DROP it and it had passed at 
least one chain, it would be accepted.

;In that particular practical case, I think Poltorak Serguei is 'abusing'
;the mark mechanism for something that we didn't think it should be 
;
;> While we are on the topic of seemingly arbitrary "sanity" checks, why is
;> it that using the TCPMSS option throws a vague "invalid argument" error
;> when one forgets to also specify --syn? Can't that target just check for
;> tcp/syn dynamically, i.e. become a NOOP for non-syn packets, instead of
;> forcing me to specify --syn at rule insertion time?
I'm not abusing, it was text of Patrick Schaaf, not mine :)

now i'm using MARK in filter table. it works. i commented the checking of
table. may this cause problems (apart philosophy)? is it safe to use?

I think fwmark is very usefull not only with routing and qos to tell what
to change/mangle/nat/... It makes iptables more programmable :)

PoltoS/
