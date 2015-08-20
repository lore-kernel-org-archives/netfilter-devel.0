From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: Re: [lnf-log RFC PATCH 2/2] utils: take a example from libmnl and
 use nflog_nlmsg_parse
Date: Thu, 20 Aug 2015 16:26:45 +0900
Message-ID: <20150820072645.GA3916@gmail.com>
References: <20150810081342.GB25169@gmail.com>
 <20150810081752.GD25169@gmail.com>
 <20150818060409.GA3062@salvia>
 <20150819071103.GA15064@gmail.com>
 <20150819220403.GA5220@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:34711 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbbHTH0u (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Aug 2015 03:26:50 -0400
Received: by pdbfa8 with SMTP id fa8so11126692pdb.1
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Aug 2015 00:26:50 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20150819220403.GA5220@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 Thank you for the reply.

On Thu, Aug 20, 2015 at 12:04:03AM +0200, Pablo Neira Ayuso wrote:
> I suggest you remove the nflog_data_init(), nflog_data_alloc(),
> nflog_data_free() and nflog_nlmsg_parse().
> 
> Those are part of the old API, we should focus on API that we can
> combine with libmnl.

I think I can follow your suggestion, is it correct?

Please let me ask two more things.
With these functions, nflog attrs can be acquired by
mnl_attr_get_payload, but can not show as XML in one shot. To do it,
may I post another patch:

    struct nflog_data *nfnl_attrs2data(struct nlattr **attr)
    {
        struct nflog_data *nfad = calloc(1, sizeof(struct nflog_data));
        if (nfad == NULL)
            return NULL;
        nfad->nfa = (struct nfattr **)&attr[1];
        return nfad;
    }

Is it acceptable?

It's just my curiosity, would you tell me what does nfnl_ prefix
stand for?

Thanks,
