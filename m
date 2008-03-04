From: Patrick McHardy <kaber@trash.net>
Subject: Re: possible ICMP accounting issue
Date: Tue, 04 Mar 2008 15:55:51 +0100
Message-ID: <47CD62F7.30204@trash.net>
References: <82b0add70803030938q1638117cy9078ba884a5d3c6b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Joubert Berger <joubert@berger-family.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from viefep25-int.chello.at ([62.179.121.45]:26594 "EHLO
	viefep25-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755996AbYCDO4V (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Mar 2008 09:56:21 -0500
In-Reply-To: <82b0add70803030938q1638117cy9078ba884a5d3c6b@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Joubert Berger wrote:
> I have been working on a very simple accounting package that I need and
> ran into something that might be a small problem.  It deals with the reply
> packet for ICMP requests.  They don't get added to the byte and packet
>  counts:
> 
> In the icmp_packet() function, we have:
>         if (CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY) {
>                 if (atomic_dec_and_test(&ct->proto.icmp.count)
>                     && del_timer(&ct->timeout))
>                          ct->timeout.function((unsigned long)ct);
>         } else {
>                 atomic_inc(&ct->proto.icmp.count);
>                 nf_conntrack_event_cache(IPCT
> _PROTOINFO_VOLATILE, skb);
>                  nf_ct_refresh_acct(ct, ctinfo, skb, nf_ct_icmp_timeout);
>         }
> As you can see, the nf_ct_refresh_acct() is not called when it is a reply.
> Presumably because the connection tracking entry's timers are being
>  deleted and the entry is getting ready to be flushed anyway (and of course you
> don't need to update timer if you are getting ready to remove it).
> 
> But, the way I implemented my accounting package's reporting, I do it
> at the time that the
>  connection tracking "destroy" function is called.  So, this means
> that the reply packet is
> never included in my counts.
> 
> I was going to add (plus appropriate locking):
>                 ct->counters[CTINFO2DIR(ctinfo)].packets++;
>                  ct->counters[CTINFO2DIR(ctinfo)].bytes +=
>                         skb->len - skb_network_offset(skb);
> 
> Is this really an issue or is it just a problem for me, because of
> where I am collecting the
>  accounting information?


I guess we need a new nf_ct_acct() function and should call
this before destruction (similar for TCP RST).
