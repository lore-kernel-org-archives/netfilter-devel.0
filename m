Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD5540BE2
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Mar 2024 14:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710166381; cv=none; b=p82TpBnkm1ox/D14ev5fEJzkd7Jz784kt+SYDr/QqIpxeJQsYvm3UpPHSBFkpXZsjJf7aWxST9lDqkNvpZ0YH6u9jvP1PmyEdjRiZHJZd0pK3HFD0jGfS+17bMlUxLriyUZWFpoU7B3UyHObuv6FNP01XR5Bf0NwNLYV3vjBQQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710166381; c=relaxed/simple;
	bh=H1FYnbVh4avzCb4o5LGsnRS7/3CPqynRBCOpw0ccCPg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nbHifgvJHg/UH3RjJOB4fqnbEODrk9DVTU3AgMvrkaYTJXFmTzPuhdxW+gThB5GbEU8F/5UpkTjMtb4S/Lze5xNi2GqYIsaeOiJISft0nr/Jy8bPYy9HRiBOKdAIeCSr50NrIhgqrzpomsJXhSHpI1QvyzPZaIK1iBUqA7kzIrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Olokc9PX; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Olokc9PX"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-6e5dddd3b95so3184632b3a.1
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Mar 2024 07:13:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710166379; x=1710771179; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dvvIahFluMLJHAzJifRcoktLcSWsgLsoBFuiNFgejw0=;
        b=Olokc9PXVC+gjlsqPdexzL7MiQaTZfPSG6VFCGOK1/vJOl2tvqEo5+/yrqCx+ER4Qb
         vBOzXjIxZBh38F5jFcbStjuT1QkBMLeYwqk1MwiDUqU4PN4vxGOBaPaD2fxO6IIO5vYV
         HcWWR6ETsDe9YKaMhj6MhgTyNaNuj9ft5BvxgGQ1di3uRhVsn8btTlb1PEpsc1GgacI+
         i+ehJR8ReBhEfZy71CZMwpW9V27E9FE0cg8tOKYJzMNEoeVHbpfbg498VlA/U6rJc3m9
         +WIzSiY1AJzOajvQber1/aJgBGE4SYEtu2Szp9qTpO4tO7NHe5xNdbpI3TbZBjrV4dKp
         T1tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710166379; x=1710771179;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dvvIahFluMLJHAzJifRcoktLcSWsgLsoBFuiNFgejw0=;
        b=Jmtg1Wvne171j8WGCM7/yv5DOtxyoOfA3eMJrTQmky6R6OOIWzsxN5eEXWxmAIcjyn
         uETgje3JkFk1DCVVJX0MNbqXXxRJ25GlaJwsTqVW+kNfKg5ws+0WIC+1P+avHbDTXoMD
         gGnFUoRgCtkcRC27phOW3XJLoR5kfF42n7l1RXLTIBfiM5U8cxGGIvkcBnJmhvPQk+QX
         WgjASlkOI2wzOOgrHDJKWcwAl/TkBSuVFtZydKQsKMXBlPcuQKLkiXN8Q9HXwFrp1jbw
         jukf3VJaAccRAfVvWW2HzPNZGgDd7F3AovGl5HGvMs+vuVXZKvmrTypryv4PD6j/5Sqz
         CM5w==
X-Gm-Message-State: AOJu0YyY7PT6w1kwGJr/smuDBiOECJ51b3E5TmUK0sGFEjoIG5qJc4is
	FRSNUjeOz8kSC2v2e2ylv1UKR6FMA8BfBo/pZLLMdGl5VpYlXYfRTGEFANfMItf/tEI9
X-Google-Smtp-Source: AGHT+IEJ5HeKHddC3Sqbs5Vja9MGh1QXOJJSh/U7RxsVZ74lFaoAkH4xLy6SmG1cCaeSv0eyxQ9MxQ==
X-Received: by 2002:a05:6a20:1589:b0:1a1:67c0:c751 with SMTP id h9-20020a056a20158900b001a167c0c751mr9201221pzj.17.1710166379427;
        Mon, 11 Mar 2024 07:12:59 -0700 (PDT)
Received: from ubuntu-1-2 (ec2-52-199-81-84.ap-northeast-1.compute.amazonaws.com. [52.199.81.84])
        by smtp.gmail.com with ESMTPSA id v17-20020a056a00149100b006e69c942631sm604036pfu.108.2024.03.11.07.12.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Mar 2024 07:12:58 -0700 (PDT)
Date: Mon, 11 Mar 2024 22:12:48 +0800
From: Quan Tian <tianquan23@gmail.com>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org,
	kadlec@netfilter.org, tianquan23@gmail.com
Subject: Re: [PATCH v2 nf-next 2/2] netfilter: nf_tables: support updating
 userdata for nft_table
Message-ID: <Ze8RYCbmSgISYCb5@ubuntu-1-2>
References: <20240310172825.10582-1-tianquan23@gmail.com>
 <20240310172825.10582-2-tianquan23@gmail.com>
 <20240310174754.GA16724@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240310174754.GA16724@breakpoint.cc>

Hi Florian,

Thanks a lot for your reviews.

On Sun, Mar 10, 2024 at 06:47:54PM +0100, Florian Westphal wrote:
> Quan Tian <tianquan23@gmail.com> wrote:
> > @@ -10129,14 +10154,12 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
> >  		switch (trans->msg_type) {
> >  		case NFT_MSG_NEWTABLE:
> >  			if (nft_trans_table_update(trans)) {
> > -				if (!(trans->ctx.table->flags & __NFT_TABLE_F_UPDATE)) {
> > -					nft_trans_destroy(trans);
> > -					break;
> > +				if (trans->ctx.table->flags & __NFT_TABLE_F_UPDATE) {
> > +					if (trans->ctx.table->flags & NFT_TABLE_F_DORMANT)
> > +						nf_tables_table_disable(net, trans->ctx.table);
> > +					trans->ctx.table->flags &= ~__NFT_TABLE_F_UPDATE;
> >  				}
> > -				if (trans->ctx.table->flags & NFT_TABLE_F_DORMANT)
> > -					nf_tables_table_disable(net, trans->ctx.table);
> > -
> > -				trans->ctx.table->flags &= ~__NFT_TABLE_F_UPDATE;
> > +				swap(trans->ctx.table->udata, nft_trans_table_udata(trans));
> >  			} else {
> >  				nft_clear(net, trans->ctx.table);
> >  			}
> 
> There is a call to nft_trans_destroy() below here.
> You could add a "break" after the swap() to avoid it.
> 
> Otherwise kmemleak should report old udata being lost
> on update.

Thanks for pointing it out. kmemleak indeed reported the leak.
I found "break" after swap() would skip sending the table update event,
so I changed to execute different code paths for the two branches in v3.
Please let me know if it makes sense to you.

Thanks,
Quan
