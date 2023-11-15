Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFCE6C07548
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Nov 2023 12:13:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234111AbjKOMNy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Nov 2023 07:13:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234922AbjKOMNx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Nov 2023 07:13:53 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C52412F
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Nov 2023 04:13:48 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id d9443c01a7336-1cc37fb1310so51888895ad.1
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Nov 2023 04:13:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700050428; x=1700655228; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6NCKTHaOaFcZigTsYpJ3UNnDnxLe7R+f7DA6QwRq0WI=;
        b=FqObX03pHw+cT7WzolJDwP2ywQZDV9ulvKi+EdRaKiq/kUfd87UiLt2P+gBzLD2WES
         CBJPx+y5YseCADm4Q0eCodSlR0LPQt8YSg2TmYZYIYqBvILT4v1BgAayj24ec1uphbsL
         o7rkbSjgrri/y1Z+ClZygHEP0Z0DwMiyc65MS2DGHmK7rl1s+c2J3mp5i/Y7UlKPsQXH
         uD2Xp8Raue56CYAzr88RvEOlhwKVzlTS6auLtkYbnN08VraJbrFGnH+SswBbIo5s815S
         LqJUWZk1fkkt1SsJY2cgwYPTFdxLUE+nDwAnoNczNAKWn7vMBG3T/awV4sRQh6GfMQz2
         LcLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700050428; x=1700655228;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6NCKTHaOaFcZigTsYpJ3UNnDnxLe7R+f7DA6QwRq0WI=;
        b=HMJn6cD8sUssEBinsuUxrjq3ClJXC1Qasi4oIBePGWk4SWWdKJIs8JrwncNUNsfEXY
         VSpMK4in6q/zeFIUq837vRW2wP25rBBZCqtFZHVeJ9MGGsnpe92ooZWJ7LBZIUozmkir
         PG6DF23OQBypjPiUx8Lmj7VksnCNnp8kdgHwCqRXo2PEuqNy6WSFfkXYv8pRuv2AFeW6
         QLi5rTZbFtufkYbLVhvT33uIf9pcgFoKASURhFQ77YAgRYueMLikJfVefHnaX0syz12u
         cu20Wvf0WbnlDiB2OHj9fd6SK2J9rsFaqrJfokgXs0fVn8oZlHNSH59K9eVw78b36OPb
         Xw6Q==
X-Gm-Message-State: AOJu0YyuaYmJKiSvCnppHIEJuRGJW3n6QdUDIcxsxNpdE8Dz+gFLborY
        o6xIoI0ZT1jGupfGKaTgIH6UvIvnemQ=
X-Google-Smtp-Source: AGHT+IHH5vN94amfAQ+GrWMhNNtQ94vCd8fMKUrRfpJ3B919ZvKsl/ewQ0TX/KGVeiYG8wDaTc9nNA==
X-Received: by 2002:a17:90b:164e:b0:27d:4f1f:47f6 with SMTP id il14-20020a17090b164e00b0027d4f1f47f6mr10884188pjb.32.1700050427590;
        Wed, 15 Nov 2023 04:13:47 -0800 (PST)
Received: from slk15.local.net (n58-108-90-185.meb1.vic.optusnet.com.au. [58.108.90.185])
        by smtp.gmail.com with ESMTPSA id oa3-20020a17090b1bc300b0027cfd582b51sm8658935pjb.3.2023.11.15.04.13.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Nov 2023 04:13:47 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date:   Wed, 15 Nov 2023 23:13:43 +1100
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue v3 1/1] src: Add nfq_nlmsg_put2() -
 user specifies header flags
Message-ID: <ZVS195mY/clQKa+/@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <ZVSkE1fzi68CN+uo@calendula>
 <20231115113011.6620-1-duncan_roe@optusnet.com.au>
 <ZVSuTwfVBEsCcthA@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZVSuTwfVBEsCcthA@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Nov 15, 2023 at 12:41:03PM +0100, Pablo Neira Ayuso wrote:
