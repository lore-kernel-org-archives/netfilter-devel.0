Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D262145B2A
	for <netfilter-devel@vger.kernel.org>; Mon, 25 Mar 2024 09:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711359120; cv=none; b=uLb8dpYi5O+Loc4FsvfrDUDEbPFEa3ps8QROkH+UZroYKrBAF2LOPAvHulGymt6q/vlNFRu+tXdXrGX3nyEd2BcM4IzHk8aWhdeBEpqwH7osu/HHUzvaSuCYfYKIpRVz5IQ9HsbQq+/dO7US9TnMZP0IxcbmG+BHv/7wtHYJaLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711359120; c=relaxed/simple;
	bh=5bI4HzJSubN6pz9T+bGjsA6YQ1/b75Ui+SiycC20OA4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=X9vx3Vs/xDGwpDHV2Wux/y8dyaLSA6jZGPZghed/FaRO8QzT4S4H57TppsHceKdmy/iN8UaKJ9tlglHFhzDl85CPPaUDyC3lKT34fvX2kronJAKpr4InQibEd78KopW7WdzCEsRnAbHPzNWBljOuDgXTv3XlFq8d44ct6AR9Ekg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cnybGpuZ; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cnybGpuZ"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a470d7f77eeso512618766b.3
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Mar 2024 02:31:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711359117; x=1711963917; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k/O+PAVY7X3nslL8dBzjON7bDnyND0N6vchQ/CDH+50=;
        b=cnybGpuZsC/lX4qYpuoBZf+iWkXGuKb1gv4hjRnErcACZoDUPxLiRl8Fu+yKJ+HVl2
         GnrM8p6b1QzRiTIA/hYC0hmdewCFsEgpfp+NudLCcDmIWEFDdct2Z3ydPph/pLxsmxAC
         kmZezEK8Juvk7a0YZrW4A0DsznwMt1odYPHxBIkS8xdAllasvggMX3JLLZtWA2jXcnih
         nUNfay24owhrU77JRSd6dtfCxOrpqph1XLvtOKbcE9dYbl8GmT0inEqW/ulfoD1skD+b
         IIFgPZrnQtYuMZxYA5tD3IsEKVmIN+NkwIXgdVj2EHGtqwsxcqSfWEughZz0ztJbI0Cc
         t+bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711359117; x=1711963917;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k/O+PAVY7X3nslL8dBzjON7bDnyND0N6vchQ/CDH+50=;
        b=Lk6KBn2x+AA4k9BDWdoRij7bsRwDGSRUrY7TPvj0xjb9bAsH8CmegZ8NbmOhQFoydD
         0zSeMuw+s4XbjgjbyhC1uDKhzXNgMUd+KQniJoML2LPUMqk2Q4wbnucQzWyVaAeC3aWo
         Ki5OgKTh0ydr71z5zjJ/xuQV90ZQX+YVomL5yh3RKD49MRaRekWM1ZM8jVGawXDeZJaI
         Esin5kWdWOI2awJX01+GEFs4+FU7u3ZQkvbsjMVb6G9/Om7zPzHcumzONU92jqurxgDP
         DJp1YZGkL3hZ4GKYOmwDsF/Tk8ejNrv+4vTtYg9iIKeH/LNPBhbEgyDiEn9DNVasHkXn
         gjqQ==
X-Forwarded-Encrypted: i=1; AJvYcCWdXkGaKCyupLZyKkM7+vTGvH/o8X/qE8+ioOYA3iXac7ewRKL63oc7uHoJfdLzGTv4jlSVpRjFt4mOBjg8dNBkDBKpS+x5UTRixRUhlpHA
X-Gm-Message-State: AOJu0YyKzAoVduGwan+vvXHHTXcfJq1JcYmnqWem9ah9PuwunMKZDEHW
	urTOjqg3ZLWYMflJ9OIiZK2TiefeZJJ+if+4GtJZCRvOLoeku/bneo3BnKkQc+ThK8JGWXcYBGc
	IvtR51b3qylBk9YZPJ+MJtBl2bQ4=
X-Google-Smtp-Source: AGHT+IFhyGiM4TXOs5jceHdDfiBs5aOFZhJYaJMB4g1WfSDzEkaQQyxutnpfHEfLO/J3sibzTNpiuukF8kcG9A2dTKo=
X-Received: by 2002:a17:906:260a:b0:a46:d591:873c with SMTP id
 h10-20020a170906260a00b00a46d591873cmr4600887ejc.18.1711359116479; Mon, 25
 Mar 2024 02:31:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240325031945.15760-1-kerneljasonxing@gmail.com> <ZgFBn1fuSRoDuk1r@calendula>
In-Reply-To: <ZgFBn1fuSRoDuk1r@calendula>
From: Jason Xing <kerneljasonxing@gmail.com>
Date: Mon, 25 Mar 2024 17:31:19 +0800
Message-ID: <CAL+tcoAfZh7uGp5EsRvrSpe3mDjmWzSg-sT_4_r9es9iU4Xxdw@mail.gmail.com>
Subject: Re: [PATCH net-next 0/3] netfilter: use NF_DROP instead of -NF_DROP
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: kadlec@netfilter.org, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org, Jason Xing <kernelxing@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 25, 2024 at 5:19=E2=80=AFPM Pablo Neira Ayuso <pablo@netfilter.=
org> wrote:
>
> On Mon, Mar 25, 2024 at 11:19:42AM +0800, Jason Xing wrote:
> > From: Jason Xing <kernelxing@tencent.com>
> >
> > Just simply replace the -NF_DROP with NF_DROP since it is just zero.
>
> Single patch for this should be fine, thanks.

Okay, I thought every patch should be atomic, so I splitted one into
three. I will squash them :)

>
> There are spots where this happens, and it is not obvious, such as nf_con=
ntrack_in()
>
>         if (protonum =3D=3D IPPROTO_ICMP || protonum =3D=3D IPPROTO_ICMPV=
6) {
>                 ret =3D nf_conntrack_handle_icmp(tmpl, skb, dataoff,
>                                                protonum, state);
>                 if (ret <=3D 0) {
>                         ret =3D -ret;

Yep, it's not that obvious.

>                         goto out;
>                 }
>
> removing signed zero seems more in these cases look more complicated.

Yes, so I have no intention to touch them all. The motivation of this
patch is that I traced back to the use of NF_DROP in history and found
out something strange.

I will send a v2 patch soon.

Thanks,
Jason
