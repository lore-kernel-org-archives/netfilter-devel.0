From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nf_ct_tcp: better handling for SYN retransmissions
 after SYN+ACK
Date: Sat, 26 Feb 2011 21:11:31 +0100
Message-ID: <4D695E73.2090006@netfilter.org>
References: <20110226032834.4335.74168.stgit@decadence> <20110226033324.4335.53000.stgit@decadence> <alpine.DEB.2.00.1102261917180.22866@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030107050200050505030708"
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49321 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752163Ab1BZULk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 26 Feb 2011 15:11:40 -0500
In-Reply-To: <alpine.DEB.2.00.1102261917180.22866@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030107050200050505030708
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi Jozsef,

On 26/02/11 19:30, Jozsef Kadlecsik wrote:
> Maybe I'm just blind, but I don't see what you try to achieve. Actually, 
> with your patch you switch off the path which would handle the case when 
> conntrack holds an outdated entry from whatever reason.
> 
> Present code, cases:
> 
> a. conntrack in sync, SYN/ACK lost and client resends the SYN
>    - we ignore it but it does not do any harm
> b. conntrack entry is outdated, new SYN received
>    - we ignore it but save the initialization data from it
>    - when the reply SYN/ACK receives and it matches the saved data,
>      we pick up the new connection

This is what it seems at first sight, but this is not what it happens if
the conntrack is in SYN_RECV state.

Initially, the SYN packet hits first item of 'b', thus we save data from
it. But the SYN/ACK packet is considered a retransmission given that
we're in SYN_RECV state. Therefore, we never hit the second item of 'b'.

> With your patch, cases:
> 
> a. conntrack in sync, SYN/ACK lost and client resends the SYN
>   - SYN is out of window and will be marked as invalid
> b. conntrack entry is outdated, new SYN received
>   - SYN is out of window and will be marked as invalid

Damn, you're right, this patch is broken, that SYN packet won't pass
boundary III, IIRC.

> What do I miss?

That we're in SYN_RECV state :-).

>> This patch also helps a lot to conntrackd in stress scenarios
>> (assumming a client that generates lots of small TCP connections).
>> During the failover, consider that the new primary has injected
>> one outdated flow in SYN_RECV state (this is likely to happen if
>> the conntrack event rate is high because the backup will be a bit
>> delayed from the primary). With the current code, if the client
>> starts a new fresh connection that matches the tuple, the SYN
>> packet will be ignored without updating the state tracking, and
>> the SYN+ACK in reply will blocked as it will not pass checkings
>> III or IV (since all state tracking in the original direction is
>> not initialized because of the SYN packet was ignored).
> 
> The last_dir entries are updated from the ignored SYN packet and thus the 
> SYN+ACK won't be blocked - if the packet is a true answer to the SYN.

This is what it happens with other states, but not for SYN_RECV.

I have reworked the patch and the description. With this, the SYN_RECV
state if we're out of sync receives the same handling.

I have test it here, it works fine. Let me know if you're OK with it.

--------------030107050200050505030708
Content-Type: text/x-patch;
 name="tcp-syn-ack-recovery.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="tcp-syn-ack-recovery.patch"

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
this, we check if we were already in SYN_RECV and the previous packet
was a SYN. In that case, we enter the ignore case that get us in sync.

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

Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_proto_tcp.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 3fb2b73..baa9450 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -842,6 +842,20 @@ static int tcp_packet(struct nf_conn *ct,
 	tuple = &ct->tuplehash[dir].tuple;
 
 	switch (new_state) {
+	case TCP_CONNTRACK_SYN_RECV:
+		/* Special case: we were in SYN_RECV state but we are out of
+		 * sync. We have previously seen a SYN packet in the original
+		 * direction which has been ignored, now we see the SYN/ACK
+		 * packet but the TCP state transition considers that this is
+		 * a retransmission. However, this is not. Jump to the code
+		 * that get us in sync. */
+		if (old_state == TCP_CONNTRACK_SYN_RECV &&
+		    index == TCP_SYNACK_SET &&
+		    ct->proto.tcp.last_index == TCP_SYN_SET &&
+		    ct->proto.tcp.last_dir != dir &&
+		    ntohl(th->ack_seq) == ct->proto.tcp.last_end)
+			goto syn_recv_out_of_sync;
+		break;
 	case TCP_CONNTRACK_SYN_SENT:
 		if (old_state < TCP_CONNTRACK_TIME_WAIT)
 			break;
@@ -899,6 +913,7 @@ static int tcp_packet(struct nf_conn *ct,
 			 * not. We get in sync from the previously annotated
 			 * values.
 			 */
+syn_recv_out_of_sync:
 			old_state = TCP_CONNTRACK_SYN_SENT;
 			new_state = TCP_CONNTRACK_SYN_RECV;
 			ct->proto.tcp.seen[ct->proto.tcp.last_dir].td_end =

--------------030107050200050505030708--
