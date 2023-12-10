Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JfNW5wFY"
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C158811A
	for <netfilter-devel@vger.kernel.org>; Sat,  9 Dec 2023 20:27:45 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id ca18e2360f4ac-7b435966249so147164139f.0
        for <netfilter-devel@vger.kernel.org>; Sat, 09 Dec 2023 20:27:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702182465; x=1702787265; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ch7OFojdNsq7E6Mol7uZzOwDj4a7N8ypU2/rCYP+N+E=;
        b=JfNW5wFYbxH7PpS8H1fWo/a5YNFsg+T6gykeILX+fZIDsWiUzbQidRouI/t4yEooXG
         bwEUA/r4y8bUSxmGx2l87GgznkNPHMiAKLOBilL9b0gXNo8Gp24NH9X6+L4+KFGEOAQC
         J+1zPPXJ6zEIWDRM1E8Ju8n7cMTyLdFZi3p1FiRXR87c8CDzbsCMo4RBb/elKE0a0zo3
         z69w+pasR0X1rJeDqcQiznPexf3VDf+3vkrjo0rcOvdUFeMSvZ0bCZnZB1PpMsTKs4ZP
         XnXu7vR4HDtn05IZYpbIWnKTe4PwMORmTzqQL9pNpv8b5WtFzQF53jTeioac2udQL2kA
         jlIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702182465; x=1702787265;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ch7OFojdNsq7E6Mol7uZzOwDj4a7N8ypU2/rCYP+N+E=;
        b=Btg49CDTk7w8kGsAKnPc++gD0VaH2O7X/ecTcOzsjILJz5VuX2ebDMzFr88WPihEmE
         Pgd1HIswdY9T5g80+MTQ6t3+iubztmv5MaISahfje0g2LYTHp9kj/rb+zILASMP1OyC+
         3NJGoMoJuyOQqMrUWDH3sLa0L4Lb3voXypvzi4GI+aCWmDiXpInZtzien/slWQwXenSK
         iq/mWZ0PUiiBl/IJPmIXvU6M5xL7eV2J4lDGTbmxeWmomhZa4AhGTZhjWaxGC4YGqoMt
         1SV0p4odkZh/2HFNIdpQlaBjsN6kbIi+DVD6c3r/GF2htCdiDBWSG4N/V1d3/M9f/Ahe
         S9ww==
X-Gm-Message-State: AOJu0Yz72kgigP8bgsdAuoOlqi3FFSFd71D6n+pD6VYbS9Sx98kkIU+J
	/Z7EUtZNvHvzLT2vVP8s2EvdQq603fA=
X-Google-Smtp-Source: AGHT+IE3U2LY0u6y1/tdUM++m/+r7i4D+kbaz1B8FJwvO7TDOVGfYmZUKfiXsfpg3RQkXVoz8R63Xg==
X-Received: by 2002:a05:6e02:1baf:b0:35d:59a2:6901 with SMTP id n15-20020a056e021baf00b0035d59a26901mr3392590ili.46.1702182465039;
        Sat, 09 Dec 2023 20:27:45 -0800 (PST)
Received: from slk15.local.net (n58-108-90-185.meb1.vic.optusnet.com.au. [58.108.90.185])
        by smtp.gmail.com with ESMTPSA id e2-20020a170902744200b001d091508637sm4103561plt.149.2023.12.09.20.27.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Dec 2023 20:27:44 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date: Sun, 10 Dec 2023 15:27:41 +1100
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Sorry for previous message - please ignore
Message-ID: <ZXU+PTxXqZ1QI8W5@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20231209023020.5534-1-duncan_roe@optusnet.com.au>
 <20231209023020.5534-2-duncan_roe@optusnet.com.au>
 <ZXUvpQiLmxZPHtSm@slk15.local.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZXUvpQiLmxZPHtSm@slk15.local.net>

On Sun, Dec 10, 2023 at 02:25:25PM +1100, Duncan Roe wrote:
> Hi Pablo,
>
> Have you ant idea why Patchwork didn't pick up this patch?
>
> Please apply anyway.
>
> Cheers ... Duncan.
> On Sat, Dec 09, 2023 at 01:30:20PM +1100, Duncan Roe wrote:
> > i.e. this one:
> > > -^I^I^I          struct nfq_data *nfad, char *name);$
> > > +^I^I^I^I  struct nfq_data *nfad, char *name);$
> >
> > Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> > ---
> >  include/libnetfilter_queue/libnetfilter_queue.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/include/libnetfilter_queue/libnetfilter_queue.h b/include/libnetfilter_queue/libnetfilter_queue.h
> > index f254984..f7e68d8 100644
> > --- a/include/libnetfilter_queue/libnetfilter_queue.h
> > +++ b/include/libnetfilter_queue/libnetfilter_queue.h
> > @@ -111,7 +111,7 @@ extern int nfq_get_secctx(struct nfq_data *nfad, unsigned char **secdata);
> >  extern int nfq_get_indev_name(struct nlif_handle *nlif_handle,
> >  			      struct nfq_data *nfad, char *name);
> >  extern int nfq_get_physindev_name(struct nlif_handle *nlif_handle,
> > -			          struct nfq_data *nfad, char *name);
> > +				  struct nfq_data *nfad, char *name);
> >  extern int nfq_get_outdev_name(struct nlif_handle *nlif_handle,
> >  			       struct nfq_data *nfad, char *name);
> >  extern int nfq_get_physoutdev_name(struct nlif_handle *nlif_handle,
> > --
> > 2.35.8
> >
> >
>
Hi Pablo,

Thanks for applying this.

I had Archived=no selected so didn't see it in Patchwork.

Cheers ... Duncan.
