From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: Re: [PATCH netfilter: nft] netfilter: nf_tables Add set op to nft_ct module
Date: Tue, 7 Jan 2014 16:34:16 +0100
Message-ID: <CAKfDRXi=1HgN_=gTy+voRU7upDpzPZ7NWjXZGiM_epUuzNU+DQ@mail.gmail.com>
References: <1389107719-24280-1-git-send-email-kristian.evensen@gmail.com>
	<20140107153210.GG9894@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:42456 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbaAGPeQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jan 2014 10:34:16 -0500
Received: by mail-pb0-f53.google.com with SMTP id ma3so257447pbc.26
        for <netfilter-devel@vger.kernel.org>; Tue, 07 Jan 2014 07:34:16 -0800 (PST)
In-Reply-To: <20140107153210.GG9894@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thank you. I forgot to add the check for mark != value. I will submit
a new version.

-Kristian

On Tue, Jan 7, 2014 at 4:32 PM, Florian Westphal <fw@strlen.de> wrote:
> Kristian Evensen <kristian.evensen@gmail.com> wrote:
>> +static void nft_ct_set_eval(const struct nft_expr *expr,
>> +                         struct nft_data data[NFT_REG_MAX + 1],
>> +                         const struct nft_pktinfo *pkt)
>> +{
>> +     const struct nft_ct *priv = nft_expr_priv(expr);
>> +     struct sk_buff *skb = pkt->skb;
>> +     u32 value = data[priv->sreg].data[0];
>> +     enum ip_conntrack_info ctinfo;
>> +     struct nf_conn *ct;
>> +
>> +     ct = nf_ct_get(skb, &ctinfo);
>> +
>> +     if (ct == NULL)
>> +             return;
>> +
>> +     switch (priv->key) {
>> +#ifdef CONFIG_NF_CONNTRACK_MARK
>> +     case NFT_CT_MARK:
>> +             ct->mark = value;
>> +             nf_conntrack_event_cache(IPCT_MARK, ct);
>
> I think the event should only be raised when the mark value
> is altered, else one might get nfct event storm.
