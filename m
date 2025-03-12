Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A38E41DB551
	for <netfilter-devel@vger.kernel.org>; Wed, 12 Mar 2025 06:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741760522; cv=none; b=RJjkQTLMZCb034SiLDPxOHSIcjZsA5Oj6KgBt/KnSQC76Kbta+OxX5EUxnrbStpcL4++u7zDdmJKxnXi48mf9y4xV1kRUQfDckYMDR44oYb4W6WPc7fX5KTouxI8w1aDx52VzyAw8RlewM7rxs0dUiTcaYBdy1Do0qaYkgORMk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741760522; c=relaxed/simple;
	bh=Ca0yQM2y0ItR0IxJ+tUBOTzxmwwNapuRFXtKuSeQ+pQ=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rh/QUJcX2WLIAnQ0xCbXQFcCNX3CsjvHvEyiaw1RR0C2l7C7UDJQq0qoiZ8h3WSSCOIwLYyUqBS1tSO9fvqvYUH+KqStbXiJvTts00b5Q5SzIbo7X2SOVaaKtLHkeznmOJBMpqg5n9tgc/ovCs0+/iiTwuV6QO0IxtL0xO2M0Dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PG/q3tsd; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PG/q3tsd"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-224191d92e4so110791315ad.3
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Mar 2025 23:22:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741760520; x=1742365320; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gWv/UbdwGCFgTJfgyhXyeqJw9FT1VymO4pE3D0bEjcM=;
        b=PG/q3tsdtMiC9WvT0QYRjkHwiT04PMXCX55Ym+goBBC4gqxPJiFl1eqo0AdCt6FAYZ
         MQ6KEpkWsWRZj0aN3m6TSAn51MkJEABQU1BkVj1pu96pWp4jdX8GYPMVigGz3wM7Nvaj
         NxZLIBYQDx5tILSDiXBX9hpT8ePqIDKEo+jJ/G/ZX+6ow/bxLNANDwDSePunTZxHngH5
         U0+lsffoiZHtiZpTgJMHXNhLiPuMN13Hvd7duxFEDQ+5A3jMG5saxljnmvwyu+nP1Sjf
         jYPUJky7DQU/9rF4YAJfed03oTeBBT049CDxA6pzUk2YoicfaeW/EMnvfBymZzoQpcna
         HKdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741760520; x=1742365320;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gWv/UbdwGCFgTJfgyhXyeqJw9FT1VymO4pE3D0bEjcM=;
        b=Mon/tecU5XlhxTRDxnmgBu7tneO+L5pl5a+ojDMmaL0+gqmVElblsDnJGHDIy5PrOK
         7+dxTnZWEaJa2RwYoXFDzWx+Rr/i+WDQ6xo3Y9h3JqIgyYnLaSEINxT2dOgD6N0zZtua
         D2J7/IlHMGfxjpQvT3D2WvXGPXOIy4omGWEwW11lqoV9FxC+00D7eD9qabtIuVKYB2a5
         45HSKYHxyK3+cVuqibpWKMyIjayPpWXNj8WlDxwPUj9VA1yNNpYZ6qSwVmI3rhiCBx81
         yolJsETv4DluVxbmux9xi5QSaCS//Mj6CR7gxg3Y1r++hYICgzcEGuJlwK2zasnKy2ky
         uPIw==
X-Gm-Message-State: AOJu0YyJhg+K77jyAlIHwb6CogPDMrELFqVEMfCVv87rauFa2qS2uE1h
	t7Cnf+IPv7ax65g/px1853x80SEoz8Bn0zu70ljdjvIcD2D9GPvQgB7HDg==
