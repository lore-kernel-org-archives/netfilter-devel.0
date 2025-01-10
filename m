Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 593E62063D9
	for <netfilter-devel@vger.kernel.org>; Fri, 10 Jan 2025 06:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736490516; cv=none; b=frjYwgkRdIr3JfPJia1HZnOpuKAWplWOZspEAk4/Ocwo8dsAZj3TuKmnbrOnX779gwWLhAmIidkLH0J2RXTG+3eDNiiOJpgHzPEizN8Ux6NnWMf21z8iQu4+YojtjxgwgS8H4JbgKnaP2V28rC+u+Tt0fio4HGJzhORCobFYHL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736490516; c=relaxed/simple;
	bh=FMqJ7naQjmlWyErCDh0m1Os/KqRSP9MKroOgTnaF1hc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BjydTGuJmxAqlVeAkL2OrKSWN1XMB2y21E5vhIWzPBEsXIuqPuw0/wDiVl9Bah3h4eqnTM1taXfvh+JfiQ2eOcdq06Vwg5yA2O+pnZvCn2cpXZx5mbTd+/JM0pnioQ08+v2IR4W5UnJykF3MGALkGDEt5QfFjutTHLNsx2d0oiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GjlAVJSG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GjlAVJSG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736490513;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KidJbubUSbaHzABwf67ALlasvoQwAnREDKg8gDCC2p8=;
	b=GjlAVJSG82uF97qSjHmNMCuOzoPaOkg2RRRq2PoO6luPNycGSeBOTSr6tkFTcqvoMLgnGw
	IOadN8h8DCIJYEu35UgTuHXeGADL7rPx2V+pKigrgDwDDPZ55ShflQEHUfrz2/+1/rlDDi
	nosjfd61eHvvDbP69xSLs6uYBMolVWI=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-605-i06ylfAMO8KiVj3E7Xf_Uw-1; Fri, 10 Jan 2025 01:28:31 -0500
X-MC-Unique: i06ylfAMO8KiVj3E7Xf_Uw-1
X-Mimecast-MFC-AGG-ID: i06ylfAMO8KiVj3E7Xf_Uw
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-2ef775ec883so3105161a91.1
        for <netfilter-devel@vger.kernel.org>; Thu, 09 Jan 2025 22:28:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736490511; x=1737095311;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KidJbubUSbaHzABwf67ALlasvoQwAnREDKg8gDCC2p8=;
        b=rA6L5LKPb6SFbrc2ufLbqsl0egdgA1nO8Pnnb6VDdxpxH08tEexIgTS9ki6NZmsNW4
         37YMHKa5KjUXmd94mBUS4tGLobVr6aP0hDHoXqAKI35tBOERT+CwROVtUI6rLHSE9Fjv
         hoS5l9r0OnPYZ0YckJOMbkFCRtDuVF2mQhzdBnqv+b0IUAj9uvc7wFFrSCZdGXW7FTmm
         S4Ag0zWn0/A9aHRpDKbbA/WbMvBcGdKFIvAqQRSS1mj0/KFap8Di1KvmSNLEh0TU/73v
         45RSENUEsJ+SOYChFViNAlga5aH1iVupyx960+D6OHtRdqsQfiYzh0SsmfTTkfDg4f1o
         p2dA==
X-Forwarded-Encrypted: i=1; AJvYcCVyss5ATMQEpj7PmgCDCuQty+piRWQ54Qcbp9g/JGomfqTVDFYlBmClSNhzC+vpkc3KsJkauXl/vYWPdnqbZxI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yya3WM2TtKYPMhfp1KiUhUcmb1v4kOIzgdI62DlZmvDgtU8+8UL
	J8Q8YTFtzPnYJ0Nt4zCVqCERBgzsv0BlZK1O9DByRld8DQFBOL0aK/PJKB8HSMz7QTiTd7P7SDC
	RcqzY3g0F+EjuvbhjFFFNx2O2IqqXpDgPkGWk+7VyGZUkSvQfivSu/TY5zjyPzV8To0fUF6tZFx
	idOqtn+rKkMzZn2qvgtqtIg1P0X1Mc8K+vDgV/XijC
X-Gm-Gg: ASbGnctxLRpQsyQt2DPFbCPqa8ncI1DwjARxhLWuci+K2HQJ9pZDBPrgH/AjR+h05as
	YNZicNlhszYXR6W066SAmzpk16YPPLXI/+Aw5abU=
X-Received: by 2002:a17:90b:51cb:b0:2ef:3192:d280 with SMTP id 98e67ed59e1d1-2f548f162acmr13802124a91.5.1736490510817;
        Thu, 09 Jan 2025 22:28:30 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEp0/BM7o0tEEC723P2ISeuSUTQVVQ33mQotWanfawICGwc51DjRSX4yb/t8dyOagdAuanru9FGx4KAnLdQtHQ=
X-Received: by 2002:a17:90b:51cb:b0:2ef:3192:d280 with SMTP id
 98e67ed59e1d1-2f548f162acmr13802075a91.5.1736490510354; Thu, 09 Jan 2025
 22:28:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241227191211.12485-1-chia-yu.chang@nokia-bell-labs.com>
 <20241227191211.12485-12-chia-yu.chang@nokia-bell-labs.com>
 <CACGkMEu990O+2Sedj+ASv0P5TnZR9THiOdHmx=L0hOxQRXPcsg@mail.gmail.com> <PAXPR07MB79849952690901A50688EFEDA3092@PAXPR07MB7984.eurprd07.prod.outlook.com>
