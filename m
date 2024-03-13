Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61E2A1A38FC
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Mar 2024 17:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710349747; cv=none; b=U8W341KFd2pu6SiqLqT7OutdshYcteG1Ld5XtuLxMh5LmJbkxneX/rfxNZwGi67afiPL8lMDAdGUrEciIy49uiyhJV19HRJ5QBcQzNOBnb0x3U5wyYwnnYgH3FFvvZvYaE9SgxKKmvf4WQ6V9Le2+kkeWOSxpUZNwJTYYXtVpXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710349747; c=relaxed/simple;
	bh=1rGKcOg5K4Ot3Zs6iTcrd8KDIYJh/TXE8/LnYr5l4hQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U+lIDiN08Z9Ls68irxl57kuUGMT5mkQNBlJtkREOUOb9UA+aIS+Z1nl67PFRTmi3Hu4KGqiq5MrHDDvYReCa8S9Nu69l9q4tevBVtcCbpB37q6hCwR1ZxnO4Jhwf1twOvpdPk4dNOip0a1mFoVC40ihOWvJaUFlRNO15dCc1nGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QfYz6455; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QfYz6455"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-6e6082eab17so107156b3a.1
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Mar 2024 10:09:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710349746; x=1710954546; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hwiRlQ2osAintf2JMVa4ru1QZVf3FYMTsxXnaaIcT08=;
        b=QfYz64556LjwFvoHT08WU0l9ZL73r550ajtGflalSbDDXVPLoiXF5KQFP0uXqvr/CE
         ciF/dLnt5C1lPyCeoknUSYMxvcg9XtT5eWz8HmBg93Hl2eXE8nDBxTljK+9eMZCsfcDE
         J9TbyjE0MmMmcYND3Dj0tSOld25svCPP1XBEVbz5nyP7UtNKC2EViqKyVaC3bQrP/nsR
         3FrZ5F29b5gUQkAYtULW4xjt7P51iZTiQH75HsNQSxqJUpoxBw2t1WthKxsx/S3+71iV
         q2Xh78+ItFb/nGX5uH/Xm+pp/OQIVQYgi/B1nuMDrqgegXWjChBD4vxtlwGkMlZ8B4wL
         ir5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710349746; x=1710954546;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hwiRlQ2osAintf2JMVa4ru1QZVf3FYMTsxXnaaIcT08=;
        b=nHVXCDq5jlQ3vxQeQ950yendMcT9Ua1DIUyPt55fOo0+oPxfakfwPTekPPqJ6sgoga
         Te/9+nKnuFuxSGL++m83a1DBojZjqs/tSiWoZR9ZiUTQZ8HocQVR6K8dFOZoWn2FVZqB
         MTYIcTRyx34InFIdhLk/No5CyOPO65JnMZnJPmzzLx/uFaBzZ4+9GSj19VbbPzAYKFh0
         IMtTSg3mzwrSm/JLBWn9CxXqagSs8Q2r9pqh+fDKXCZYfda5/pvgo1kZK5L/oMN6Wpiz
         CYp5UVrSEkkDc9THBGdBOhQkb6p1+2BOuCFp1CpVZsuWwV/mlFLiyrcnUiu0xuHtw9Sa
         iIBA==
X-Forwarded-Encrypted: i=1; AJvYcCUlrXve2rBJttuoP59Nbb6/7SkAgU3Af28Ki8MPl1ypuSDiFJKmR3b7KI9KHzJmT0afacs1qI1B7yU3BI6Ql2OzhZdEhNteJ/hKDHOgMYL7
X-Gm-Message-State: AOJu0YzcMei7EX9FNxdffh+DgH6ojkU94HfRSr3hUh9h/o9/468esi3y
	5sriLeLHP9ZmSk1YoqUYqeZHc5miQOzQXMtiheqlMN2BZZHQAJRk
X-Google-Smtp-Source: AGHT+IFHLHJcUsoqVJObK4HKvXpUm7VT0sRr4VqruHDBUlkB7DgESf9rczuSKGn72RXchtil0KBkSg==
X-Received: by 2002:a05:6a00:23d2:b0:6e6:46f2:d4c8 with SMTP id g18-20020a056a0023d200b006e646f2d4c8mr3381608pfc.23.1710349745649;
        Wed, 13 Mar 2024 10:09:05 -0700 (PDT)
Received: from ubuntu-1-2 (ec2-52-199-81-84.ap-northeast-1.compute.amazonaws.com. [52.199.81.84])
        by smtp.gmail.com with ESMTPSA id a28-20020a056a0011dc00b006e56e5c09absm8442549pfu.14.2024.03.13.10.09.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Mar 2024 10:09:05 -0700 (PDT)
