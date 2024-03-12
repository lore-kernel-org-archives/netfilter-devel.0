Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D07937D06F
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Mar 2024 15:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710255822; cv=none; b=MnKL2xIWY4utk3lw6DjB21CQhyqMw9EWYfEDwgR27p1GiH0KHb9zk2nMuaDRqMKtc8ETT9ss+RHBjnkBfHn0c2HuTyHDR5C1ROohfssn5BPKbefbOzWuNkkXDeQpHbOcqw4hHvDQFIfxtXFkvEHvjfa1qfLgm93e2rec1DH4Jck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710255822; c=relaxed/simple;
	bh=cXcslb/LIxzutihiHWrgCNxsuTfY0EBrRLTpg1uRoa4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MuR89hifXFb65FgrZ2Vm0IBkURF+YyMtsK8FJKC0vqBrwqV7SXUzKLq7xji+RSF3mJsh0/rrKgvKDTZFE82b8dDoYDKCw9RnfAIPcp+waypbzw5oQkYzW3MBe8loCJprfIB9GLpMo2TnkfjDf0mTDS3f3jlfba3Bq9scNYePP7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ThCmtaRj; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ThCmtaRj"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1dc49b00bdbso33088945ad.3
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Mar 2024 08:03:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710255820; x=1710860620; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EnVh247TCXINlyBtUZCvJ7R/gPYQJx4JOaUzAu1dcFc=;
        b=ThCmtaRjVLv76NoX0ly7KDaQjMHYjH8MdS15AbSOoUfgbCmwlAfp59FjyAniDUlVLh
         7CaLouW/MqEWeoINrZwL6GEEatCBRpC0kzu1IDSLhlJE9ULZQ/yHgvxRyl8jNAk4pYGl
         aAhRg9Rz384dT2FXwQsVD1F1sT3kjW2GO5wE/f3NSH6QjA4gOibZtplkddq8fNDBslLq
         i0qtBktXv6xD2aTbRd02NHbGGBiVKb2i9lzWpky4cNsomIl7SzF+0GgA6UL7Z+c4S1XW
         K27SmDQnUAWpj2Qw4CWw1UMq7BAMdDzMeL/6z96bKkHmEpYN/i/sMHmw/YsrhVIyMSDw
         dNxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710255820; x=1710860620;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EnVh247TCXINlyBtUZCvJ7R/gPYQJx4JOaUzAu1dcFc=;
        b=lKj8kCIs0nBlmpI8QyCOLSA4cEvWIpd2pFtjpkQV9fQ2StW4yAYQ3YwytnOyLIKJH1
         AOqLehj0IrDHsEpwCCBaSEu33ORmUfmwPDg12Y1kQuRl4/DXi301wn7TsMtKqEFThRBT
         XKiR+stEXmoKuiEg5L291bM/YbiIkvpj2B8WVDVElGShIjkhsC5ugxrR0pg0sbHRVeFO
         CVe3Nguhg4v4Cx6O8ZHjsnfxiby6Clka0mapZAQUxzpFm4JNWIlYNCTHHKNq4arjtwFX
         atvSWX0wpDa54z/2mF+h9qoATmQvpVzfqBzMSyKlIrmZ0qS6t7gL4j4fiRoQcLS4DwyV
         9E1w==
X-Forwarded-Encrypted: i=1; AJvYcCV0wEjW3e2tQBASvhwvhIEd+eSt+kobM20lekIZb6M6wNY3dwZeJGc3CSOY7/7cikdNL06/SJM41Q4AhJcrbXWRo4QflzJSJaaoGjLWZv/U
X-Gm-Message-State: AOJu0YxIU+Luo4lmI0BOJfee7/A0j+xtrMZXv5uTpdXG5fU/1r4RylSb
	q7VJCwu84LqTUawEDOORGb48ryCLGJJCZKOmItjDqptmPFSDA3gv
X-Google-Smtp-Source: AGHT+IGbLe0NXIrYD+9Vt03Tv0Rs7WzzfMvrIpLxM2G9RLuVUKNVBxYeaJdKwZ4ecAQSR1SpdDjlIw==
X-Received: by 2002:a17:902:b601:b0:1dc:16:9000 with SMTP id b1-20020a170902b60100b001dc00169000mr8332369pls.16.1710255820041;
        Tue, 12 Mar 2024 08:03:40 -0700 (PDT)
Received: from ubuntu-1-2 (ec2-52-199-81-84.ap-northeast-1.compute.amazonaws.com. [52.199.81.84])
        by smtp.gmail.com with ESMTPSA id b4-20020a170902d50400b001dce6c481c1sm3131105plg.301.2024.03.12.08.03.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Mar 2024 08:03:39 -0700 (PDT)
Date: Tue, 12 Mar 2024 23:03:33 +0800
From: Quan Tian <tianquan23@gmail.com>
To: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Cc: tianquan23@gmail.com, netfilter-devel@vger.kernel.org,
	kadlec@netfilter.org
Subject: Re: [PATCH v3 nf-next 1/2] netfilter: nf_tables: use struct nlattr *
 to store userdata for nft_table
Message-ID: <ZfBuxfwISni2TaW1@ubuntu-1-2>
References: <20240311141454.31537-1-tianquan23@gmail.com>
 <20240312140535.GC1529@breakpoint.cc>
 <ZfBkB3VcbfzZe0fw@calendula>
 <20240312143444.GG1529@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240312143444.GG1529@breakpoint.cc>

On Tue, Mar 12, 2024 at 03:34:44PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > +	struct nlattr			*udata;
> > 
> > May I suggest to use our own data structure, instead of using nlattr?
> > It is just a bit misleading to the reader.
> > 
> > But maybe I need to get used to this and that's all, your call.
> 
> I have no preference.  I thought reusing nlattr was simpler
> because you can just kmemdup the nlattr+header.
> 
> I'll leave it up to patch author, no strong opinion either.

I found an existing struct nft_userdata defined in nf_tables.h and used
by nft_rule. Perhaps I could reuse it for nft_table? Its struct is as
below:

struct nft_userdata {
	u8			len;
	unsigned char		data[];
};
