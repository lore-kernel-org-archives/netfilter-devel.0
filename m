Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kI9BDebq"
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C18BC4
	for <netfilter-devel@vger.kernel.org>; Sat,  9 Dec 2023 19:25:30 -0800 (PST)
Received: by mail-oi1-x22b.google.com with SMTP id 5614622812f47-3b9d8bfe845so2592167b6e.0
        for <netfilter-devel@vger.kernel.org>; Sat, 09 Dec 2023 19:25:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702178729; x=1702783529; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rKTYKdg2JoHMmnRxWYEQg2JLBwETbu9sVxREX6CemFY=;
        b=kI9BDebq4LH8xRP+2KAaQdRs2bfjkzu3VyI0ychLfb52gtnp0Mg5lVGMzNYAO70ffT
         F52nLICuvKnAPH9lMVQwFEfIBYZZqXyJEHlzd2UT0NvKcbzjQ6wRKSKfVVgMWRrNRJEP
         wAI9q08eJaOkLWMBl/fWvHAxoRmWdTDHFT2eEVIiDJbJmfDsFFH5wmLscytaBNklcC1I
         lQ8BEJNqNlFyy81w1wnSCh42GFYt+TEUNVMBbVcikeoVXtofaGCGmTFEG9aiadtbqnJ2
         L2hc88fhmPXkOQ3FeSeLpH4kEx3rXiLdcVXmoyoTtmqLgsZV4mcrRSorAtLicFmPT62D
         iNvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702178729; x=1702783529;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rKTYKdg2JoHMmnRxWYEQg2JLBwETbu9sVxREX6CemFY=;
        b=fwxd/n0FtcEOqYK+XfOqsdWG9KhpM/Ib1pLRRCN5V23jdELJw9tidoVHD3UxQB9lWO
         U0xDn4a0Xus+PmpnpaFpI92nWi6CTmjRFXFBk3/L4w1UKeYoyWL53IiAMt5qmNK6MIoT
         sjh3IdeaLsBcEVtfr35AqZUSWiKoinJ8UemTtJHtqeCuo1qJqjvAAlxnT/RZbqBHfvwa
         1IM2BzHxDV3l9jn5TuZYmT2LhPpaFm8eHWkSIclJau6WiIPehUVrclMjEplsVCSlJ0i3
         vpV5sI3W1Hivz6nDqPunZXuD2ohAtL1DnovjNZOtZc5xha2n1u+86FRHZi6f4b4uGtbi
         ozFA==
X-Gm-Message-State: AOJu0YzSu4NuOW45eY76HTyL8fqUVcSjmPZh7Dtq9WyhpjheV6mNwqvE
	Mik7AnOk1b6iav20nQZqDNFzmXs2re4=
X-Google-Smtp-Source: AGHT+IE4oiCurh1YCfqqGo2Dpiv9cPJuelm3g6d+WPwyEkxFMmdzqw+/Jc2oslxRFzfXsaJW5Acx7w==
X-Received: by 2002:a05:6808:3c48:b0:3b9:e75f:e7b3 with SMTP id gl8-20020a0568083c4800b003b9e75fe7b3mr3721527oib.64.1702178729318;
        Sat, 09 Dec 2023 19:25:29 -0800 (PST)
Received: from slk15.local.net (n58-108-90-185.meb1.vic.optusnet.com.au. [58.108.90.185])
        by smtp.gmail.com with ESMTPSA id j3-20020a170902c08300b001d0b3c4f5fbsm4078243pld.63.2023.12.09.19.25.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Dec 2023 19:25:28 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date: Sun, 10 Dec 2023 14:25:25 +1100
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: This didn't make it into patchwork
Message-ID: <ZXUvpQiLmxZPHtSm@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20231209023020.5534-1-duncan_roe@optusnet.com.au>
 <20231209023020.5534-2-duncan_roe@optusnet.com.au>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231209023020.5534-2-duncan_roe@optusnet.com.au>

Hi Pablo,

Have you ant idea why Patchwork didn't pick up this patch?

Please apply anyway.

Cheers ... Duncan.
On Sat, Dec 09, 2023 at 01:30:20PM +1100, Duncan Roe wrote:
> i.e. this one:
> > -^I^I^I          struct nfq_data *nfad, char *name);$
> > +^I^I^I^I  struct nfq_data *nfad, char *name);$
>
> Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> ---
>  include/libnetfilter_queue/libnetfilter_queue.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/libnetfilter_queue/libnetfilter_queue.h b/include/libnetfilter_queue/libnetfilter_queue.h
> index f254984..f7e68d8 100644
> --- a/include/libnetfilter_queue/libnetfilter_queue.h
> +++ b/include/libnetfilter_queue/libnetfilter_queue.h
> @@ -111,7 +111,7 @@ extern int nfq_get_secctx(struct nfq_data *nfad, unsigned char **secdata);
>  extern int nfq_get_indev_name(struct nlif_handle *nlif_handle,
>  			      struct nfq_data *nfad, char *name);
>  extern int nfq_get_physindev_name(struct nlif_handle *nlif_handle,
> -			          struct nfq_data *nfad, char *name);
> +				  struct nfq_data *nfad, char *name);
>  extern int nfq_get_outdev_name(struct nlif_handle *nlif_handle,
>  			       struct nfq_data *nfad, char *name);
>  extern int nfq_get_physoutdev_name(struct nlif_handle *nlif_handle,
> --
> 2.35.8
>
>
