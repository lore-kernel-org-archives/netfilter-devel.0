From: Brad Fisher <brad@info-link.net>
Subject: Re: libnetfilter_queue man page
Date: Tue, 21 Feb 2006 12:10:00 -0600
Message-ID: <43FB5778.2050301@info-link.net>
References: <1139235549.30902.3.camel@localhost.localdomain>	<20060208141927.GX31060@sunbeam.de.gnumonks.org>
	<43EA2683.3030606@info-link.net> <43FB47CE.8030003@net.in.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Gregor Maier <gregor@net.in.tum.de>
In-Reply-To: <43FB47CE.8030003@net.in.tum.de>
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

Gregor Maier wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
>
>   
>> -----------------
>> nfq_set_verdict()
>> -----------------
>>
>> Prototype:
>> 	int nfq_set_verdict(struct nfq_q_handle *qh, u_int32_t id, u_int32_t verdict, u_int32_t data_len, unsigned char *buf)
>>
>> Parameters:
>> 	qh			Netfilter queue handle obtained by call to nfq_create_queue().
>> 	id			ID assigned to packet by netfilter.  Can be obtained by: 
>> 					int id;
>> 					struct nfqnl_msg_packet_hdr *ph = nfq_get_msg_packet_hdr(tb);
>> 					if (ph) id = ntohl(ph->packet_id);
>> 	verdict		Verdict to return to netfilter
>> 					NF_ACCEPT	- Accept the packet
>> 					NF_DROP		- Drop the packet
>> 					???			- anything else possible? (ie. continue?,
>> 									jump? goto? log?)
>>     
> After digging through kernel source I'm pretty sure, that the only
> possible verdicts are
> NF_DROP, NF_ACCEPT
> NF_REPEAT  (queue the packet to userspace again) --> may lead to loops
> NF_QUEUE   same as NF_REPEAT. There's a differnce between the handling
> of NF_QUEUE and NF_REPEAT, but I don't know what this difference leads to.
>
> Why? When a packet is queued to userspace it "leaves" the current hook
> (e.g. the filter table) for good therefore it's not possible to continue
> with the next rule in the current chain or to jump to another chain.
>
> Maybe you also want to take a look at the Netfilter Hacking Howto, esp.
> section 3 (netfilter architecture)
>
> btw: thank's for the manpage
>
>   
Glad to hear someone has found it useful :)
You are correct, I also came to the conclusion that those are the only 
verdicts available.  The NF_REPEAT verdict seems to send the packet back 
through the entire chain/hook.  It doesn't start it at the next rule 
following the queue rule (which I'd like to have, but perhaps it's not 
possible).

BTW: I have had a chance to actually work with the library a bit, so I 
have updated my notes since I sent the previous message.  I didn't add 
much, just updated some of the questionable info.  If anyone is 
interested, I'll be glad to send them a copy.  So far the biggest issues 
I've run into are that marking doesn't work in 2.6.15 (I think it should 
in 2.6.16), and I can't seem to ever read the timestamp for a packet, no 
matter what hook it comes in on.  I've just been using gettimeofday for 
that for now.

-Brad
> cu
> gregor
> - --
> Gregor Maier                                      Lehrstuhl Informatik 8
> gregor@net.in.tum.de                              Tel: +49 89  289-18010
> http://www.net.in.tum.de                                     TU Muenchen
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.2.4 (Darwin)
> Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org
>
> iD8DBQFD+0fOdGiwgbikMYMRAqCxAJ4vBk3pXKiIe5p564wYkHgXtXU7yACdHTSt
> 1rg3M/wEsrggvlMrOC+KMTI=
> =GYqs
> -----END PGP SIGNATURE-----
>
>
> !DSPAM:3824,43fb47d3148949031012739!
>
>   
