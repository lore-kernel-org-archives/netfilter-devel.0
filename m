From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] for some issues in tcp window tracking patch
Date: Fri, 21 May 2004 14:13:09 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0405211325150.7455-100000@blackhole.kfki.hu>
References: <40AD3CB7.1070107@eurodev.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <40AD3CB7.1070107@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Pablo,

On Fri, 21 May 2004, Pablo Neira wrote:

> a) Sometimes we destroy the conntrack calling
> conntrack->timeout.function((unsigned long)conntrack) but we are
> returning -NF_ACCEPT, so we are calling implicitely nf_conntrack_put
> from conntrack core, could we have any unexpected problem?

Good catch, this is one of the rare cases where conntrack must explicitly
drop the packet, so the return value should be -NF_DROP. (-NF_ACCEPT does
not guarantee that the packet will truly be dropped, as it was discussed
in the previous mail.)

> b) We don't need to set assured bit all the time, I think that I told
> you, well if so, sorry for repeating me.
>
>          } else if ((old_state == TCP_CONNTRACK_SYN_RECV
>                     || old_state == TCP_CONNTRACK_ESTABLISHED)
> -                   && new_state == TCP_CONNTRACK_ESTABLISHED)
> +                 && new_state == TCP_CONNTRACK_ESTABLISHED
> +                 && !test_bit(IPS_ASSURED_BIT, &conntrack->status)) {

Yes, I'll add the test but as first, because that's the common case.

> c) In the TCP_CONNTRACK_SYN_SENT case, we saw a SYN packet while staying
> in state TIME_WAIT, so there's a reopened connection. Why do we destroy
> the conntrack and don't recycle /reuse this conntrack? I mean,
> reinitilize all the fields and let it continue its travel through the
> tcp tracking of instead of returning NF_REPEAT.

To complete Willy's answer the reason is that there are a lot of
informations attached to a conntrack entry (expectations, NAT). There is
no functionality to reset all those info, but to destroy the entry and let
the system create a new one, with high probability from the slab cache.

> d) We could move up WRITE_UNLOCK(&tcp_lock) just before timeout is updated.

Yes, I'll modify the code accordingly.

> e) I'm not sure if it's worthy optimizing this case. In tcp_new, we are
> checking if a packet is clean as well as size of tcp header, then in
> tcp_packet we will do the same, so we are doing twice the same checking.
> If we consider that general case is that packets are clean, will be this
> double check worthy?

That double-checking happens only for connection-initiating packets.
If we'd add a check of a flag wether the cleaness checking had been
done or not, then the normal packets would suffer from it. I think the
current solution is the optimal one.

> thanks Jozsef!,
> insidious Pablo

Actually, I'm really glad that there are guys who goes trough the code,
work hard to understand and try to improve, optimize it. We have been
planning to submit the code for kernel inclusion for a long time, but
it cannot be done lightheartedly, without a wider (known) test base and
code scrutinizing by more people.

Compared to the cvs version, the following modifications has been added to
my tree:

- tcph->ack should be tcph->ack_seq in tcp_packet at TCP_CONNTRACK_CLOSE
  case
- inlined segment_seq_plus_len
- explicit drop of SYN/ACK when the state machine is out of sync
- releasing lock moved up, after setting timeout parameter in tcp_packet
- IPS_ASSURED_BIT is checked before set in tcp_packet
- SACK support added

I'm waiting for the result of the validation of the SACK code by the guys
from Balabit, then a new patch will be released.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
