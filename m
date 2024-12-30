Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6486E1632D9
	for <netfilter-devel@vger.kernel.org>; Mon, 30 Dec 2024 07:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735545117; cv=none; b=tgZhux+hTPz6zdxsWUsSagzLkOFlVGNHpTqf/xPZn/otfWMK9P+fqBnHhi4Yb8FN7F2YX3UkQ8v4xKmDOLLsLJ3RH52DIRfmOWxFRjel8SzI7dGeTXy/1xmLV7vVL0JoygbOqK3HAIfTHiVLr6bK57xB0Ph1SFVPhd9Q8SSdrgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735545117; c=relaxed/simple;
	bh=Ty0odp3SjgUTqexMbjUfQ7REoC5DutDQisZcBKmlUUs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hHZxKr1Fvih//d8BcDlyrhOrrDi17H2c+4SJLTDNBKKznG317w+zdF/gl+6e9aLzcW7tlUGOjXQpjKc50U54JcCc4geUoLWOCjFejtQ9gcoCzXN5OLIQcFbwV+KGrWA30ns8YolBqeKh3qU2iKiZnJFRr1ZWr85lG1HRJ2M6ea0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H0i9Mg4y; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H0i9Mg4y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735545115;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0J0AYhxmNDrE+hV/0WPbQ41cTnDC3xZnCg8iwgLqFn4=;
	b=H0i9Mg4yA0miPbw3d9UsHgDmZqS2pnMhBqGarKWxGBPc7ZQ1gsramiUjDLtBIcEIzAVVQE
	iydxYqtcQUaTaxztu29sTxqeWZHzmtHxdyKHmet1NyaPOiC8px7+8q99yaOwkmhT7mVvOA
	RFGRV6j8pdJGEWMaiatsI1pq7DpX+WU=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-70-VmlKvp6IM9GDfnoNMbDVYw-1; Mon, 30 Dec 2024 02:51:53 -0500
X-MC-Unique: VmlKvp6IM9GDfnoNMbDVYw-1
X-Mimecast-MFC-AGG-ID: VmlKvp6IM9GDfnoNMbDVYw
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-2eeeb5b7022so12379420a91.0
        for <netfilter-devel@vger.kernel.org>; Sun, 29 Dec 2024 23:51:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735545113; x=1736149913;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0J0AYhxmNDrE+hV/0WPbQ41cTnDC3xZnCg8iwgLqFn4=;
        b=R0TyCi0u/UN6x6TO4HOQF/OA8B/ds+zc8/G5Sa+XJ7QzR2PUi98SiOQGMCOsVCnxrD
         6wuHpDCp/+ZUbB9lK4wmlA/BtosqX/vRY/AjGFSBanuqkRpvA+ZZCl2SGYAXRDBh49QQ
         gwf6UXNDEPetlQwJcr5vKPFVC+oQp37e8pwv51ZkSWd/Qu5lyft2RDvYzoWpdm1aHynm
         BH4MCvGXsE1kQ91qYVJZK/3/J6AbrAGaGld58XMF0DQyFFUNk2mAdeSCQ4D93o6LCS1u
         mMGipKCSGgp6h9oLKi9SMo2H6E2W5+5YpvqvX+YbHYXiuj+JQ9gDzdMH/ILbxhpT/Vo3
         hvog==
X-Forwarded-Encrypted: i=1; AJvYcCW3/y3CRNyaNvjylbEkWHwxyn7OPHUfDqzj/3Xr8P+wF2XnaXi65/MyqdgZJgknuvKEeLrI2hE8XFHApAWdnas=@vger.kernel.org
X-Gm-Message-State: AOJu0YxkJgbZLkXfpRIqfxJc3OoJVFp4Y0vAk13pBjlgQX9cb0otFThv
	QFqQz4QG7odlpMh+uX2C7Tu95Y/0MnGS1HVsfrDBhf68TBjBIFSkxREGFM96RpPH5sRc3lfN1/b
	3ax40LFa3AWAoxORM/y9DzCiyzvQCvMUFgs3TcpRWER7yI9Zs9kAPUzxt+SSJwZxneMrN+yU6t6
	OecXD7FCIEVMkgGuqjt4HeI+eELH7U+ZKUdF3mDNJv
