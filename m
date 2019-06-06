Return-Path: <SRS0=A3Nh=UF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AAF3C28EB3
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Jun 2019 15:19:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E8FB82083E
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Jun 2019 15:19:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=brauner.io header.i=@brauner.io header.b="KpUcO0Cn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729273AbfFFPTv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 Jun 2019 11:19:51 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33616 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729128AbfFFPTv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Jun 2019 11:19:51 -0400
Received: by mail-pf1-f195.google.com with SMTP id x15so1724396pfq.0
        for <netfilter-devel@vger.kernel.org>; Thu, 06 Jun 2019 08:19:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brauner.io; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+dI5swD1+omNHneKtJgThPzt3z+a6zgCfryKXerEk+I=;
        b=KpUcO0CnhBIu8G6mnGGrqCHe1Kkx45ZcW+oH2HZ2Kz7r+idRSFJWy0DVbMKv3k/uE/
         M/nUZ0pa9SZekl54rp6x3Vwe/QiB8ICNkwPBthR6RzgpCENAMQ0CMK5v9H1NIKzq+olP
         5EoyF3PiLb/LovgHPn8jgagX52/cJeJ6x4VhmFCbZD/1E1kCD/j6y9NP1SgkRn7jDKBX
         TK7bIdcWa3UO/PLu8KRVgxtvdv0xe6UzdcZAcp8XWK6uKNBvP5XB89OZC2ssq/cjozdJ
         MthlBYbsYBUoAD1Xr+9AYhFzp4WY04PuKZ3n1u8UdrzfLx0rRYn5pGDQVhNIHD2mHIES
         RqjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+dI5swD1+omNHneKtJgThPzt3z+a6zgCfryKXerEk+I=;
        b=idNdqLJ5xaq15aSjjolR3prjX80o+j0Cg6zrvlekDugG2IOjPN/s4ENow/+Q69g13K
         OMPeYSA0AtC0J7HHKTZ8ZUNxXOl/z3sRa6HFtQ4TwP3hSkaEDUMYk6xFV2GAj7yhApLT
         nIx5TswdAEdtCGl+GBtDhoWLr3fo0D/6L0edc7eKfWDUsCpibn1k3430kkR1/IbIJlrT
         2Qw2gxeA8F65dqUqOiX4g3l964n95dPm8dD3mHvYXMEEVlWAmXnlqbNA2gNgxrT5EOVs
         D68jI1XQnJnKgzR7hVkP3g1c/sSI32VF7m+vZWo2+HP/ftjViSQD2qHHj98UEvabQAss
         lOFA==
X-Gm-Message-State: APjAAAX9GqNMzHfR52TrwX50wR0qwoy7QomoMkZK77N72IIqdAqCTQxw
        SsVNFjrhn0qzMixxJUm5f36isA==
X-Google-Smtp-Source: APXvYqyJ6WKaIp3QZZDTH+D57pYIq7W1ryRZeSCGj3dL0yG9QANxq3U1mGe4wfmVIuc6w/W6v3LRNg==
X-Received: by 2002:a62:1483:: with SMTP id 125mr53844216pfu.137.1559834390511;
        Thu, 06 Jun 2019 08:19:50 -0700 (PDT)
Received: from brauner.io ([172.56.30.175])
        by smtp.gmail.com with ESMTPSA id i5sm4103104pfk.49.2019.06.06.08.19.42
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 06 Jun 2019 08:19:49 -0700 (PDT)
Date:   Thu, 6 Jun 2019 17:19:39 +0200
From:   Christian Brauner <christian@brauner.io>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, tyhicks@canonical.com,
        pablo@netfilter.org, kadlec@blackhole.kfki.hu, fw@strlen.de,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        linux-kernel@vger.kernel.org, richardrose@google.com,
        vapier@chromium.org, bhthompson@google.com, smbarber@chromium.org,
        joelhockey@chromium.org, ueberall@themenzentrisch.de
Subject: Re: [PATCH RESEND net-next 1/2] br_netfilter: add struct netns_brnf
Message-ID: <20190606151937.mdpalfk7urvv74ub@brauner.io>
References: <20190606114142.15972-1-christian@brauner.io>
 <20190606114142.15972-2-christian@brauner.io>
 <20190606081440.61ea1c62@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190606081440.61ea1c62@hermes.lan>
User-Agent: NeoMutt/20180716
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jun 06, 2019 at 08:14:40AM -0700, Stephen Hemminger wrote:
> On Thu,  6 Jun 2019 13:41:41 +0200
> Christian Brauner <christian@brauner.io> wrote:
> 
> > +struct netns_brnf {
> > +#ifdef CONFIG_SYSCTL
> > +	struct ctl_table_header *ctl_hdr;
> > +#endif
> > +
> > +	/* default value is 1 */
> > +	int call_iptables;
> > +	int call_ip6tables;
> > +	int call_arptables;
> > +
> > +	/* default value is 0 */
> > +	int filter_vlan_tagged;
> > +	int filter_pppoe_tagged;
> > +	int pass_vlan_indev;
> > +};
> 
> Do you really need to waste four bytes for each
> flag value. If you use a u8 that would work just as well.

I think we had discussed something like this but the problem why we
can't do this stems from how the sysctl-table stuff is implemented.
I distinctly remember that it couldn't be done with a flag due to that.

Christian
