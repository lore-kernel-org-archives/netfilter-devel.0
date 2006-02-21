From: Gregor Maier <gregor@net.in.tum.de>
Subject: Re: libnetfilter_queue man page
Date: Tue, 21 Feb 2006 18:03:10 +0100
Message-ID: <43FB47CE.8030003@net.in.tum.de>
References: <1139235549.30902.3.camel@localhost.localdomain>	<20060208141927.GX31060@sunbeam.de.gnumonks.org>
	<43EA2683.3030606@info-link.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Brad Fisher <brad@info-link.net>
In-Reply-To: <43EA2683.3030606@info-link.net>
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

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1


> -----------------
> nfq_set_verdict()
> -----------------
> 
> Prototype:
> 	int nfq_set_verdict(struct nfq_q_handle *qh, u_int32_t id, u_int32_t verdict, u_int32_t data_len, unsigned char *buf)
> 
> Parameters:
> 	qh			Netfilter queue handle obtained by call to nfq_create_queue().
> 	id			ID assigned to packet by netfilter.  Can be obtained by: 
> 					int id;
> 					struct nfqnl_msg_packet_hdr *ph = nfq_get_msg_packet_hdr(tb);
> 					if (ph) id = ntohl(ph->packet_id);
> 	verdict		Verdict to return to netfilter
> 					NF_ACCEPT	- Accept the packet
> 					NF_DROP		- Drop the packet
> 					???			- anything else possible? (ie. continue?,
> 									jump? goto? log?)
After digging through kernel source I'm pretty sure, that the only
possible verdicts are
NF_DROP, NF_ACCEPT
NF_REPEAT  (queue the packet to userspace again) --> may lead to loops
NF_QUEUE   same as NF_REPEAT. There's a differnce between the handling
of NF_QUEUE and NF_REPEAT, but I don't know what this difference leads to.

Why? When a packet is queued to userspace it "leaves" the current hook
(e.g. the filter table) for good therefore it's not possible to continue
with the next rule in the current chain or to jump to another chain.

Maybe you also want to take a look at the Netfilter Hacking Howto, esp.
section 3 (netfilter architecture)

btw: thank's for the manpage

cu
gregor
- --
Gregor Maier                                      Lehrstuhl Informatik 8
gregor@net.in.tum.de                              Tel: +49 89  289-18010
http://www.net.in.tum.de                                     TU Muenchen
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (Darwin)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFD+0fOdGiwgbikMYMRAqCxAJ4vBk3pXKiIe5p564wYkHgXtXU7yACdHTSt
1rg3M/wEsrggvlMrOC+KMTI=
=GYqs
-----END PGP SIGNATURE-----