In-Reply-To: <PAXPR07MB79849952690901A50688EFEDA3092@PAXPR07MB7984.eurprd07.prod.outlook.com>
From: Jason Wang <jasowang@redhat.com>
Date: Fri, 10 Jan 2025 14:28:18 +0800
X-Gm-Features: AbW1kvaTgRZIZgzRWrIQzrtZd7X6glRAsDjE7ywFuxLA5XjNWNs_FA7giy52KJg
Message-ID: <CACGkMEvNR4rGnC78Mybext7z6jqdBtPfz544_SPXs0t3wUMP8A@mail.gmail.com>
Subject: Re: [PATCH v6 net-next 11/14] virtio_net: Accurate ECN flag in virtio_net_hdr
To: "Chia-Yu Chang (Nokia)" <chia-yu.chang@nokia-bell-labs.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "dsahern@gmail.com" <dsahern@gmail.com>, 
	"davem@davemloft.net" <davem@davemloft.net>, "edumazet@google.com" <edumazet@google.com>, 
	"dsahern@kernel.org" <dsahern@kernel.org>, "pabeni@redhat.com" <pabeni@redhat.com>, 
	"joel.granados@kernel.org" <joel.granados@kernel.org>, "kuba@kernel.org" <kuba@kernel.org>, 
	"andrew+netdev@lunn.ch" <andrew+netdev@lunn.ch>, "horms@kernel.org" <horms@kernel.org>, 
	"pablo@netfilter.org" <pablo@netfilter.org>, "kadlec@netfilter.org" <kadlec@netfilter.org>, 
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>, 
	"coreteam@netfilter.org" <coreteam@netfilter.org>, "shenjian15@huawei.com" <shenjian15@huawei.com>, 
	"salil.mehta@huawei.com" <salil.mehta@huawei.com>, "shaojijie@huawei.com" <shaojijie@huawei.com>, 
	"saeedm@nvidia.com" <saeedm@nvidia.com>, "tariqt@nvidia.com" <tariqt@nvidia.com>, "mst@redhat.com" <mst@redhat.com>, 
	"xuanzhuo@linux.alibaba.com" <xuanzhuo@linux.alibaba.com>, "eperezma@redhat.com" <eperezma@redhat.com>, 
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>, "ij@kernel.org" <ij@kernel.org>, 
	"ncardwell@google.com" <ncardwell@google.com>, 
	"Koen De Schepper (Nokia)" <koen.de_schepper@nokia-bell-labs.com>, 
	"g.white@cablelabs.com" <g.white@cablelabs.com>, 
	"ingemar.s.johansson@ericsson.com" <ingemar.s.johansson@ericsson.com>, 
	"mirja.kuehlewind@ericsson.com" <mirja.kuehlewind@ericsson.com>, "cheshire@apple.com" <cheshire@apple.com>, 
	"rs.ietf@gmx.at" <rs.ietf@gmx.at>, 
	"Jason_Livingood@comcast.com" <Jason_Livingood@comcast.com>, "vidhi_goel@apple.com" <vidhi_goel@apple.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 30, 2024 at 5:51=E2=80=AFPM Chia-Yu Chang (Nokia)
<chia-yu.chang@nokia-bell-labs.com> wrote:
>
> >From: Jason Wang <jasowang@redhat.com>
> >Sent: Monday, December 30, 2024 8:52 AM
> >To: Chia-Yu Chang (Nokia) <chia-yu.chang@nokia-bell-labs.com>
> >Cc: netdev@vger.kernel.org; dsahern@gmail.com; davem@davemloft.net; edum=
azet@google.com; dsahern@kernel.org; pabeni@redhat.com; joel.granados@kerne=
l.org; kuba@kernel.org; andrew+netdev@lunn.ch; horms@kernel.org; pablo@netf=
ilter.org; kadlec@netfilter.org; netfilter-devel@vger.kernel.org; coreteam@=
netfilter.org; shenjian15@huawei.com; salil.mehta@huawei.com; shaojijie@hua=
wei.com; saeedm@nvidia.com; tariqt@nvidia.com; mst@redhat.com; xuanzhuo@lin=
ux.alibaba.com; eperezma@redhat.com; virtualization@lists.linux.dev; ij@ker=
nel.org; ncardwell@google.com; Koen De Schepper (Nokia) <koen.de_schepper@n=
okia-bell-labs.com>; g.white@cablelabs.com; ingemar.s.johansson@ericsson.co=
m; mirja.kuehlewind@ericsson.com; cheshire@apple.com; rs.ietf@gmx.at; Jason=
_Livingood@comcast.com; vidhi_goel@apple.com
> >Subject: Re: [PATCH v6 net-next 11/14] virtio_net: Accurate ECN flag in =
virtio_net_hdr
> >
> >[You don't often get email from jasowang@redhat.com. Learn why this is i=
mportant at https://aka.ms/LearnAboutSenderIdentification ]
> >
> >CAUTION: This is an external email. Please be very careful when clicking=
 links or opening attachments. See the URL nok.it/ext for additional inform=
ation.
> >
> >
> >
> >On Sat, Dec 28, 2024 at 3:13=E2=80=AFAM <chia-yu.chang@nokia-bell-labs.c=
om> wrote:
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
> Thanks for the feedback, I found the virtio-spec in github: https://githu=
b.com/oasis-tcs/virtio-spec but not able to find the procedure to propose.
> Could you help to share the procedure to propose spec patch? Thanks.

Sorry for the late reply.

You can start by subscribing to virtio-dev and send a spec patch there.

Thanks

>
> --
> Chia-Yu

