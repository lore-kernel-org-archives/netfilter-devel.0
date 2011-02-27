From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nf_ct_tcp: better handling for SYN retransmissions
 after SYN+ACK
Date: Sun, 27 Feb 2011 01:00:33 +0100
Message-ID: <4D699421.4070309@netfilter.org>
References: <20110226032834.4335.74168.stgit@decadence> <20110226033324.4335.53000.stgit@decadence> <alpine.DEB.2.00.1102261917180.22866@blackhole.kfki.hu> <4D695E73.2090006@netfilter.org> <alpine.DEB.2.00.1102262238360.23113@blackhole.kfki.hu> <4D698FCB.6060205@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060700040104020003030909"
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	Changli Gao <xiaosuo@gmail.com>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57677 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717Ab1B0AAj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 26 Feb 2011 19:00:39 -0500
In-Reply-To: <4D698FCB.6060205@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060700040104020003030909
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 27/02/11 00:42, Pablo Neira Ayuso wrote:
> On 26/02/11 22:45, Jozsef Kadlecsik wrote:
>> On Sat, 26 Feb 2011, Pablo Neira Ayuso wrote:
>>> I have test it here, it works fine. Let me know if you're OK with it.
>>
>> The patch looks OK but I think Changli Gao is also right and it'd be 
>> simpler to set the [reply][synack][SR] state to sIG. What do you think?
> 
> I read his email before leaving and after I made the new patch.
> 
> Indeed, his idea is simpler, here's a new patch. I tested it here, it
> works fine.
> 
> Patrick, please apply!

Hm, I forgot to include the description. New patch attached.

--------------060700040104020003030909
Content-Type: text/x-patch;
 name="tcp-changli.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="tcp-changli.patch"

netfilter: nf_ct_tcp: fix out of sync scenario while in SYN_RECV

From: Pablo Neira Ayuso <pablo@netfilter.org>

This patch fixes the out of sync scenarios while in SYN_RECV state.

Quoting Jozsef, what it happens if we are out of sync if the
following:

> b. conntrack entry is outdated, new SYN received
>    - (b1) we ignore it but save the initialization data from it
>    - (b2) when the reply SYN/ACK receives and it matches the saved data,
>      we pick up the new connection

This is what it should happen if we are in SYN_RECV state. Initially,
the SYN packet hits b1, thus we save data from it. But the SYN/ACK
packet is considered a retransmission given that we're in SYN_RECV
state. Therefore, we never hit b2 and we don't get in sync. To fix
this, we ignore SYN/ACK if we are in SYN_RECV. If the previous packet
was a SYN, then we enter the ignore case that get us in sync.

This patch helps a lot to conntrackd in stress scenarios (assumming a
client that generates lots of small TCP connections). During the failover,
consider that the new primary has injected one outdated flow in SYN_RECV
state (this is likely to happen if the conntrack event rate is high
because the backup will be a bit delayed from the primary). With the
current code, if the client starts a new fresh connection that matches
the tuple, the SYN packet will be ignored without updating the state
tracking, and the SYN+ACK in reply will blocked as it will not pass
checkings III or IV (since all state tracking in the original direction
is not initialized because of the SYN packet was ignored and the ignore
case that get us in sync is not applied).

I posted a couple of patches before this one. Changli Gao spotted
a simpler way to fix this problem. This patch implements his idea.

Cc: Changli Gao <xiaosuo@gmail.com>
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_proto_tcp.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 3fb2b73..19bbab7 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -227,11 +227,11 @@ static const u8 tcp_conntracks[2][6][TCP_CONNTRACK_MAX] = {
  *	sCL -> sIV
  */
 /* 	     sNO, sSS, sSR, sES, sFW, sCW, sLA, sTW, sCL, sS2	*/
-/*synack*/ { sIV, sSR, sSR, sIG, sIG, sIG, sIG, sIG, sIG, sSR },
+/*synack*/ { sIV, sSR, sIG, sIG, sIG, sIG, sIG, sIG, sIG, sSR },
 /*
  *	sSS -> sSR	Standard open.
  *	sS2 -> sSR	Simultaneous open
- *	sSR -> sSR	Retransmitted SYN/ACK.
+ *	sSR -> sIG	Retransmitted SYN/ACK, ignore it.
  *	sES -> sIG	Late retransmitted SYN/ACK?
  *	sFW -> sIG	Might be SYN/ACK answering ignored SYN
  *	sCW -> sIG

--------------060700040104020003030909--
