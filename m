From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: [nf-failover] [PATCH] Numerous ct_sync updates.
Date: Fri, 15 Oct 2004 16:09:27 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <1097849367.2498.107.camel@nienna.balabit>
References: <20041014191624.GH12694@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Netfilter-failover list <netfilter-failover@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20041014191624.GH12694@obroa-skai.de.gnumonks.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


  Hi,

  Wow, great! :) Some comments:

2004-10-14, cs keltez=E9ssel 21:16-kor Harald Welte ezt =EDrta:
> - comment out INITSYNC_FOLLOWS code, it shouldn't be needed anymore

  Yes, it's obsolete now that MASTER_ANNOUNCE is sent before each
initial resync. If the end of an initsync run would be signalled as well
(by always sending the empty update message for example) the following
code could be obsoleted as well (it is a hack, after all):

	if (msgs_received < CT_SYNC_INITSYNC_RATE) {
		/* We have not received more than CT_SYNC_INITSYNC_RATE
		 * messages in the last 100 ms.  This usually means
		 * we're not receiving initial re-synchronization
		 * messages anymore, so if we're in state
		 * SLAVE_SYNRECV, we transition into SLAVE_RUNNING. */
		cts_proto_recv_running(cts_cfg.protoh);
	}

> +	CT_SYNC_DEBUG("sending master_announce with seqno=3D%u\n",
> +		      cph->send.ring.seqno);
> +
>  	csb_hdr_fill(cph, &pkt.hdr, CT_SYNC_PKT_MASTER_ANNOUNCE,=20
> -		     cph->send.ring.seqno++);
> +		     cph->send.ring.seqno);

> +			CT_SYNC_INFO("received master announcement, "
> +				     "setting initial seqno to %u\n",=20
> +				     csr->seqno);
> +			/* csr->seqno is last received seqno, thus we expect
> +			 * csr->seqno+1 in next SYNC packet. Sender tells us
> +			 * the sequence number it is about to send with the
> +			 * next packet, so we need to subtract 1 ?!?  */
>  			csr->seqno =3D ntohs(csb->pkt.hdr.pktseq);
>  			break;

  Hmm, the log message does not seem to be correct, CT_SYNC_INFO should
be _after_ setting csr->seqno to the new value. And because the master
announcement is now sent without incrementing the sender's seqno (which
is correct in my opinion), we really have to subtract 1 in the second
part, don't we?

  I have some updates as well, I'll commit them if I find the time
needed to do some basic testing. (Mostly trivial ones not affecting
normal operation at all...)

  BTW, I think the protocol/ct_sync needs some more work. At the moment,
it is not possible for a single node to be part of more sync groups, and
this is a problem if you try to use ct_sync in a typical VRRP setup...

--=20
 Regards,
   Krisztian KOVACS
