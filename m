Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B71EB1F9428
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Jan 2025 12:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736339280; cv=none; b=LhfaBlkBLcZ3xprQV7XuohnD+8UcYrCbHu7bzE8TGZ0ezrL5yM2sUZN3PoLb7b1Lc0iR4UfvFBw8JkdH5+H1pG4NmAve5yqD3ftyEDKkv+4D1UI0+lOyN+xYllPB4ztNtqMDn3Xk2z89WAdett9GRVlT7NYwwEHrEg31GXmfkH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736339280; c=relaxed/simple;
	bh=XnLemeL4IHrhEImF6ctGxz/BFHYds4mn0cQmO+AnjTc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E3xDw+XEuwqZO5PErFxITd9B7Jci0K2UxSzJEh3Up4Lq066zoOtdgdkcQKnzbI5TDw1eU0zkL1wIy4jcuHD/9wrXhEixMaRL1AP2oVnpj+aArOH58XpoIrmMafTM1oXdih6PcAXGtkfOHilnV1tGIIMD67gAoihCnGoghCmQJ8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dpOUDf0w; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dpOUDf0w"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736339276;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CE+ieq2Nnj1SjMfQGTDo5V1UJ6zv6x6ViYgzrgENqg0=;
	b=dpOUDf0weDhWqHhyoIzZsqpSsrMU71Q4LyvD90jEJshrFb6O9TY+fmWghIBO40Wek3dggv
	3mouxbHkQtP3oxIZbB0ENuLmu77Jssqvnacifiy+5/PDGE3YQT9wwBtx0lm0/ava6YOKgw
	nod38Bq5JunEmbNPagDIbHLLSvFKyp0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-645-4048eRoPNheimbxRySK8Zw-1; Wed, 08 Jan 2025 07:27:55 -0500
X-MC-Unique: 4048eRoPNheimbxRySK8Zw-1
X-Mimecast-MFC-AGG-ID: 4048eRoPNheimbxRySK8Zw
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-43651b1ba8aso112989535e9.1
        for <netfilter-devel@vger.kernel.org>; Wed, 08 Jan 2025 04:27:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736339274; x=1736944074;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CE+ieq2Nnj1SjMfQGTDo5V1UJ6zv6x6ViYgzrgENqg0=;
        b=jjP2RDesvLHZR/PtICnR4llAmsjt9QwbVtdow8sC3e2ezyjUHL5u6cjYtfho9hbtv7
         DdYL9Bs5tWHPN/srps1a93NaJZtR0WhxUNBB5WgJlpKeBVL8U5A4gwdeTrSdQwResnWg
         m5xZVO2Xiboow5qbg98umRJbucCoNLvOSEfjmJ2ieT3mo8L28L/tB7Jk3PaXMcwpjGPu
         dAl/xbtKxELoNW0LkSGzXGipYUt39IbYhEc5YAIlcVGD9IwP30kTEA8Og3uIYlwX0lHN
         6wV8yi9M46SxUsHZBzmoqi0xnfjhP4mGdUaDg7rW7769/fCObDWjDFKLOG5/M+/h0xwA
         c3qQ==
X-Forwarded-Encrypted: i=1; AJvYcCX3vITQVwQuEyiiE97jK3EU3E9iMa0TbXQnOXnL+AXEr6obXQpPh653hqgce2SgOXRnQdWQoq4vJ5k6xGDFHKs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyrpz6aDzt85Y+uqifW/7+9xfFGyq8OKiYs447CMhB7YbMfyDXZ
	GBw901KTKtmSstMrqvMT+tLbFGG7ATnDAbMQdn2uR1Ky09ePK/qXXiD6QCYXCTOj3qyCUBwlIa5
	ybmkgxKDgvAaDeoeAvJcyoOK3iu7z79IJuB74PJ/ZWt4sXstqyP+LnCa54BloqYpX1w==