X-Gm-Gg: ASbGncugtgntZdvuSECvCoYtcAY4kYWmaULYAf/Nga2w4pseofQRYl5Raa3aVOw81iv
	bep2Nm6j50fSHxVqCuDDWqN/nL0JpESd9I+DpxDpLh7/Gi1er4EtPG4Ac+C9GCswinwQJLlzpk9
	yZu/wGqxnveQh0iKC/0vilc3cvlAUALMfFa42Ojc5rrohStXx4+Kj24viPRhkPTII7QzPJsXqWp
	XfDpj2dLyJjnl5UnXu6elZQm1gFtAuOqmgblLCRsi4pvEIGRuGCnpppL4724NrKMoUkjtoFIP0Q
	BbDQ4NGBKrJvAC9+h6kQQwap+csRHU1U4qH6e0nLYhvi6AvsmH6+0Jqv/humzbpI4iFk+8UE6un
	9VxK1BSLCfRzKffV+0bcXWQ==
X-Google-Smtp-Source: AGHT+IF5B8zqZfJ3etwUOjwV0mRAiY+tTRh4F4K0XUaIO9W7d/dQqh63ozgsoUk0VmTzWGLOmz9zqQ==
X-Received: by 2002:a17:902:e80f:b0:215:8809:b3b7 with SMTP id d9443c01a7336-2242888068emr244000245ad.7.1741760519651;
        Tue, 11 Mar 2025 23:21:59 -0700 (PDT)
Received: from slk15.local.net (n175-33-111-144.meb22.vic.optusnet.com.au. [175.33.111.144])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-224109ddc89sm108612045ad.36.2025.03.11.23.21.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Mar 2025 23:21:58 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date: Wed, 12 Mar 2025 17:21:55 +1100
To: "G.W. Haywood" <ged@jubileegroup.co.uk>
Cc: Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: Documentation oddity.
Message-ID: <Z9EoA1g/USRbSufZ@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: "G.W. Haywood" <ged@jubileegroup.co.uk>,
	Netfilter Development <netfilter-devel@vger.kernel.org>
References: <9190a743-e6ac-fa2a-4740-864b62d5fda7@jubileegroup.co.uk>
 <bda3eb41-742f-a3c3-f23e-c535e4e461fd@blackhole.kfki.hu>
 <4991be2e-3839-526f-505e-f8dd2c2fc3f3@jubileegroup.co.uk>
 <Z899IF0jLhUMQLE4@slk15.local.net>
 <99edfdb-3c85-3cce-dcc3-6e61c6268a77@jubileegroup.co.uk>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <99edfdb-3c85-3cce-dcc3-6e61c6268a77@jubileegroup.co.uk>

Hi Ged,

