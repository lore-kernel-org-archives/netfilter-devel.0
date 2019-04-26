Return-Path: <SRS0=OoQ/=S4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FE42C43219
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 14:06:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F45C2077B
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 14:06:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=untangle.com header.i=@untangle.com header.b="gbub2Ylt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbfDZOGl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 26 Apr 2019 10:06:41 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:44928 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbfDZOGk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Apr 2019 10:06:40 -0400
Received: by mail-qt1-f195.google.com with SMTP id s10so4145471qtc.11
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Apr 2019 07:06:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=untangle.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=RDBdSdbd2lCNpSd7fisxzBZ1k83IR3WYVqfAI5FvcDs=;
        b=gbub2YltlDVFQTz5yqTseZ0KZILFk2YdnE2DKL0R6aB/TeZ2MQhZNCdqiLoSQhbKNy
         URXqmoS673mBuYbMof1Pr+ELzUcs8SiL9tTtoJYYCZN7geWayRAiY3DMPMDQr+6zQ/4T
         8grzFQpM4mgIDWq7nu7ws1N7LjYemSnnK1FqI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=RDBdSdbd2lCNpSd7fisxzBZ1k83IR3WYVqfAI5FvcDs=;
        b=uNCfzLh09mXyOisErjSIgsz5Vt+21sp7rdr0yHrcinLd7kSZl06jnB3PUlwMsJvPjY
         1yTi+fmXwVBlGIDoNdIRuh8SJPU6/uUd6OdbrIxdHIIcctmzz8VSHF8h2KRL4o1Kp8tn
         1qkoHj8tbriAx1LvZqjEn/PolsW2Noqmzs21J4/eQL4bHGGPGL0Rn8U7E0jSRKQ192dU
         Fn51AD5ECw1LctzdXmGl9l1FIMRtHSvrR5uVPRgRCaF71IOTA7pYzcjfPSP4oDKMBWGb
         zlYzvnL0whZ9LT8V1DHQqEP8l3bt0YwWaZjmb9ciRboxbp7b7MfeveOt7ajdxCnICNoA
         XkVA==
X-Gm-Message-State: APjAAAVe9luBYGRVSWiB1idLXRGjP2FIngNljHFanq6RLiu257MR51m1
        ui93aN9JXicxvdyew7fRuPZE9A==
X-Google-Smtp-Source: APXvYqw4n06MDl4uaB+MU5ltAa+MFRDQ0x3iWqKLnRHGnHe8AK908Nz5FQAW+PDKXNNUY6onbA/dUQ==
X-Received: by 2002:ad4:5442:: with SMTP id h2mr23711547qvt.198.1556287600024;
        Fri, 26 Apr 2019 07:06:40 -0700 (PDT)
Received: from pinebook (cpe-74-137-94-90.kya.res.rr.com. [74.137.94.90])
        by smtp.gmail.com with ESMTPSA id h10sm1316496qkk.69.2019.04.26.07.06.39
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 26 Apr 2019 07:06:39 -0700 (PDT)
Date:   Fri, 26 Apr 2019 10:06:37 -0400
From:   Brett Mastbergen <bmastbergen@untangle.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     pablo@netfilter.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] ct: Add support for the 'id' key
Message-ID: <20190426135032.GA1906@pinebook>
References: <20190423201841.8539-1-bmastbergen@untangle.com>
 <20190423205535.omwrkwc5ceahoz76@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190423205535.omwrkwc5ceahoz76@breakpoint.cc>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 23-04-19, Florian Westphal wrote:
> Brett Mastbergen <bmastbergen@untangle.com> wrote:
> > +const struct datatype ct_id_type = {
> > +	.type		= TYPE_CT_ID,
> > +	.name		= "ct_id",
> > +	.desc		= "conntrack id",
> > +	.byteorder	= BYTEORDER_BIG_ENDIAN,
> > +	.size		= 4 * BITS_PER_BYTE,
> > +	.basetype	= &integer_type,
> > +};
> 
> Pablo, I know we've discussed this in the past but I think
> the ct id would be a good candidate to add a generic uint32_t
> integer type.
> 
> AFAICS the ct_id_type is unneeded per this patch,
> but IIRC to make use of this for set definitions we can't use generic
> integer type as it has no fixed size.

Indeed, the only reason I added the ct_id type was so there would be
a fixed length integer type to use in sets and as a key to maps.  If
you'd like me to throw together a patch that creates a generic 32
bit integer type, and then use that for the ct id key, just say the
word.

> 
> This is the first data type that doesn't need any specific
> parsing/printing, AFAICS its just needed to get a fixed 32bit size.