X-Gm-Gg: ASbGncvGjlUdxv4Q+WkVZhpsD0b3qEWrwP0cBc8/KYo5dqlFbCLTeR3+lKXon94OwdV
	BZJzBA4Zu3LW8fWaqOHDxKMxvB1j88O5ZWi8L/qctdgPzjGIUCZF/TBrGcok8JsL8S6LMTbvXQ0
	+s4lbkVaW4nP3rL0eIMPsJrksqcp9zzNwvyr6o8ge7TKz40eLt+yGLY0ApGDL66L03EAf55c5fb
	/+tjkh8tEniOFJxf2IEAhu8UKHbvf2eJEOigCbPMr0wtA4nQTI=
X-Received: by 2002:a05:600c:511f:b0:436:1b96:7072 with SMTP id 5b1f17b1804b1-436e26867f6mr21831175e9.5.1736339274369;
        Wed, 08 Jan 2025 04:27:54 -0800 (PST)
X-Google-Smtp-Source: AGHT+IENxKhGDHesgYkFwNwBJXCiFFCpFk4h9OPIuCpP1RPQAdqKF9uWZeo5HUnJYIpAberSrBMGeQ==
X-Received: by 2002:a05:600c:511f:b0:436:1b96:7072 with SMTP id 5b1f17b1804b1-436e26867f6mr21830685e9.5.1736339273849;
        Wed, 08 Jan 2025 04:27:53 -0800 (PST)
Received: from redhat.com ([2a02:14f:175:d62d:93ef:d7e2:e7da:ed72])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-436e2e89dfesm19211805e9.32.2025.01.08.04.27.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2025 04:27:53 -0800 (PST)
Date: Wed, 8 Jan 2025 07:27:45 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "Chia-Yu Chang (Nokia)" <chia-yu.chang@nokia-bell-labs.com>
Cc: Jason Wang <jasowang@redhat.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"dsahern@gmail.com" <dsahern@gmail.com>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"edumazet@google.com" <edumazet@google.com>,
	"dsahern@kernel.org" <dsahern@kernel.org>,
	"pabeni@redhat.com" <pabeni@redhat.com>,
	"joel.granados@kernel.org" <joel.granados@kernel.org>,
	"kuba@kernel.org" <kuba@kernel.org>,
	"andrew+netdev@lunn.ch" <andrew+netdev@lunn.ch>,
	"horms@kernel.org" <horms@kernel.org>,
	"pablo@netfilter.org" <pablo@netfilter.org>,
	"kadlec@netfilter.org" <kadlec@netfilter.org>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"coreteam@netfilter.org" <coreteam@netfilter.org>,
	"shenjian15@huawei.com" <shenjian15@huawei.com>,
	"salil.mehta@huawei.com" <salil.mehta@huawei.com>,
	"shaojijie@huawei.com" <shaojijie@huawei.com>,
	"saeedm@nvidia.com" <saeedm@nvidia.com>,
	"tariqt@nvidia.com" <tariqt@nvidia.com>,
	"xuanzhuo@linux.alibaba.com" <xuanzhuo@linux.alibaba.com>,
	"eperezma@redhat.com" <eperezma@redhat.com>,
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
	"ij@kernel.org" <ij@kernel.org>,
	"ncardwell@google.com" <ncardwell@google.com>,
	"Koen De Schepper (Nokia)" <koen.de_schepper@nokia-bell-labs.com>,
	"g.white@cablelabs.com" <g.white@cablelabs.com>,
	"ingemar.s.johansson@ericsson.com" <ingemar.s.johansson@ericsson.com>,
	"mirja.kuehlewind@ericsson.com" <mirja.kuehlewind@ericsson.com>,
	"cheshire@apple.com" <cheshire@apple.com>,
	"rs.ietf@gmx.at" <rs.ietf@gmx.at>,
	"Jason_Livingood@comcast.com" <Jason_Livingood@comcast.com>,
	"vidhi_goel@apple.com" <vidhi_goel@apple.com>
Subject: Re: [PATCH v6 net-next 11/14] virtio_net: Accurate ECN flag in
 virtio_net_hdr
