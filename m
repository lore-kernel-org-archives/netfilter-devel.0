From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] for some issues in tcp window tracking patch
Date: Sat, 22 May 2004 14:54:38 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0405221440310.10540-100000@blackhole.kfki.hu>
References: <40AE8A42.9060908@eurodev.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <40AE8A42.9060908@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, 22 May 2004, Pablo Neira wrote:

> conntrack->timeout.function is death_by_timeout -> which calls
> ip_conntrack_put -> which calls nf_conntrack_put  which decrements
> refcount and if zero, we release the conntrack.
>
> Now we return -NF_whatever, from conntrack core we call
> nf_conntrack_put, so same thing, we reduce refcount and if zero, we
> release the conntrack.
>
> I don't know if I'm missing anything but we are decrementing twice
> conntrack refcount, at worst we could try to release an already released
> conntrack. Am I missing anything?

No, that's fine. The conntrack entry goes away when all references are
released and it springs into existence with refcount 1 (conntrack itself).
Then when we attach the conntrack entry to a packet, the refcount is
incremented so that it can't disappear under us. We just decrement
those values here to destroy conntrack.

> >- tcph->ack should be tcph->ack_seq in tcp_packet at TCP_CONNTRACK_CLOSE
> >  case
> >- inlined segment_seq_plus_len
> >- explicit drop of SYN/ACK when the state machine is out of sync
> >- releasing lock moved up, after setting timeout parameter in tcp_packet
> >- IPS_ASSURED_BIT is checked before set in tcp_packet
> >- SACK support added
>
> two issues missing:
> - sender->loose decrements misplaced

I missed to add that to the 'done' list above.

> - use of defined flags in tcp.h
>
> and pending that you give your ok:
> - fine grain locking for private tcp helper info

Yep, those are not included yet - SACK was more important to add.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
