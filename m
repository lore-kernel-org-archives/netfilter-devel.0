Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E86459475
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Mar 2024 01:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710293723; cv=none; b=PYXMFo0Fq2qJjbMKQFJ0EuIlScwFqUeUSmTLbBv/bhf+BdMz2HX+YdlqXTgN7QBiJ67BY53QU+43V9Xt+aDUuiP2SlFvSWuXuoEEYOyqlGMv2dRdrgOGnrsfa5zBns+LPgZ/vH4rC401RLxU/3FN/tpkK77auJ0o2t1xEOzzyGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710293723; c=relaxed/simple;
	bh=lqJqaIyiRSAdBO9sJ5I6M2LwbrEMfV0YSvl7L4pDAeg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ElG4PWudQ8pIvpyXXcutkz8KfDsGp5uIBfd2e3ZoIPaBzvF+UCtfBvUmO7GWuUEBtV5Bb/uSR5+ETPeIcRS5YK7YjDMOE6GGnLRE3T/5z8jxRKoHqg4nu9468ScIAbz84rBvgnpbU3cBPZHUBL74f4B8S2blzYsUWjND3rbY0dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jA7rAwJ5; arc=none smtp.client-ip=209.85.160.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jA7rAwJ5"
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-221ffba5c8bso1601300fac.1
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Mar 2024 18:35:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710293721; x=1710898521; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=odn2bwjQOzf+f2xnfWyZbRl3s6wvlDiTGuptuFfI7AQ=;
        b=jA7rAwJ5zrGdUnI6qVVAxerTqJpBJujE0j1WfFEM6vXv7NlYUgCbbxclsL/+lRW2QQ
         cOIqxLCRAHT3WrhCBOOZOSonHcR3nRmXUfyUpAkiTSrRv4Wut3zdEoMZq9ob4yNtVQ+8
         vxKVx5RpvCkrK9h8Lpo7fo4YbOA9C6LgJ74NpfaM4322ETu+AGipOgszh4hQnsU04cRA
         R0bwUqCuikGforMRJSkq0UeOw7/Rug7kOrpzBadpF1mTDBxjeWLWGTSJfo0SyFh6Q1E6
         tNbkRQZYbBUtzDSNgze9AxLzVkcpr99K910TgW408/rvsJGmAej0aFtDZQUHiEVdg/hd
         ZT/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710293721; x=1710898521;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=odn2bwjQOzf+f2xnfWyZbRl3s6wvlDiTGuptuFfI7AQ=;
        b=vwZC3fe2w29RB2dvYGlGi9ft2k37EDkJ9ellON0i/H3rDA6E8qUKFGDlxABuoUq8de
         CqAwQry+Jp8qpNBckmGUyR0SZThNbI8pGC90gSanPb9SRMXlgaBnuLqxlET0T037/AyH
         Bn6i5gtAiokURexOtO/WW4CORTDbsyNBr77SqjAhC9RRQ7MXTUVPPt99Ik/oh1g/N4CB
         0sBkrvvTFoeud5oAYb15hbzcDqoSYAQ7FK42ZE4AONSB3WKM4NvDBjdfVe4wwvFtpxIH
         kuhJJCPEsNGwrZxAmihV1i5P2XQzckgUkv9vsu4zxyuE0CqkVnrM8eyJ9MzxCBtrKE9/
         h6cA==
X-Forwarded-Encrypted: i=1; AJvYcCU+IpY7VS9Qc3XRj8VPdYlFx0bKd1/ijBK5OGSpJqCEcRj5RsC97TEGtcqDxI0gaxSOjBERW0XZj/3LZ2zWGQYLZwGbFZz3jHYdEMEd39SG
X-Gm-Message-State: AOJu0Yz8DRlHaeVNAyAq4NwLm+ahUhn8Ak4lFVM70iHFXL5GxOC+jgm7
	FgR145G+s66gQZHyZMh4JkJMWRAVNmAzrL3C7fVID3Bwd37wylr7
X-Google-Smtp-Source: AGHT+IH7xCIVK2AfAKBIiTdupA2Z7P7Fs7dgMhQX/CqpJDo/gJdkDXyNbKj2Y1W6KkMK2EAuOAfzNA==
X-Received: by 2002:a05:6871:14f:b0:21e:b98f:4501 with SMTP id z15-20020a056871014f00b0021eb98f4501mr12910732oab.22.1710293720884;
        Tue, 12 Mar 2024 18:35:20 -0700 (PDT)
