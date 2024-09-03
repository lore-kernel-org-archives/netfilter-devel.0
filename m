Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB76019CC28
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Sep 2024 09:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725354164; cv=none; b=sMZDWafFvJOUpx0ngAl3mVJ0wO7md/6m7IqMx5h+cR5srdijzwqAS7qhTSrPmtzXQnMdt26ZFbdo7VSkwajypCnXV14RSbFH8I/tlaoqFOaCvbauNK5kpT9HQSORVOYFs8XMJ/ckZ5l7MDoGoVzpvmr5zCnzmHTJSgLvbp7VvnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725354164; c=relaxed/simple;
	bh=Ct0ytChNzbtHF6q/BNR+W8VD6x0auYh7/zdSKQYZTG4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lyzGdTtTrrpEQioTNUDx/wZl1CEWWrbIqZzRkmevOMhq/phPdP0MfrWqy+sm/AwzGAkOjimiJWQlV20uQKB6Yz1izOknfxG6K57GLLotquRZDlC6XsB+v6kaBbScOb1ZX3hfWgjjA7mhm9uqm6AhdsS2YGKMnFaD5IWo1YnKsIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bgd8kmMZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bgd8kmMZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725354160;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8nOZR9+RGIM0RXD3EBtDIJgmiGpRQ7PyE7THuhUAAok=;
	b=bgd8kmMZjtT+DB4dT+TVsNTupEAYwLVvUFaKZ8cwJCyTImjwfCmBk0rVmZ5WGyeV0cID0z
	9M3lhBiNGvR5VODfNBiBH3BgM94GpLyg8csSKIFHkqWLCX1SmRI8OI6PdaI1RXK2XjRB1Z
	UbDrjQFf9mV2+l6Y2BXRDEiJ+qv95G0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-589--jTQM7jQO3-Jz16rRKXqqQ-1; Tue, 03 Sep 2024 05:02:39 -0400
X-MC-Unique: -jTQM7jQO3-Jz16rRKXqqQ-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-42bb6f0f35cso46820735e9.0
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Sep 2024 02:02:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725354158; x=1725958958;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8nOZR9+RGIM0RXD3EBtDIJgmiGpRQ7PyE7THuhUAAok=;
        b=R+i4xeJhBxbTixgWy+r8E1EpsTnajm7EgloNwluFxqGFlw1nN85j5wAgNcRpr0yuDB
         FQXJbrjQIxFlevkRSEouhbghFO68bjkDG17CQ3Bklw2j9dVqckzjF7O7TWhourAgy07v
         0rIVuhVr8ZUFrfCZ81fOC26fo70Zp+5+A6VeXCaJY5uixPA62cH7v6USY8J1InICKFBT
         KTUtqqMl9N7DJ8KRsQSyl91DkS5P1efiyhkjjTbBEPNLYHSO5ZPhUAu/Eo+Z5R9Vh6fW
         JUu0o/GiUP7PcFtQ1kklcejDodt0poW0SG1eEexW0bk53iTagbcb0a0274mWzIc2M4eu
         4nbw==
X-Forwarded-Encrypted: i=1; AJvYcCWU6l23AvbJH59k4Jcck1v8RU61+C54C4fT2fuwqkQuQCc4mO9axu3NJh2D+tJ7vpO7Sj7tfhBvt1MT9ombx1w=@vger.kernel.org
X-Gm-Message-State: AOJu0YxICU3MqP6v0zxqqWW/i6FB2dxiWM9pvnks7iqqGYijDghRGPTq
	VttnClA2JraCCf6eQIQBxz97uCiyz4uGPoXu4byuR78dLwlmrWfrlY3qTTi3fovLOZIcvx6pCf+
	pBuysLK+7ZwCKgDUd2zG5aD8KSp4TZyYse8nR7qQoHmnqgkATWvy19ISijbX6jWsXVw==