> On Wed, Nov 15, 2023 at 10:30:11PM +1100, Duncan Roe wrote:
> > Enable mnl programs to check whether a config request was accepted.
> > (nfnl programs do this already).
> >
> > v3: force on NLM_F_REQUEST
> >
> > v2: take flags as an arg (Pablo request)
> > Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> > ---
> >  .../libnetfilter_queue/libnetfilter_queue.h   |  1 +
> >  src/nlmsg.c                                   | 55 ++++++++++++++++++-
> >  2 files changed, 55 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/libnetfilter_queue/libnetfilter_queue.h b/include/libnetfilter_queue/libnetfilter_queue.h
> > index 3d8e444..f254984 100644
> > --- a/include/libnetfilter_queue/libnetfilter_queue.h
> > +++ b/include/libnetfilter_queue/libnetfilter_queue.h
> > @@ -151,6 +151,7 @@ void nfq_nlmsg_verdict_put_pkt(struct nlmsghdr *nlh, const void *pkt, uint32_t p
> >
> >  int nfq_nlmsg_parse(const struct nlmsghdr *nlh, struct nlattr **attr);
> >  struct nlmsghdr *nfq_nlmsg_put(char *buf, int type, uint32_t queue_num);
> > +struct nlmsghdr *nfq_nlmsg_put2(char *buf, int type, uint32_t queue_num, uint16_t flags);
> >
> >  #ifdef __cplusplus
> >  } /* extern "C" */
> > diff --git a/src/nlmsg.c b/src/nlmsg.c
> > index 5400dd7..999ccfe 100644
> > --- a/src/nlmsg.c
> > +++ b/src/nlmsg.c
> > @@ -309,10 +309,63 @@ int nfq_nlmsg_parse(const struct nlmsghdr *nlh, struct nlattr **attr)
> >   */
> >  EXPORT_SYMBOL
> >  struct nlmsghdr *nfq_nlmsg_put(char *buf, int type, uint32_t queue_num)
> > +{
> > +	return nfq_nlmsg_put2(buf, type, queue_num, 0);
> > +}
> > +
> > +/**
> > + * nfq_nlmsg_put2 - Convert memory buffer into a Netlink buffer with
> > + * user-specified flags
>
> This is setting up a netlink header in the memory buffer.

Yes. I just copied the description from nfq_nlmsg_put and tacked on "with
user-specified flags". Do you want to see
> Set up a netlink header in a memory buffer with user-specified flags
perhaps better
> Set up a netlink header with user-specified flags in a memory buffer
instead? And would you like me to change the nfq_nlmsg_put description to match?
>
> > + * \param *buf Pointer to memory buffer
> > + * \param type Either NFQNL_MSG_CONFIG or NFQNL_MSG_VERDICT
> > + * \param queue_num Queue number
> > + * \param flags additional (to NLM_F_REQUEST) flags to put in message header,
> > + *              commonly NLM_F_ACK
>
> remove NLM_F_REQUEST here.

Ok
>
> > + * \returns Pointer to netlink message
>
>                Pointer to netlink header

Again, copied from nfq_nlmsg_put. Fix that as well?
>
> > + *
> > + * Use NLM_F_ACK before performing an action that might fail, e.g.
>
> Failures are always reported.
>
> if you set NLM_F_ACK, then you always get an acknowledgment from the
> kernel, either 0 to report success or negative to report failure.
>
> if you do not set NLM_F_ACK, then only failures are reported by the
> kernel.

Yes, I was trying to explain that. The point being, if you don't specify
NLM_F_ACK and the command succeeds then mnl_socket_recvfrom() will hang.
>
> > + * attempt to configure NFQA_CFG_F_SECCTX on a system not runnine SELinux.
> > + * \n
> > + * NLM_F_ACK instructs the kernel to send a message in response
> > + * to a successful command.
>
> As I said above, this is not accurate.

Sorry, it looks to me to be the same as what you said. Which bit is not
accurate, what should it say instead?
>
> > + * The kernel always sends a message in response to a failed command.
> > + * \n
> > + * This code snippet demonstrates reading these responses:
> > + * \verbatim
> > +	nlh = nfq_nlmsg_put2(nltxbuf, NFQNL_MSG_CONFIG, queue_num, NLM_F_ACK);
> > +	mnl_attr_put_u32(nlh, NFQA_CFG_FLAGS, NFQA_CFG_F_SECCTX);
> > +	mnl_attr_put_u32(nlh, NFQA_CFG_MASK, NFQA_CFG_F_SECCTX);
> > +
> > +	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
> > +		perror("mnl_socket_send");
> > +		exit(EXIT_FAILURE);
> > +	}
> > +
> > +	ret = mnl_socket_recvfrom(nl, nlrxbuf, sizeof nlrxbuf);
> > +	if (ret == -1) {
> > +		perror("mnl_socket_recvfrom");
> > +		exit(EXIT_FAILURE);
> > +	}
> > +
> > +	ret = mnl_cb_run(nlrxbuf, ret, 0, portid, NULL, NULL);
> > +	if (ret == -1)
> > +		perror("configure NFQA_CFG_F_SECCTX");
> > +\endverbatim
> > + *
> > + * \note
> > + * The program above can continue after the error because NFQA_CFG_F_SECCTX
> > + * was the only item in the preceding **mnl_socket_sendto**.
> > + * If there had been other items, they would not have been actioned and it would
> > + * not now be safe to proceed.
> > + */
> > +
> > +EXPORT_SYMBOL
> > +struct nlmsghdr *nfq_nlmsg_put2(char *buf, int type, uint32_t queue_num,
> > +				uint16_t flags)
> >  {
> >  	struct nlmsghdr *nlh = mnl_nlmsg_put_header(buf);
> >  	nlh->nlmsg_type = (NFNL_SUBSYS_QUEUE << 8) | type;
> > -	nlh->nlmsg_flags = NLM_F_REQUEST;
> > +	nlh->nlmsg_flags = NLM_F_REQUEST | flags;
> >
> >  	struct nfgenmsg *nfg = mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
> >  	nfg->nfgen_family = AF_UNSPEC;
> > --
> > 2.35.8
> >
