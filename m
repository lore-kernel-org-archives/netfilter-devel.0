Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 074054AEE3
	for <netfilter-devel@vger.kernel.org>; Mon, 20 May 2024 18:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716231564; cv=none; b=d7qH5/4zuX18d0UBVmuy6cjtqflMwLxc1Hkq1vfs3bcJIzPzKWqXDA7sKNiexoBB/bqdK04OiYkIdV2+ajT1dsrqGxBoxiE6DrkoMBsgI86AqeI2v5qFvtNoYIkOuDnBC11Y5R3rBkABn3p5qlk++peER15oPTNEvJ1SPBkAxog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716231564; c=relaxed/simple;
	bh=QKtcsy0ccZAqiY3vgNQioM7kZK/anzLPVDSX3lVMkIs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lZ0oWhvPckx7qz1iVZ2ufSfNCUiqqxO7svAsHP8JbECtPHZssoHdr88fWBX3cAAStFzdG5KxUBOpFUuH74TJDm8B7005RxJeOBEMbinLSPVIBweG9e6IBAU9f4S8ID+Cy7r9GCYlmlYnoWPxctnrTi5CWKkfLWsOucMJuuYNnT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DNA9R9u7; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DNA9R9u7"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5724736770cso16452a12.1
        for <netfilter-devel@vger.kernel.org>; Mon, 20 May 2024 11:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716231561; x=1716836361; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=heqXAbnVIs6qDsQwGx6ClyVFz+xxgmyueiyqevEG7po=;
        b=DNA9R9u7aZI1vkwH26XHv9ZyjDVxnuGtIAYFOs2cjoKor2oiZODDWObRSEy12BD9b0
         +m+HqNE+t+PF82z+Zt6ILO0g8pkpYfFXQCXNhzI2Sa/lVGy1ywoZmRpdCWUV11LZ50ow
         t4IsnZeOZT88GiK8D1SWRAl1UsLqlue2Htw1/G0t19SmE2vtTu5JDLA9rB0sO1S6g+MT
         DG6aqYVvBK7lr0YqQG/veiIKXy1VbJ6ljLsNhOYzPiCBTU/AeT536ewXMdtO/iPmNYaS
         9G/hj773THndBfH/grd+2e7movWocQpoLWwKLjlL8ig5p5PaNSDcxmAA+9cnCn0cLeDN
         OttQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716231561; x=1716836361;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=heqXAbnVIs6qDsQwGx6ClyVFz+xxgmyueiyqevEG7po=;
        b=NyYndVBQGgYsDKHhSM78Zt+m6S/A9Siq3kBMu02NbTYl2VAF63gbiWBQOEv/jUIrCz
         CXbOAcTBZ9mH90StEZqsJZRlavfNBX1UvtPsCRal3q4hcMnr+dLX1LP1aVtbVnQQz/JH
         e2ZIknkU0wVeZ4nDccBQVFE8cGOQFaXR7YzhSBTBjiDMZfoZdKI3AQ3GH6enYgOkM6QQ
         2TJahfRI5u3LNzBi8AS9APFza67pX3CtxVDTQ/c26xTi+UCq0w0sZNfyCuoRqAHu0gXW
         oyMC/aB1eBv9VJhWKn9Qjwfkcf+v19T9iZNHXzaSK+kd5gb62bkITLAHqJTCDtiMFDDm
         Qqww==
X-Gm-Message-State: AOJu0YzynamHCofMWFLVXTVYxfQ2A7RFwouECCMhyNV7Uoz+yTHBcyDe
	WmnQTjdb/VuOZUz9igjh3QaayZ7tYBkbTyUek4BFChUKysHvpkWIzHnPsTaFQh+MHR57w6btRDJ
	5kEXv/wX5hzD69YcBHe4ujEDAbD+HEuzYPrpGddZhjCseHK2woYPs
X-Google-Smtp-Source: AGHT+IFEyqMzyDSInqA3/6R4FSJsPWqffKX+aPP+un4UnVPc921LcaYfxqiJQic7jQ1hLKUVtgDdCW+pQQha/fSFn0o=
X-Received: by 2002:aa7:d5d5:0:b0:576:b1a9:2960 with SMTP id
 4fb4d7f45d1cf-576b1a93178mr268106a12.5.1716231560996; Mon, 20 May 2024
 11:59:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240513220033.2874981-1-aojea@google.com> <Zkszmr7lNVte6iNu@calendula>
 <Zktv4TN-DPvCLCXZ@calendula> <ZkuXgB_Qo5336q4-@calendula> <ZkuasOTMseQKGUr_@calendula>
In-Reply-To: <ZkuasOTMseQKGUr_@calendula>
From: Antonio Ojea <aojea@google.com>
Date: Mon, 20 May 2024 19:59:06 +0100
Message-ID: <CAAdXToQRUiJBzMPGZ7AD_16A-JRZNUrr0aJ20mwaoF7gb92Rqg@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] netfilter: nfqueue: incorrect sctp checksum
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 20, 2024 at 7:47=E2=80=AFPM Pablo Neira Ayuso <pablo@netfilter.=
org> wrote:
>
> On Mon, May 20, 2024 at 08:33:39PM +0200, Pablo Neira Ayuso wrote:
> > On Mon, May 20, 2024 at 05:44:35PM +0200, Pablo Neira Ayuso wrote:
> > > On Mon, May 20, 2024 at 01:27:22PM +0200, Pablo Neira Ayuso wrote:
> > > > On Mon, May 13, 2024 at 10:00:31PM +0000, Antonio Ojea wrote:
> > > > > Fixes the bug described in
> > > > > https://bugzilla.netfilter.org/show_bug.cgi?id=3D1742
> > > > > causing netfilter to drop SCTP packets when using
> > > > > nfqueue and GSO due to incorrect checksum.
> > > > >
> > > > > Patch 1 adds a new helper to process the sctp checksum
> > > > > correctly.
> > > > >
> > > > > Patch 2 adds a selftest regression test.
> > > >
> > > > I am inclined to integrated this into nf.git, I will pick a Fixes: =
tag
> > > > sufficiently old so -stable picks up.
> > >
> > > I have to collapse this chunk, otherwise I hit one issue with missing
> > > exported symbol. No need to resend, I will amend here. Just for the
> > > record.
> >
> > Hm. SCTP GSO support is different too, because it keeps a list of segme=
nts.
> >
> > static int
> > nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenu=
m)
> > {
> > [...]
> >         if ((queue->flags & NFQA_CFG_F_GSO) || !skb_is_gso(skb))
> >                 return __nfqnl_enqueue_packet(net, queue, entry);
> >
> > I think this needs to be:
> >
> >         if ((queue->flags & NFQA_CFG_F_GSO) || !skb_is_gso(skb) || !skb=
_is_gso_sctp(skb))
>
> This is not correct either:
>
>         if (queue->flags & NFQA_CFG_F_GSO) is true, this also needs !skb_=
is_gso_sctp(skb)
>
> I can see the current selftest disables the NFQA_CFG_F_GSO flag (-G
> option in nf_queue test program), I suspect that's why this is working.
>

I see, so I fixed the bug in one direction and regressed in the other
one, let me retest both things locallly

> >                 return __nfqnl_enqueue_packet(net, queue, entry);
> >
> > so SCTP GSO packets enters this path below:
> >
> >         nf_bridge_adjust_skb_data(skb);
> >         segs =3D skb_gso_segment(skb, 0);
> >
> > to deliver separated segments to userspace.
> >
> > Otherwise, I don't see yet how userspace can deal with several SCTP
> > segments, from nf_reinject() there is a list of segments no more.
