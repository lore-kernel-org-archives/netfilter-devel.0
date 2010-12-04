From: Dong Hao <rainball.dh@gmail.com>
Subject: Fwd: Question: ip_frag-reasm function
Date: Sat, 4 Dec 2010 08:49:10 +0800
Message-ID: <AANLkTinr7B3Jf8F7dqvsfTdPCWj04=PmgLQqHng_5ype@mail.gmail.com>
References: <AANLkTikfO8F2g+Opz8wEOozkX4+v-6xNfq+_7BpxvVLm@mail.gmail.com>
	<AANLkTims-yBCUBzh5cgA4zLtb317DSoQv8dzd7RJ3A0f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64437 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946Ab0LDAtM convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Dec 2010 19:49:12 -0500
Received: by bwz15 with SMTP id 15so8901640bwz.19
        for <netfilter-devel@vger.kernel.org>; Fri, 03 Dec 2010 16:49:11 -0800 (PST)
In-Reply-To: <AANLkTims-yBCUBzh5cgA4zLtb317DSoQv8dzd7RJ3A0f@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

hi,guys.

I had read ip_frag_reasm function,i got a problem and didn't know why
it did that.

If you know it ,please tell me.thanks a lot.



ip_frag_reasm():

"If the first fragment is fragmented itself, we split it to two
chunks: the first with data and paged part and the second, holding
only fragments."

why did we do that?if we didn't split it to two chunks, what result
did we wait for?

static struct sk_buff *ip_frag_reasm(struct ipq *qp, struct net_device =
*dev)

{

     ...

   /* If the first fragment is fragmented itself, we split

     * it to two chunks: the first with data and paged part

     * and the second, holding only fragments.

     */

   if (skb_shinfo(head)->frag_list) {

        struct sk_buff *clone;

        int i, plen =3D 0;



        if ((clone =3D alloc_skb(0, GFP_ATOMIC)) =3D=3D NULL)

            goto out_nomem;

        clone->next =3D head->next;

        head->next =3D clone;

        /* clone=D6=B8=CF=F2frag_list */

        skb_shinfo(clone)->frag_list =3D skb_shinfo(head)->frag_list;

        skb_shinfo(head)->frag_list =3D NULL;

        for (i=3D0; i<skb_shinfo(head)->nr_frags; i++)

            plen +=3D skb_shinfo(head)->frags[i].size;

        clone->len =3D clone->data_len =3D head->data_len - plen;

        head->data_len -=3D clone->len;

        head->len -=3D clone->len;

        clone->csum =3D 0;

        clone->ip_summed =3D head->ip_summed;

        atomic_add(clone->truesize, &ip_frag_mem);

    }

    ...

}


--
To be a better man
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