On Tue, Mar 11, 2025 at 10:00:04AM +0000, G.W. Haywood wrote:
>
> Debian 11, gcc version 10.2.1-6 here.
>
> 8<----------------------------------------------------------------------
> $ gcc -g3 -gdwarf-4 -Wall -lmnl -lnetfilter_queue -o nf-queue nf-queue.c
> /usr/bin/ld: /tmp/ccbLJv89.o: in function `nfq_send_verdict':
> /home/ged/nf-queue.c:30: undefined reference to `nfq_nlmsg_put'
> /usr/bin/ld: /home/ged/nf-queue.c:31: undefined reference to `nfq_nlmsg_verdict_put'
> /usr/bin/ld: /home/ged/nf-queue.c:34: undefined reference to `mnl_attr_nest_start'
> /usr/bin/ld: /home/ged/nf-queue.c:37: undefined reference to `mnl_attr_put_u32'
> /usr/bin/ld: /home/ged/nf-queue.c:41: undefined reference to `mnl_attr_nest_end'
> /usr/bin/ld: /home/ged/nf-queue.c:43: undefined reference to `mnl_socket_sendto'
> /usr/bin/ld: /tmp/ccbLJv89.o: in function `queue_cb':
> /home/ged/nf-queue.c:60: undefined reference to `nfq_nlmsg_parse'
> /usr/bin/ld: /home/ged/nf-queue.c:65: undefined reference to `mnl_nlmsg_get_payload'
> /usr/bin/ld: /home/ged/nf-queue.c:75: undefined reference to `mnl_attr_get_payload'
> /usr/bin/ld: /home/ged/nf-queue.c:78: undefined reference to `mnl_attr_get_payload_len'
> /usr/bin/ld: /home/ged/nf-queue.c:93: undefined reference to `mnl_attr_get_u32'
> /usr/bin/ld: /home/ged/nf-queue.c:97: undefined reference to `mnl_attr_get_u32'
> /usr/bin/ld: /home/ged/nf-queue.c:111: undefined reference to `mnl_attr_get_payload'
> /usr/bin/ld: /tmp/ccbLJv89.o: in function `main':
> /home/ged/nf-queue.c:162: undefined reference to `mnl_socket_open'
> /usr/bin/ld: /home/ged/nf-queue.c:168: undefined reference to `mnl_socket_bind'
> /usr/bin/ld: /home/ged/nf-queue.c:172: undefined reference to `mnl_socket_get_portid'
> /usr/bin/ld: /home/ged/nf-queue.c:184: undefined reference to `nfq_nlmsg_put'
> /usr/bin/ld: /home/ged/nf-queue.c:185: undefined reference to `nfq_nlmsg_cfg_put_cmd'
> /usr/bin/ld: /home/ged/nf-queue.c:187: undefined reference to `mnl_socket_sendto'
> /usr/bin/ld: /home/ged/nf-queue.c:195: undefined reference to `nfq_nlmsg_put'
> /usr/bin/ld: /home/ged/nf-queue.c:196: undefined reference to `nfq_nlmsg_cfg_put_params'
> /usr/bin/ld: /home/ged/nf-queue.c:198: undefined reference to `mnl_attr_put_u32'
> /usr/bin/ld: /home/ged/nf-queue.c:199: undefined reference to `mnl_attr_put_u32'
> /usr/bin/ld: /home/ged/nf-queue.c:201: undefined reference to `mnl_socket_sendto'
> /usr/bin/ld: /home/ged/nf-queue.c:211: undefined reference to `mnl_socket_setsockopt'
> /usr/bin/ld: /home/ged/nf-queue.c:217: undefined reference to `mnl_socket_recvfrom'
> /usr/bin/ld: /home/ged/nf-queue.c:223: undefined reference to `mnl_cb_run'
> collect2: error: ld returned 1 exit status
> 8<----------------------------------------------------------------------
>
nf-queue.c has compiled fine.

There is a problem with the shared libraries libmnl.so and
libnetfilter_queue.so. Those 2 libraries should satisfy the mnl_ and nfq_
references respectively.

On my (Slackware x86_64) system, "nm -D /usr/lib64/libmnl.so|grep -Ew T" gives:
| 0000000000003687 T mnl_attr_get_len@@LIBMNL_1.0
| 00000000000036ac T mnl_attr_get_payload@@LIBMNL_1.0
| 0000000000003698 T mnl_attr_get_payload_len@@LIBMNL_1.0
| ...
for a total of 68 lines. What do you get? (you may have to put /usr/lib instead
of /usr/lib64).
>
> $ gcc --version | head -n1
> gcc (Debian 10.2.1-6) 10.2.1 20210110

Same as my Debian 11.5 VM.
>
> This is a raspberry Pi4B, 8GBytes, 64 bit.
>
> 8<----------------------------------------------------------------------
> $ uname -a
> Linux raspberrypi 6.1.21-v8+ #1642 SMP PREEMPT Mon Apr  3 17:24:16 BST 2023 aarch64 GNU/Linux
> $ 8<----------------------------------------------------------------------

Looks like an arm-specific problem. nm output should tell us more.
>
> There were other problems when I tried the same thing on x86, but that
> was gcc version 8, so I think they can be ignored.

gcc-8 should be fine. Please document these problems also.

Cheers ... Duncan.
