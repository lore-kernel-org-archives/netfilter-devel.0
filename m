From: "Joubert Berger" <joubert@berger-family.org>
Subject: possible ICMP accounting issue
Date: Mon, 3 Mar 2008 12:38:22 -0500
Message-ID: <82b0add70803030938q1638117cy9078ba884a5d3c6b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:7144 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757214AbYCCRiZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:38:25 -0500
Received: by fg-out-1718.google.com with SMTP id e21so184138fga.17
        for <netfilter-devel@vger.kernel.org>; Mon, 03 Mar 2008 09:38:23 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I have been working on a very simple accounting package that I need and
ran into something that might be a small problem.  It deals with the reply
packet for ICMP requests.  They don't get added to the byte and packet
 counts:

In the icmp_packet() function, we have:
        if (CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY) {
                if (atomic_dec_and_test(&ct->proto.icmp.count)
                    && del_timer(&ct->timeout))
                         ct->timeout.function((unsigned long)ct);
        } else {
                atomic_inc(&ct->proto.icmp.count);
                nf_conntrack_event_cache(IPCT
_PROTOINFO_VOLATILE, skb);
                 nf_ct_refresh_acct(ct, ctinfo, skb, nf_ct_icmp_timeout);
        }
As you can see, the nf_ct_refresh_acct() is not called when it is a reply.
Presumably because the connection tracking entry's timers are being
 deleted and the entry is getting ready to be flushed anyway (and of course you
don't need to update timer if you are getting ready to remove it).

But, the way I implemented my accounting package's reporting, I do it
at the time that the
 connection tracking "destroy" function is called.  So, this means
that the reply packet is
never included in my counts.

I was going to add (plus appropriate locking):
                ct->counters[CTINFO2DIR(ctinfo)].packets++;
                 ct->counters[CTINFO2DIR(ctinfo)].bytes +=
                        skb->len - skb_network_offset(skb);

Is this really an issue or is it just a problem for me, because of
where I am collecting the
 accounting information?

If it is a problem, I can provide a patch.

--joubert
