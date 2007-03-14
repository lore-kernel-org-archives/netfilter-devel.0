From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 1/1] Re: dangerous? Setting mark in nat table
Date: Wed, 14 Mar 2007 15:09:52 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0703141453400.26704@blackhole.kfki.hu>
References: <et6fp4$l04$1@sea.gmane.org>
	<Pine.LNX.4.61.0703131632190.18488@yvahk01.tjqt.qr>
	<45F6CD7C.40708@ufomechanic.net>
	<Pine.LNX.4.61.0703131717440.18488@yvahk01.tjqt.qr>
	<1173868532.26913.39.camel@henriknordstrom.net>
	<45F7D657.8070907@trash.net>
	<1173876211.26913.73.camel@henriknordstrom.net>
	<45F7F027.9050300@ufomechanic.net> <45F7F3C6.3060908@trash.net>
	<Pine.LNX.4.64.0703141415200.26704@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
	netfilter-devel@lists.netfilter.org, Amin Azez <azez@ufomechanic.net>,
	Henrik Nordstrom <henrik@henriknordstrom.net>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0703141415200.26704@blackhole.kfki.hu>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, 14 Mar 2007, Jozsef Kadlecsik wrote:

>> net/netfilter/xt_CLASSIFY.c:            .table          = "mangle",
>> net/netfilter/xt_CONNSECMARK.c:         .table          = "mangle",
>> net/netfilter/xt_DSCP.c:                .table          = "mangle",
>> net/netfilter/xt_MARK.c:                .table          = "mangle",
>> net/netfilter/xt_SECMARK.c:             .table          = "mangle",
>> net/ipv4/netfilter/ipt_ECN.c:   .table          = "mangle",
>> net/ipv4/netfilter/ipt_TOS.c:   .table          = "mangle",
>> net/ipv4/netfilter/ipt_TTL.c:   .table          = "mangle",
>> net/ipv6/netfilter/ip6t_HL.c:   .table          = "mangle",
>> 
>> If we're going to remove this, I think we should do it for all of them.
>
> Sorry, but I disagree. The DSCP, ECN, TOS, TTL, HL targets modify the packet 
> itself and thus all belong to the mangle table alone.

Umm, probably I was too terse in the sentence above...

Tecnically speaking, the targets could be "released" from the mangle 
table. However, all the tables have got a specific function. By breaking 
up the tie between the given targets ("mangle packet content thus and 
thus") and the table which carries the functionality ("mangle" table) just 
confuse the internal logic behind the system.

The MARK/CONNMARK targets can be used to carry neutral information all 
around the netfilter framework (besides triggering routing). So I agree 
that let those be available in all tables.

Personally, I'm not so convinced about CLASSIFY, SECMARK and CONNSECMARK.
The targets make possible to alter/modify the behaviour of external 
systems. Is there any functionality lost if the targets are restricted to
the mangle table (taking into account the ctstate match)?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
           H-1525 Budapest 114, POB. 49, Hungary