X-Gm-Gg: ASbGnctJRiFmoGo0h+pId9CfWwE81fDt2gAKlGkIvu0NCercNnakaDgxJ+KanyBvPyW
	jXekK/OeOe63u+1H5vAABU7dQNzilCNn6e/SH
X-Received: by 2002:a05:6a00:4391:b0:728:927b:7de2 with SMTP id d2e1a72fcca58-72abdd7cbaemr60529623b3a.8.1735545112960;
        Sun, 29 Dec 2024 23:51:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGrRn8WcYwv283lLqZw/U9xGQjtM/ypQuHSDfUoQ2eSZRdU4bKS9WRvBDuEhHDV4a2t6IovfqPmrMjsRDPQDxs=
X-Received: by 2002:a05:6a00:4391:b0:728:927b:7de2 with SMTP id
 d2e1a72fcca58-72abdd7cbaemr60529579b3a.8.1735545112567; Sun, 29 Dec 2024
 23:51:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241227191211.12485-1-chia-yu.chang@nokia-bell-labs.com> <20241227191211.12485-12-chia-yu.chang@nokia-bell-labs.com>
In-Reply-To: <20241227191211.12485-12-chia-yu.chang@nokia-bell-labs.com>
From: Jason Wang <jasowang@redhat.com>
Date: Mon, 30 Dec 2024 15:51:41 +0800
Message-ID: <CACGkMEu990O+2Sedj+ASv0P5TnZR9THiOdHmx=L0hOxQRXPcsg@mail.gmail.com>
Subject: Re: [PATCH v6 net-next 11/14] virtio_net: Accurate ECN flag in virtio_net_hdr
To: chia-yu.chang@nokia-bell-labs.com
Cc: netdev@vger.kernel.org, dsahern@gmail.com, davem@davemloft.net, 
	edumazet@google.com, dsahern@kernel.org, pabeni@redhat.com, 
	joel.granados@kernel.org, kuba@kernel.org, andrew+netdev@lunn.ch, 
	horms@kernel.org, pablo@netfilter.org, kadlec@netfilter.org, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	shenjian15@huawei.com, salil.mehta@huawei.com, shaojijie@huawei.com, 
	saeedm@nvidia.com, tariqt@nvidia.com, mst@redhat.com, 
	xuanzhuo@linux.alibaba.com, eperezma@redhat.com, 
	virtualization@lists.linux.dev, ij@kernel.org, ncardwell@google.com, 
	koen.de_schepper@nokia-bell-labs.com, g.white@cablelabs.com, 
	ingemar.s.johansson@ericsson.com, mirja.kuehlewind@ericsson.com, 
	cheshire@apple.com, rs.ietf@gmx.at, Jason_Livingood@comcast.com, 
	vidhi_goel@apple.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 28, 2024 at 3:13=E2=80=AFAM <chia-yu.chang@nokia-bell-labs.com>=
 wrote:
>
> From: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>
>
> Unlike RFC 3168 ECN, accurate ECN uses the CWR flag as part of the ACE
> field to count new packets with CE mark; however, it will be corrupted
> by the RFC 3168 ECN-aware TSO. Therefore, fallback shall be applied by
> seting NETIF_F_GSO_ACCECN to ensure that the CWR flag should not be
> changed within a super-skb.
>
> To apply the aforementieond new AccECN GSO for virtio, new featue bits
> for host and guest are added for feature negotiation between driver and
> device. And the translation of Accurate ECN GSO flag between
> virtio_net_hdr and skb header for NETIF_F_GSO_ACCECN is also added to
> avoid CWR flag corruption due to RFC3168 ECN TSO.
>
> Signed-off-by: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>
> ---
>  drivers/net/virtio_net.c        | 14 +++++++++++---
>  drivers/vdpa/pds/debugfs.c      |  6 ++++++
>  include/linux/virtio_net.h      | 16 ++++++++++------
>  include/uapi/linux/virtio_net.h |  5 +++++
>  4 files changed, 32 insertions(+), 9 deletions(-)

Is there a link to the spec patch? It needs to be accepted first.

Thanks

