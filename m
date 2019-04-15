Return-Path: <SRS0=sICu=SR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4487C10F0E
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 14:04:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B4262087C
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 14:04:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727371AbfDOOEJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Apr 2019 10:04:09 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:45174 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727218AbfDOOEJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Apr 2019 10:04:09 -0400
Received: by mail-qt1-f196.google.com with SMTP id v20so19143786qtv.12
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Apr 2019 07:04:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=RWQhqEIQNoG/VFR9P0w3HyIne3Or3WL2bbxC1JNZrS0=;
        b=AiZYG7JRwMk3GhohmRtDNHOE2JNzuu+oXAlOeKwithEhb41PQDn2oTK/l8WkcEgBhd
         A9e0jfwxr7tIxP7t6qpcWqdxQ11eah3vAFU010GisY3a8cFHDQJ6UK6os/iNlVwvxKgm
         xj1n/DaEOF+eAgAm4L31GKTXuPQ57xB8gesYurBdPWdnDiptioFWHj9wLwxGtM3WZN7k
         PY43wYPo8JgD/V/Er93dKxyw1/epUA1wSX90b1yDWuxCbcc+xsaIMMWWPIq/KuBc5jr0
         Ine8CFZALc3ZxezmNftq2V0LmV8nCAR/7snMOJkFVb3SiB0+WRcx8qYgiM+anEk6Lk+k
         rKlQ==
X-Gm-Message-State: APjAAAVvt9GZsky1NxL6TXXMbkOIUA1+ZANe0AjRCZpRqnVFDnyv90UP
        ek71M4Xw/arhA3q7XPkpLvqvqA==
X-Google-Smtp-Source: APXvYqwFhGpx1V6KwD8+/EE/WXY4+qGNVXvP1J5M7YTTokz5wtXK2Bu+wOLgsO7mjRpjy0eBXH94og==
X-Received: by 2002:ac8:2a2e:: with SMTP id k43mr61821212qtk.353.1555337047899;
        Mon, 15 Apr 2019 07:04:07 -0700 (PDT)
Received: from localhost ([177.183.215.200])
        by smtp.gmail.com with ESMTPSA id 46sm35375494qtz.87.2019.04.15.07.04.06
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 15 Apr 2019 07:04:07 -0700 (PDT)
Date:   Mon, 15 Apr 2019 11:04:04 -0300
From:   Flavio Leitner <fbl@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netdev@vger.kernel.org, Joe Stringer <joe@ovn.org>,
        Pravin B Shelar <pshelar@ovn.org>, dev@openvswitch.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/8] netfilter: add API to manage NAT helpers.
Message-ID: <20190415140404.GF3319@p50.lan>
References: <20190413231716.28711-1-fbl@redhat.com>
 <20190413231716.28711-3-fbl@redhat.com>
 <20190415054820.p2vbw7itmr7gwmq5@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190415054820.p2vbw7itmr7gwmq5@salvia>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Apr 15, 2019 at 07:48:20AM +0200, Pablo Neira Ayuso wrote:
> Sorry I didn't see this in the first review.
> 
> On Sat, Apr 13, 2019 at 08:17:10PM -0300, Flavio Leitner wrote:
> [...]
> > +int
> > +nf_nat_helper_try_module_get(const char *name, u16 l3num, u8 protonum)
> > +{
> > +	struct nf_conntrack_helper *h;
> > +	struct nf_conntrack_nat_helper *nat;
> > +	char mod_name[NF_CT_HELPER_NAME_LEN];
> > +	int ret = 0;
> > +
> > +	rcu_read_lock();
> > +	h = __nf_conntrack_helper_find(name, l3num, protonum);
> > +	if (h == NULL) {
> > +		rcu_read_unlock();
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (!strlen(h->nat_mod_name)) {
> > +		rcu_read_unlock();
> > +		return -EOPNOTSUPP;
> 
> Probably check for this at registration?

I thought to have a list of all helpers in use and then use
nat_mod_name to indicate if a NAT helper is supported or not.
I will change that to list only ones with NAT helper available
as I don't have a strong preference.

> > +	}
> > +
> > +	nat = nf_conntrack_nat_helper_find(h->nat_mod_name);
> > +	if (nat == NULL) {
> > +		snprintf(mod_name, sizeof(mod_name), "%s", h->nat_mod_name);
> > +		rcu_read_unlock();
> > +		ret = request_module(mod_name);
> > +		if (ret != 0)
> > +			return ret;
> 
> Not sure it is worth checking for request_module() return value, the
> code just below already is doing this.

Well, the above returns a more accurate error which helps
debugging/tracing problems. But since you said that, I checked
other cases calling request_module() and I am going to fix the
above.

> > +
> > +		rcu_read_lock();
> > +		nat = nf_conntrack_nat_helper_find(mod_name);
> > +		if (nat == NULL) {
> > +			rcu_read_unlock();
> > +			return -EINVAL;
> 
> ENOENT?

Makes sense.


> > +		}
> > +	}
> > +
> > +	if (!try_module_get(nat->module))
> > +		ret = -EINVAL;
> 
> ENOENT?
>
> Telling this because we will at some point propagate this error value
> to userspace by when we start using this infrastructure you're working
> on. EINVAL is already very overload in netlink and we'll use it from
> there.

Sounds good, thanks for the review!
fbl


> 
> > +
> > +	rcu_read_unlock();
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(nf_nat_helper_try_module_get);