X-Received: by 2002:a05:600c:4707:b0:428:f41:d467 with SMTP id 5b1f17b1804b1-42bbb205ad3mr75461835e9.10.1725354158143;
        Tue, 03 Sep 2024 02:02:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFvKOhxOtKeEiTSi098j6+yh5sZky7e8y6KTgvTcdxZhqETZWOQrBVBzeH5V2Bqsy5tW0zRcA==
X-Received: by 2002:a05:600c:4707:b0:428:f41:d467 with SMTP id 5b1f17b1804b1-42bbb205ad3mr75461405e9.10.1725354157228;
        Tue, 03 Sep 2024 02:02:37 -0700 (PDT)
Received: from debian (2a01cb058d23d600f5dfa0c7b061efd4.ipv6.abo.wanadoo.fr. [2a01:cb05:8d23:d600:f5df:a0c7:b061:efd4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42bb6e36626sm163697025e9.47.2024.09.03.02.02.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2024 02:02:36 -0700 (PDT)
Date: Tue, 3 Sep 2024 11:02:34 +0200
From: Guillaume Nault <gnault@redhat.com>
To: Ido Schimmel <idosch@nvidia.com>
Cc: David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, davem@davemloft.net,
	kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
	pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de
Subject: Re: [PATCH net-next v2 3/3] ipv4: Centralize TOS matching
Message-ID: <ZtbQqsYIwo12AhOm@debian>
References: <20240814125224.972815-1-idosch@nvidia.com>
 <20240814125224.972815-4-idosch@nvidia.com>
 <2f5146ff-507d-4cab-a195-b28c0c9e654e@kernel.org>
 <ZtYNYTKSihLYowLO@shredder.mtl.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZtYNYTKSihLYowLO@shredder.mtl.com>

On Mon, Sep 02, 2024 at 10:09:21PM +0300, Ido Schimmel wrote:
> On Mon, Sep 02, 2024 at 10:50:17AM -0600, David Ahern wrote:
> > On 8/14/24 6:52 AM, Ido Schimmel wrote:
> > > diff --git a/include/uapi/linux/in_route.h b/include/uapi/linux/in_route.h
> > > index 0cc2c23b47f8..10bdd7e7107f 100644
> > > --- a/include/uapi/linux/in_route.h
> > > +++ b/include/uapi/linux/in_route.h
> > > @@ -2,6 +2,8 @@
> > >  #ifndef _LINUX_IN_ROUTE_H
> > >  #define _LINUX_IN_ROUTE_H
> > >  
> > > +#include <linux/ip.h>
> > > +
> > >  /* IPv4 routing cache flags */
> > >  
> > >  #define RTCF_DEAD	RTNH_F_DEAD
> > 
> > This breaks compile of iproute2 (on Ubuntu 22.04 at least):
> 
> Sorry about that. Some definitions in include/uapi/linux/ip.h conflict
> with those in /usr/include/netinet/ip.h.
> 
> Guillaume, any objections going back to v1 [1]?

No objection. Let's go back to v1. Any other attempt to fix the
situation would probably require ugly workarounds.

> [1]
> https://lore.kernel.org/netdev/ZqYsrgnWwdQb1zgp@shredder.mtl.com/
> 
> diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
> index 269ec10f63e4..967e4dc555fa 100644
> --- a/include/net/ip_fib.h
> +++ b/include/net/ip_fib.h
> @@ -22,6 +22,7 @@
>  #include <linux/percpu.h>
>  #include <linux/notifier.h>
>  #include <linux/refcount.h>
> +#include <linux/ip.h>
>  #include <linux/in_route.h>
>  
>  struct fib_config {
> diff --git a/include/uapi/linux/in_route.h b/include/uapi/linux/in_route.h
> index 10bdd7e7107f..0cc2c23b47f8 100644
> --- a/include/uapi/linux/in_route.h
> +++ b/include/uapi/linux/in_route.h
> @@ -2,8 +2,6 @@
>  #ifndef _LINUX_IN_ROUTE_H
>  #define _LINUX_IN_ROUTE_H
>  
> -#include <linux/ip.h>
> -
>  /* IPv4 routing cache flags */
>  
>  #define RTCF_DEAD      RTNH_F_DEAD
> 
> > 
> > In file included from ../include/uapi/linux/in_route.h:5,
> >                  from iproute.c:19:
> > ../include/uapi/linux/ip.h:25: warning: "IPTOS_TOS" redefined
> >    25 | #define IPTOS_TOS(tos)          ((tos)&IPTOS_TOS_MASK)
> >       |
> > In file included from iproute.c:17:
> > /usr/include/netinet/ip.h:212: note: this is the location of the
> > previous definition
> >   212 | #define IPTOS_TOS(tos)          ((tos) & IPTOS_TOS_MASK)
> >       |
> > In file included from ../include/uapi/linux/in_route.h:5,
> >                  from iproute.c:19:
> > ../include/uapi/linux/ip.h:29: warning: "IPTOS_MINCOST" redefined
> >    29 | #define IPTOS_MINCOST           0x02
> >       |
> > In file included from iproute.c:17:
> > /usr/include/netinet/ip.h:217: note: this is the location of the
> > previous definition
> >   217 | #define IPTOS_MINCOST           IPTOS_LOWCOST
> >       |
> > In file included from ../include/uapi/linux/in_route.h:5,
> >                  from iproute.c:19:
> > ../include/uapi/linux/ip.h:31: warning: "IPTOS_PREC_MASK" redefined
> >    31 | #define IPTOS_PREC_MASK         0xE0
> >       |
> > In file included from iproute.c:17:
> > /usr/include/netinet/ip.h:222: note: this is the location of the
> > previous definition
> >   222 | #define IPTOS_PREC_MASK                 IPTOS_CLASS_MASK
> >       |
> > In file included from ../include/uapi/linux/in_route.h:5,
> >                  from iproute.c:19:
> > ../include/uapi/linux/ip.h:32: warning: "IPTOS_PREC" redefined
> >    32 | #define IPTOS_PREC(tos)         ((tos)&IPTOS_PREC_MASK)
> >       |
> > In file included from iproute.c:17:
> > /usr/include/netinet/ip.h:223: note: this is the location of the
> > previous definition
> >   223 | #define IPTOS_PREC(tos)                 IPTOS_CLASS(tos)
> >       |
> > In file included from ../include/uapi/linux/in_route.h:5,
> >                  from iproute.c:19:
> > ../include/uapi/linux/ip.h:33: warning: "IPTOS_PREC_NETCONTROL" redefined
> >    33 | #define IPTOS_PREC_NETCONTROL           0xe0
> >       |
> > In file included from iproute.c:17:
> > /usr/include/netinet/ip.h:224: note: this is the location of the
> > previous definition
> >   224 | #define IPTOS_PREC_NETCONTROL           IPTOS_CLASS_CS7
> >       |
> > In file included from ../include/uapi/linux/in_route.h:5,
> >                  from iproute.c:19:
> > ../include/uapi/linux/ip.h:34: warning: "IPTOS_PREC_INTERNETCONTROL"
> > redefined
> >    34 | #define IPTOS_PREC_INTERNETCONTROL      0xc0
> >       |
> > In file included from iproute.c:17:
> > /usr/include/netinet/ip.h:225: note: this is the location of the
> > previous definition
> >   225 | #define IPTOS_PREC_INTERNETCONTROL      IPTOS_CLASS_CS6
> >       |
> > In file included from ../include/uapi/linux/in_route.h:5,
> >                  from iproute.c:19:
> > ../include/uapi/linux/ip.h:35: warning: "IPTOS_PREC_CRITIC_ECP" redefined
> >    35 | #define IPTOS_PREC_CRITIC_ECP           0xa0
> >       |
> > In file included from iproute.c:17:
> > /usr/include/netinet/ip.h:226: note: this is the location of the
> > previous definition
> >   226 | #define IPTOS_PREC_CRITIC_ECP           IPTOS_CLASS_CS5
> >       |
> > In file included from ../include/uapi/linux/in_route.h:5,
> >                  from iproute.c:19:
> > ../include/uapi/linux/ip.h:36: warning: "IPTOS_PREC_FLASHOVERRIDE" redefined
> >    36 | #define IPTOS_PREC_FLASHOVERRIDE        0x80
> >       |
> > In file included from iproute.c:17:
> > /usr/include/netinet/ip.h:227: note: this is the location of the
> > previous definition
> >   227 | #define IPTOS_PREC_FLASHOVERRIDE        IPTOS_CLASS_CS4
> >       |
> > In file included from ../include/uapi/linux/in_route.h:5,
> >                  from iproute.c:19:
> > ../include/uapi/linux/ip.h:37: warning: "IPTOS_PREC_FLASH" redefined
> >    37 | #define IPTOS_PREC_FLASH                0x60
> >       |
> > In file included from iproute.c:17:
> > /usr/include/netinet/ip.h:228: note: this is the location of the
> > previous definition
> >   228 | #define IPTOS_PREC_FLASH                IPTOS_CLASS_CS3
> >       |
> > In file included from ../include/uapi/linux/in_route.h:5,
> >                  from iproute.c:19:
> > ../include/uapi/linux/ip.h:38: warning: "IPTOS_PREC_IMMEDIATE" redefined
> >    38 | #define IPTOS_PREC_IMMEDIATE            0x40
> >       |
> > In file included from iproute.c:17:
> > /usr/include/netinet/ip.h:229: note: this is the location of the
> > previous definition
> >   229 | #define IPTOS_PREC_IMMEDIATE            IPTOS_CLASS_CS2
> >       |
> > In file included from ../include/uapi/linux/in_route.h:5,
> >                  from iproute.c:19:
> > ../include/uapi/linux/ip.h:39: warning: "IPTOS_PREC_PRIORITY" redefined
> >    39 | #define IPTOS_PREC_PRIORITY             0x20
> >       |
> > In file included from iproute.c:17:
> > /usr/include/netinet/ip.h:230: note: this is the location of the
> > previous definition
> >   230 | #define IPTOS_PREC_PRIORITY             IPTOS_CLASS_CS1
> >       |
> > In file included from ../include/uapi/linux/in_route.h:5,
> >                  from iproute.c:19:
> > ../include/uapi/linux/ip.h:40: warning: "IPTOS_PREC_ROUTINE" redefined
> >    40 | #define IPTOS_PREC_ROUTINE              0x00
> >       |
> > In file included from iproute.c:17:
> > /usr/include/netinet/ip.h:231: note: this is the location of the
> > previous definition
> >   231 | #define IPTOS_PREC_ROUTINE              IPTOS_CLASS_CS0
> >       |
> > In file included from ../include/uapi/linux/in_route.h:5,
> >                  from iproute.c:19:
> > ../include/uapi/linux/ip.h:48: warning: "IPOPT_COPIED" redefined
> >    48 | #define IPOPT_COPIED(o)         ((o)&IPOPT_COPY)
> >       |
> > In file included from iproute.c:17:
> > /usr/include/netinet/ip.h:240: note: this is the location of the
> > previous definition
> >   240 | #define IPOPT_COPIED(o)         ((o) & IPOPT_COPY)
> >       |
> > In file included from ../include/uapi/linux/in_route.h:5,
> >                  from iproute.c:19:
> > ../include/uapi/linux/ip.h:49: warning: "IPOPT_CLASS" redefined
> >    49 | #define IPOPT_CLASS(o)          ((o)&IPOPT_CLASS_MASK)
> >       |
> > In file included from iproute.c:17:
> > /usr/include/netinet/ip.h:241: note: this is the location of the
> > previous definition
> >   241 | #define IPOPT_CLASS(o)          ((o) & IPOPT_CLASS_MASK)
> >       |
> > In file included from ../include/uapi/linux/in_route.h:5,
> >                  from iproute.c:19:
> > ../include/uapi/linux/ip.h:50: warning: "IPOPT_NUMBER" redefined
> >    50 | #define IPOPT_NUMBER(o)         ((o)&IPOPT_NUMBER_MASK)
> >       |
> > In file included from iproute.c:17:
> > /usr/include/netinet/ip.h:242: note: this is the location of the
> > previous definition
> >   242 | #define IPOPT_NUMBER(o)         ((o) & IPOPT_NUMBER_MASK)
> >       |
> > In file included from ../include/uapi/linux/in_route.h:5,
> >                  from iproute.c:19:
> > ../include/uapi/linux/ip.h:54: warning: "IPOPT_MEASUREMENT" redefined
> >    54 | #define IPOPT_MEASUREMENT       0x40
> >       |
> > In file included from iproute.c:17:
> > /usr/include/netinet/ip.h:247: note: this is the location of the
> > previous definition
> >   247 | #define IPOPT_MEASUREMENT       IPOPT_DEBMEAS
> >       |
> > In file included from ../include/uapi/linux/in_route.h:5,
> >                  from iproute.c:19:
> > ../include/uapi/linux/ip.h:57: warning: "IPOPT_END" redefined
> >    57 | #define IPOPT_END       (0 |IPOPT_CONTROL)
> >       |
> > In file included from iproute.c:17:
> > /usr/include/netinet/ip.h:251: note: this is the location of the
> > previous definition
> >   251 | #define IPOPT_END               IPOPT_EOL
> >       |
> > In file included from ../include/uapi/linux/in_route.h:5,
> >                  from iproute.c:19:
> > ../include/uapi/linux/ip.h:58: warning: "IPOPT_NOOP" redefined
> >    58 | #define IPOPT_NOOP      (1 |IPOPT_CONTROL)
> >       |
> > In file included from iproute.c:17:
> > /usr/include/netinet/ip.h:253: note: this is the location of the
> > previous definition
> >   253 | #define IPOPT_NOOP              IPOPT_NOP
> >       |
> > In file included from ../include/uapi/linux/in_route.h:5,
> >                  from iproute.c:19:
> > ../include/uapi/linux/ip.h:59: warning: "IPOPT_SEC" redefined
> >    59 | #define IPOPT_SEC       (2 |IPOPT_CONTROL|IPOPT_COPY)
> >       |
> > In file included from iproute.c:17:
> > /usr/include/netinet/ip.h:259: note: this is the location of the
> > previous definition
> >   259 | #define IPOPT_SEC               IPOPT_SECURITY
> >       |
> > In file included from ../include/uapi/linux/in_route.h:5,
> >                  from iproute.c:19:
> > ../include/uapi/linux/ip.h:60: warning: "IPOPT_LSRR" redefined
> >    60 | #define IPOPT_LSRR      (3 |IPOPT_CONTROL|IPOPT_COPY)
> >       |
> > In file included from iproute.c:17:
> > /usr/include/netinet/ip.h:260: note: this is the location of the
> > previous definition
> >   260 | #define IPOPT_LSRR              131             /* loose source
> > route */
> >       |
> > In file included from ../include/uapi/linux/in_route.h:5,
> >                  from iproute.c:19:
> > ../include/uapi/linux/ip.h:61: warning: "IPOPT_TIMESTAMP" redefined
> >    61 | #define IPOPT_TIMESTAMP (4 |IPOPT_MEASUREMENT)
> >       |
> > In file included from iproute.c:17:
> > /usr/include/netinet/ip.h:257: note: this is the location of the
> > previous definition
> >   257 | #define IPOPT_TIMESTAMP         IPOPT_TS
> >       |
> > In file included from ../include/uapi/linux/in_route.h:5,
> >                  from iproute.c:19:
> > ../include/uapi/linux/ip.h:63: warning: "IPOPT_RR" redefined
> >    63 | #define IPOPT_RR        (7 |IPOPT_CONTROL)
> >       |
> > In file included from iproute.c:17:
> > /usr/include/netinet/ip.h:255: note: this is the location of the
> > previous definition
> >   255 | #define IPOPT_RR                7               /* record packet
> > route */
> >       |
> > In file included from ../include/uapi/linux/in_route.h:5,
> >                  from iproute.c:19:
> > ../include/uapi/linux/ip.h:64: warning: "IPOPT_SID" redefined
> >    64 | #define IPOPT_SID       (8 |IPOPT_CONTROL|IPOPT_COPY)
> >       |
> > In file included from iproute.c:17:
> > /usr/include/netinet/ip.h:262: note: this is the location of the
> > previous definition
> >   262 | #define IPOPT_SID               IPOPT_SATID
> >       |
> > In file included from ../include/uapi/linux/in_route.h:5,
> >                  from iproute.c:19:
> > ../include/uapi/linux/ip.h:65: warning: "IPOPT_SSRR" redefined
> >    65 | #define IPOPT_SSRR      (9 |IPOPT_CONTROL|IPOPT_COPY)
> >       |
> > In file included from iproute.c:17:
> > /usr/include/netinet/ip.h:263: note: this is the location of the
> > previous definition
> >   263 | #define IPOPT_SSRR              137             /* strict source
> > route */
> >       |
> > In file included from ../include/uapi/linux/in_route.h:5,
> >                  from iproute.c:19:
> > ../include/uapi/linux/ip.h:66: warning: "IPOPT_RA" redefined
> >    66 | #define IPOPT_RA        (20|IPOPT_CONTROL|IPOPT_COPY)
> >       |
> > In file included from iproute.c:17:
> > /usr/include/netinet/ip.h:264: note: this is the location of the
> > previous definition
> >   264 | #define IPOPT_RA                148             /* router alert */
> >       |
> > In file included from ../include/uapi/linux/in_route.h:5,
> >                  from iproute.c:19:
> > ../include/uapi/linux/ip.h:77: warning: "IPOPT_NOP" redefined
> >    77 | #define IPOPT_NOP IPOPT_NOOP
> >       |
> > In file included from iproute.c:17:
> > /usr/include/netinet/ip.h:252: note: this is the location of the
> > previous definition
> >   252 | #define IPOPT_NOP               1               /* no operation */
> >       |
> > In file included from ../include/uapi/linux/in_route.h:5,
> >                  from iproute.c:19:
> > ../include/uapi/linux/ip.h:78: warning: "IPOPT_EOL" redefined
> >    78 | #define IPOPT_EOL IPOPT_END
> >       |
> > In file included from iproute.c:17:
> > /usr/include/netinet/ip.h:250: note: this is the location of the
> > previous definition
> >   250 | #define IPOPT_EOL               0               /* end of option
> > list */
> >       |
> > In file included from ../include/uapi/linux/in_route.h:5,
> >                  from iproute.c:19:
> > ../include/uapi/linux/ip.h:79: warning: "IPOPT_TS" redefined
> >    79 | #define IPOPT_TS  IPOPT_TIMESTAMP
> >       |
> > In file included from iproute.c:17:
> > /usr/include/netinet/ip.h:256: note: this is the location of the
> > previous definition
> >   256 | #define IPOPT_TS                68              /* timestamp */
> >       |
> > In file included from ../include/uapi/linux/in_route.h:5,
> >                  from iproute.c:19:
> > ../include/uapi/linux/ip.h:87:8: error: redefinition of ‘struct iphdr’
> >    87 | struct iphdr {
> >       |        ^~~~~
> > In file included from iproute.c:17:
> > /usr/include/netinet/ip.h:44:8: note: originally defined here
> >    44 | struct iphdr
> >       |        ^~~~~
> 

