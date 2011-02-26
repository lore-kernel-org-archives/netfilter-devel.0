From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] netfilter: nf_ct_tcp: better handling for SYN retransmissions
 after SYN+ACK
Date: Sat, 26 Feb 2011 19:30:36 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1102261917180.22866@blackhole.kfki.hu>
References: <20110226032834.4335.74168.stgit@decadence> <20110226033324.4335.53000.stgit@decadence>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:52682 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752279Ab1BZSai (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 26 Feb 2011 13:30:38 -0500
In-Reply-To: <20110226033324.4335.53000.stgit@decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

On Sat, 26 Feb 2011, Pablo Neira Ayuso wrote:

> Consider the following scenario:
> 
>   client         firewall       server
>      |              |             |
>      |     syn      |     syn     |
>      |------------->|------------>|
>      |              |             |
>      |   syn+ack    |   syn+ack   |
>      |      x<------|<------------|      syn+ack got lost!
>      |              |             |
>      |     syn      |     syn     |
>      |------------->|------------>|
>      |              |             |
>      |   syn+ack    |   syn+ack   |
>      |<-------------|<------------|
>      |              |             |
> 
> Note that the syn+ack is lost after we have seen it. Without this
> patch, the TCP tracking ignores the retransmitted SYN without
> checking if the sequence number is in the window.

Maybe I'm just blind, but I don't see what you try to achieve. Actually, 
with your patch you switch off the path which would handle the case when 
conntrack holds an outdated entry from whatever reason.

Present code, cases:

a. conntrack in sync, SYN/ACK lost and client resends the SYN
   - we ignore it but it does not do any harm
b. conntrack entry is outdated, new SYN received
   - we ignore it but save the initialization data from it
   - when the reply SYN/ACK receives and it matches the saved data,
     we pick up the new connection

With your patch, cases:

a. conntrack in sync, SYN/ACK lost and client resends the SYN
  - SYN is out of window and will be marked as invalid
b. conntrack entry is outdated, new SYN received
  - SYN is out of window and will be marked as invalid

What do I miss?

> This patch also helps a lot to conntrackd in stress scenarios
> (assumming a client that generates lots of small TCP connections).
> During the failover, consider that the new primary has injected
> one outdated flow in SYN_RECV state (this is likely to happen if
> the conntrack event rate is high because the backup will be a bit
> delayed from the primary). With the current code, if the client
> starts a new fresh connection that matches the tuple, the SYN
> packet will be ignored without updating the state tracking, and
> the SYN+ACK in reply will blocked as it will not pass checkings
> III or IV (since all state tracking in the original direction is
> not initialized because of the SYN packet was ignored).

The last_dir entries are updated from the ignored SYN packet and thus the 
SYN+ACK won't be blocked - if the packet is a true answer to the SYN.
 
> Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/netfilter/nf_conntrack_proto_tcp.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
> index 3fb2b73..be0b84d 100644
> --- a/net/netfilter/nf_conntrack_proto_tcp.c
> +++ b/net/netfilter/nf_conntrack_proto_tcp.c
> @@ -142,12 +142,12 @@ static const u8 tcp_conntracks[2][6][TCP_CONNTRACK_MAX] = {
>  	{
>  /* ORIGINAL */
>  /* 	     sNO, sSS, sSR, sES, sFW, sCW, sLA, sTW, sCL, sS2	*/
> -/*syn*/	   { sSS, sSS, sIG, sIG, sIG, sIG, sIG, sSS, sSS, sS2 },
> +/*syn*/	   { sSS, sSS, sSR, sIG, sIG, sIG, sIG, sSS, sSS, sS2 },
>  /*
>   *	sNO -> sSS	Initialize a new connection
>   *	sSS -> sSS	Retransmitted SYN
>   *	sS2 -> sS2	Late retransmitted SYN
> - *	sSR -> sIG
> + *	sSR -> sSR	Retransmitted SYN, SYN/ACK got lost?
>   *	sES -> sIG	Error: SYNs in window outside the SYN_SENT state
>   *			are errors. Receiver will reply with RST
>   *			and close the connection.
> 

Bes regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