Message-ID: <20250108072548-mutt-send-email-mst@kernel.org>
References: <20241227191211.12485-1-chia-yu.chang@nokia-bell-labs.com>
 <20241227191211.12485-12-chia-yu.chang@nokia-bell-labs.com>
 <CACGkMEu990O+2Sedj+ASv0P5TnZR9THiOdHmx=L0hOxQRXPcsg@mail.gmail.com>
 <PAXPR07MB79849952690901A50688EFEDA3092@PAXPR07MB7984.eurprd07.prod.outlook.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <PAXPR07MB79849952690901A50688EFEDA3092@PAXPR07MB7984.eurprd07.prod.outlook.com>

On Mon, Dec 30, 2024 at 09:50:59AM +0000, Chia-Yu Chang (Nokia) wrote:
> >From: Jason Wang <jasowang@redhat.com> 
> >Sent: Monday, December 30, 2024 8:52 AM
> >To: Chia-Yu Chang (Nokia) <chia-yu.chang@nokia-bell-labs.com>
> >Cc: netdev@vger.kernel.org; dsahern@gmail.com; davem@davemloft.net; edumazet@google.com; dsahern@kernel.org; pabeni@redhat.com; joel.granados@kernel.org; kuba@kernel.org; andrew+netdev@lunn.ch; horms@kernel.org; pablo@netfilter.org; kadlec@netfilter.org; netfilter-devel@vger.kernel.org; coreteam@netfilter.org; shenjian15@huawei.com; salil.mehta@huawei.com; shaojijie@huawei.com; saeedm@nvidia.com; tariqt@nvidia.com; mst@redhat.com; xuanzhuo@linux.alibaba.com; eperezma@redhat.com; virtualization@lists.linux.dev; ij@kernel.org; ncardwell@google.com; Koen De Schepper (Nokia) <koen.de_schepper@nokia-bell-labs.com>; g.white@cablelabs.com; ingemar.s.johansson@ericsson.com; mirja.kuehlewind@ericsson.com; cheshire@apple.com; rs.ietf@gmx.at; Jason_Livingood@comcast.com; vidhi_goel@apple.com
> >Subject: Re: [PATCH v6 net-next 11/14] virtio_net: Accurate ECN flag in virtio_net_hdr
> >
> >[You don't often get email from jasowang@redhat.com. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> >
> >CAUTION: This is an external email. Please be very careful when clicking links or opening attachments. See the URL nok.it/ext for additional information.
> >
> >
> >
> >On Sat, Dec 28, 2024 at 3:13 AM <chia-yu.chang@nokia-bell-labs.com> wrote:
> >>
> >> From: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>
> >>
> >> Unlike RFC 3168 ECN, accurate ECN uses the CWR flag as part of the ACE 
> >> field to count new packets with CE mark; however, it will be corrupted 
> >> by the RFC 3168 ECN-aware TSO. Therefore, fallback shall be applied by 
> >> seting NETIF_F_GSO_ACCECN to ensure that the CWR flag should not be 
> >> changed within a super-skb.
> >>
> >> To apply the aforementieond new AccECN GSO for virtio, new featue bits 
> >> for host and guest are added for feature negotiation between driver 
> >> and device. And the translation of Accurate ECN GSO flag between 
> >> virtio_net_hdr and skb header for NETIF_F_GSO_ACCECN is also added to 
> >> avoid CWR flag corruption due to RFC3168 ECN TSO.
> >>
> >> Signed-off-by: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>
> >> ---
> >>  drivers/net/virtio_net.c        | 14 +++++++++++---
> >>  drivers/vdpa/pds/debugfs.c      |  6 ++++++
> >>  include/linux/virtio_net.h      | 16 ++++++++++------
> >>  include/uapi/linux/virtio_net.h |  5 +++++
> >>  4 files changed, 32 insertions(+), 9 deletions(-)
> >
> >Is there a link to the spec patch? It needs to be accepted first.
> >
> >Thanks
> 
> Hi Jason,
> 
> Thanks for the feedback, I found the virtio-spec in github: https://github.com/oasis-tcs/virtio-spec but not able to find the procedure to propose.
> Could you help to share the procedure to propose spec patch? Thanks.


You post it on virtio-comment for discussion. Github issues are then used
for voting and to track acceptance.
https://github.com/oasis-tcs/virtio-spec/blob/master/README.md#use-of-github-issues


> --
> Chia-Yu