Received: from ubuntu-1-2 (ec2-52-199-81-84.ap-northeast-1.compute.amazonaws.com. [52.199.81.84])
        by smtp.gmail.com with ESMTPSA id c12-20020a62f84c000000b006e67edb113fsm6078066pfm.219.2024.03.12.18.35.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Mar 2024 18:35:20 -0700 (PDT)
Date: Wed, 13 Mar 2024 09:35:10 +0800
From: Quan Tian <tianquan23@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	kadlec@netfilter.org, tianquan23@gmail.com
Subject: Re: [PATCH v3 nf-next 2/2] netfilter: nf_tables: support updating
 userdata for nft_table
Message-ID: <ZfECzgo/mYkMvHXA@ubuntu-1-2>
References: <20240311141454.31537-1-tianquan23@gmail.com>
 <20240311141454.31537-2-tianquan23@gmail.com>
 <20240312122758.GB2899@breakpoint.cc>
 <ZfBO8JSzsdeDpLrR@calendula>
 <20240312130134.GC2899@breakpoint.cc>
 <ZfBmCbGamurxXE5U@ubuntu-1-2>
 <20240312143300.GF1529@breakpoint.cc>
 <ZfDV_AedKO-Si4-_@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZfDV_AedKO-Si4-_@calendula>

On Tue, Mar 12, 2024 at 11:23:56PM +0100, Pablo Neira Ayuso wrote:
> On Tue, Mar 12, 2024 at 03:33:00PM +0100, Florian Westphal wrote:
> > Quan Tian <tianquan23@gmail.com> wrote:
> > > In nf_tables_commit():
> > > The 1st trans swaps old udata with 1st new udata;
> > > The 2nd trans swaps 1st new udata with 2nd new udata.
> > > 
> > > In nft_commit_release():
> > > The 1st trans frees old udata;
> > > The 2nd trans frees 1st new udata.
> > > 
> > > So multiple udata requests in a batch could work?
> > 
> > Yes, it could work indeed but we got bitten by
> > subtle bugs with back-to-back updates.
> 
> yes, we have seen subtle bugs recently. As for the table flags, the
> dormant flag has been particularly a problem, it is tricky one because
> it registers hooks from preparation step (which might fail) but it
> cannot register hooks because abort path might need undo things, and
> re-register the hooks could lead to failures from a later path which
> does not admit failures. For the dormant flag, another possibility
> would be to handle this from the core, so there is no need to register
> and unregister hooks, instead simply set them as inactive.
> 
> The dormant flag use case is rather corner case, but hardware offload
> will require sooner or later a mode to run in _hardware mode only_
> (currently it is both hardware and software for nftables) and
> considering the hardware offload API has been designed for packet
> classifiers from the late 90s (that is, very strictly express your
> policy in a linear ruleset) that means dropping packets early is fine,
> but wanted traffic gets evaluated in a linear list.
> 
> > If there is a simple way to detect and reject
> > this then I believe its better to disallow it.
> 
> That requires to iterate over the list of transaction, or add some
> kind of flag to reject this.
> 
> > Unless you come up with a use-case where such back-to-back
> > udate updates make sense of course.
> 
> I don't have a use-case for this table userdata myself, this is
> currently only used to store comments by userspace, why someone would
> be willing to update such comment associated to a table, I don't know.

There was a use-case in kube-proxy that we wanted to use comment to
store version/compatibility information so we could know whether it
has to recreate the whole table when upgrading to a new version due to
incompatible chain/rule changes (e.g. a chain's hook and priority is
changed). The reason why we wanted to avoid recreating the whole table
when it doesn't have to is because deleting the table would also
destory the dynamic sets in the table, losing some data.

Another minor reason is that the comments could be used to store
human-readable explanation for the objects. And they may be change when
the objects' functions change. It would be great if they could be
updated via the "add" operation, otherwise "delete+add" would always be
needed to keep comments up-to-date.

However, I don't know a use-case for back-to-back comment updates, I 
will check which one is more complex and risky: rejecting it or
supporting it.

> I would like to know if there are plans to submit similar patches for
> other objects. As for sets, this needs to be careful because userdata
> contains the set description.

As explained above, I think there is some value in supporting comment
update for other objects, especially when the objects contain dynamic
data. But I understand there are risks like you mentioned and it would
need to be more careful than tables. I would volunteer to take a try
for other objects, starting with objects similiar to tables first, if
it doesn’t sound bad to you. Please let me know if you feel it's not
worth.

Thanks,
Quan