Date: Thu, 14 Mar 2024 01:08:55 +0800
From: Quan Tian <tianquan23@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: tianquan23@gmail.com, netfilter-devel@vger.kernel.org,
	kadlec@netfilter.org
Subject: Re: [PATCH v3 nf-next 2/2] netfilter: nf_tables: support updating
 userdata for nft_table
Message-ID: <ZfHdp/woz8DwGTYw@ubuntu-1-2>
References: <20240311141454.31537-1-tianquan23@gmail.com>
 <20240311141454.31537-2-tianquan23@gmail.com>
 <20240312122758.GB2899@breakpoint.cc>
 <ZfBO8JSzsdeDpLrR@calendula>
 <20240312130134.GC2899@breakpoint.cc>
 <ZfBmCbGamurxXE5U@ubuntu-1-2>
 <20240312143300.GF1529@breakpoint.cc>
 <ZfDV_AedKO-Si4-_@calendula>
 <ZfECzgo/mYkMvHXA@ubuntu-1-2>
 <ZfF0dQTCdg1z0-b5@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZfF0dQTCdg1z0-b5@calendula>

On Wed, Mar 13, 2024 at 10:40:05AM +0100, Pablo Neira Ayuso wrote:
> On Wed, Mar 13, 2024 at 09:35:10AM +0800, Quan Tian wrote:
> > On Tue, Mar 12, 2024 at 11:23:56PM +0100, Pablo Neira Ayuso wrote:
> [...]
> > > I don't have a use-case for this table userdata myself, this is
> > > currently only used to store comments by userspace, why someone would
> > > be willing to update such comment associated to a table, I don't know.
> > 
> > There was a use-case in kube-proxy that we wanted to use comment to
> > store version/compatibility information so we could know whether it
> > has to recreate the whole table when upgrading to a new version due to
> > incompatible chain/rule changes (e.g. a chain's hook and priority is
> > changed). The reason why we wanted to avoid recreating the whole table
> > when it doesn't have to is because deleting the table would also
> > destory the dynamic sets in the table, losing some data.
> 
> There is a generation number which gets bumped for each ruleset
> update which is currently global.
> 
> Would having such generation ID per table help or you need more
> flexibility in what needs to be stored in the userdata area?

Auto-increased generation ID may not meet the above requirement as the
table could also be frequently updated by configuration changes at
runtime, not only after the application upgrades. An example scenario
could be: say we have a loadbalancer application based on nftables:

* LB v0.1.0 installs a collection of nftable rules;
* LB v0.1.1 makes some changes compatible with v0.1.0. In upgrade case,
  it doesn't need to recreate the whole table if the existing rules
  were installed by version >= 0.1.0;
* LB v0.2.0 makes some changes incompatible with v0.1.x (e.g. some
  chains' priorities are changed), it needs to recreate the whole table
  when upgrading from v0.1.x to it;
* LB v0.2.1 makes some changes compatible with v0.2.0, it doesn't need
  to recreate the table when upgrading from v0.2.0 to it but needs to
  recreate it when upgrading from v0.1.x to it.

With the support for comment updates, we can store, get, and update
such version information in comment, and use it to determine when it's
necessary to recreate the table.

>> If there is a simple way to detect and reject
>> this then I believe its better to disallow it.
>
> That requires to iterate over the list of transaction, or add some
> kind of flag to reject this.

I tried to detect back-to-back userdata comment updates, but found it's
more complex than I thought. A flag may not work because it can only
tell whether the 1st update touched comment and we don't know whether
the 2nd update is the same as the 1st one, unless we iterate over the
list of transaction, which looks a bit overkill? It seems simpler if we
just allow it and accept the last userdata.

>> My question is, should we instead leave the existing udata as-is and not
>> support removal, only replace?
>
>I would leave it in place too if no _USERDATA is specified.

I got a question when trying to implementing this. If the update request
specifies USERDATA but its length is 0, do we treat it like not
specified, or remove the existing userdata? Asking because I see
nf_tables_newrule() treats 0 length in the same way as unspecified and
doesn't initialize a nft_userdata. It makes sense for create, but I'm
not sure if it's right to do it in the same way for update. 

And if we want to treat it as "remove comment", we can't simply add a
single pointer of nft_userdata to nft_trans_table to achieve it, because
there would be 3 cases: leave it in place, remove it, update it.

Thanks,
Quan
