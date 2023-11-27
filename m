Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PWzpU33u"
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C32F1B8
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Nov 2023 15:26:02 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id 41be03b00d2f7-5a9bc2ec556so2920083a12.0
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Nov 2023 15:26:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701127561; x=1701732361; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C4Jv/tWKhGE+oj13ImCiceTMYt7jHCzTduyggJd9Rms=;
        b=PWzpU33ujva/EoKNORcRquLvK/ue/WjkUhHvOMeW8XE0HZXQ8OAHVeqIhPay06MgM5
         Obt+aSWMmqpWnaqMmjhduYxAoI4O4eZNwl9amXexHxPt6HVN9C6c2OLKRXuiNQYYQK34
         AbeKCiawQG0x+lyVuWwz7YSbyFGzZQ5yuQnWqfTnbCKDZPJr4pjVGPQaQm8ymgZOTtSU
         3nDwklyVn0GKYQKkwkgFRjm8X9yIjaHawmbBSRigFXHdB+301IFwvJEGTnEEBZ0rr8kU
         5qMBJ3dY9bI1pBcxmPu4ILBfMkKtCqZ6OYQny841qfwzfvq+rsX3s0jcaj6ljT8EohzD
         JhsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701127561; x=1701732361;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C4Jv/tWKhGE+oj13ImCiceTMYt7jHCzTduyggJd9Rms=;
        b=XHtPbIFyXn/XpMNIRpZW8/HLpeKKSXHvqnOZ4Bj8FNlVvGe+33yLICVFzVUwrC2iJW
         CK2PyF0XtXsZARZxZfZx4HJDCF9KoA9d7gKS5KWZt54+V6G/KnBt/gxcJPV4LtaVOMo4
         smgWpAY8fjMYXaVDh5JGvn/cdhfPno52p0BtHBik1eOfY9DJqL55LHSvk1/a3VQ//ZT3
         HSm4i5hvxyvjsPS85rIWxIDZw/QYXv3EYoBCftBy/ixf9GPhr2V4B/dKCfmViqM+CeN6
         0yRpt2gCbCmH9MdLjq5yQka70g8Mw6DTwAjOQ+q+SV0CwkYfYQAXXY67jVPFc6y7HpTz
         d4nw==
X-Gm-Message-State: AOJu0YxSokDqvAC2KHDvmQwBDzVNrld0fy/99u5NtNbq6mlvKjpjnDpU
	DcyJA9xTT/szpp8hyIBe9FNYavUinvU=
X-Google-Smtp-Source: AGHT+IG9VxX9mpT4iMqXf5f/AzUl3g+UoaQe8dQO4GmUDUo2ZTwlUnMxEoWdfzsZ53aUDVTWKr7FMg==
X-Received: by 2002:a17:90b:4f8e:b0:280:cc73:4c79 with SMTP id qe14-20020a17090b4f8e00b00280cc734c79mr12808772pjb.7.1701127561606;
        Mon, 27 Nov 2023 15:26:01 -0800 (PST)
Received: from slk15.local.net (n58-108-90-185.meb1.vic.optusnet.com.au. [58.108.90.185])
        by smtp.gmail.com with ESMTPSA id 11-20020a17090a004b00b00285cee21489sm2556259pjb.1.2023.11.27.15.25.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Nov 2023 15:26:01 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date: Tue, 28 Nov 2023 10:25:57 +1100
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue v3 0/1] New example program nfq6
Message-ID: <ZWUlhePUtgFDxn5h@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20231126061359.17332-1-duncan_roe@optusnet.com.au>
 <ZWSSTNYrVsJO7qeE@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZWSSTNYrVsJO7qeE@calendula>

On Mon, Nov 27, 2023 at 01:57:48PM +0100, Pablo Neira Ayuso wrote:
> On Sun, Nov 26, 2023 at 05:13:58PM +1100, Duncan Roe wrote:
> > Hi Pablo,
> >
> > I've been using nfq6 as a patch testbed for some time.
>
> Thanks for offering. Please find an alternative spot to store this
> file, you can write a webpage and documentation for ti, this does not
> really need to be in libnetfilter_queue.
>
And link to it from the Main page? I don't have a website, would have to be a
link to GitHub, but I could put more in README.md there.
