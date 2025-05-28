Received: from mail-ej1-f67.google.com (mail-ej1-f67.google.com [209.85.218.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDFCB27B4E0;
	Wed, 28 May 2025 13:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748440533; cv=none; b=s1Fnme+U7g5UFQSy0th0kjDph9su5tHiX6uKX09wcMNjVIpgqKfDUmtmct2+XZR/cMudmhYkWS2RxOGDCaGHRAP6p0EYhLJ1qFMfoq4ZoXea/DJ1/wE0+Ez+ffqv4Gxo/cDzkjfH1UfBEbcV2SbXntsFVLzg1oZaqrR2T3z05gI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748440533; c=relaxed/simple;
	bh=cizbWJhNnoTY8XfopW2vv/PcAdMGNagiDc1j7/VnlC0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N00b4cn2IpbDU0PMVUB0Ms6eLyaPO8dAbt/kon5W3tvNb8fUHmyYyLikutIezSnI2rS6hGiP250PjkQZe+/ghmHLtouNUGOF6AQn4dZdL7nbSSJawOrq8ooqvR/PaNSIi1MCOK/INBacd8nQaObJMh0y9dS1Ja49wEnshvaTdRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i2ed7Bfe; arc=none smtp.client-ip=209.85.218.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i2ed7Bfe"
Received: by mail-ej1-f67.google.com with SMTP id a640c23a62f3a-ad89ee255easo152318266b.3;
        Wed, 28 May 2025 06:55:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748440529; x=1749045329; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EE2Weyrrn7JR/8bPBhAPvwqdpmtHybqVorQ0umSeJlc=;
        b=i2ed7BfekULxK8K0wIMtOObISepwWFoo+dGT4qhHmIg/qVr9lvQ39w79Q5Qizg/xL7
         3wqOpGBLZEujQKx0Q9pYlX6xnl1IVJoMzlZhsoxdb5pvT08qagzg6FsocOqOx//sX6GM
         WTyT8yew8ua5s7WvglEX0330/jfHKlp3DbJCbYoGIArdX5qJWJM/yKjuSribC8vBAdUA
         9c0rQl+LwWmEMHgsP56UAi6l3SyfZptkwt/SvjiWkBOkRBCgIT1vy7xS3p7Ug+kcrRSH
         gTngEcOw8V3DjusPd4bgFJC2IRERa5jqwiRBhu3E4LWocvC93JaMCM2g8g+piJAibRdY
         GR1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748440529; x=1749045329;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EE2Weyrrn7JR/8bPBhAPvwqdpmtHybqVorQ0umSeJlc=;
        b=ZkbzAenSGqAtzYgwqcWVl52W2sWK1dOBc+5gt2FjLFP475TaK02W42pHYlX1v1jdNY
         PFVLAdIds/4UayVgOEYYv+Gu+6rskA8t5E+THEpIMZqV5CsNoq5BtWZlB1YcMPXzUgk5
         J+ZBnPyKibmHwGfkmdfjndOyGCmie3VLXzMdM2RkkHJHrwvDlvFJ6KFYyvKL34YJrjIe
         x3aTJTtrKS0BEsHcBnKDvtolwA20iKI2qs7PwxGDHhM7axEGm/zSSjHZ6mS1zoTF0ONP
         XH/XSCkpoKlU4NdjsPVk3F7a6ZRGyr+raLqSQ5yfudr7aFYYqO2sQuGPyNJxdXfUYkKh
         fdAQ==
X-Forwarded-Encrypted: i=1; AJvYcCUPXLTUq6Yx51dU0AznNB0Pj2NE14o55Fm2Pf8/CNhlPJ548ZUrUezI4HSeKDweB54Ec7In4WXfSggBmuUjuKi6@vger.kernel.org, AJvYcCUbROt+bwLEsbuBPQh0ggW6bQYhOKTyC3jZRYJd/3P+4BpOG8iNg8NuWlQrG8W52GzuwUkRxZJD@vger.kernel.org, AJvYcCV+padC0XQQlbcWmlvNRFn8b9/aauH1WTRuHJ4NBX1sVyqaxDFv0GOzbKiydqHz+wZgA91ra9hPMFQVs7Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YxfvuCYDeQRxFuAh1I5YAMoc8b/1UNhfQTJ8VmVxrfsDBW9dEe9
	2aI6+4V8RkvPL8vurXBWeLo3YbfATKmaaUS7C+v2A2ihKgu6qrPo386aEcpT2BlQ5KPQPP+vkqq
	GpdweqmkkYlyiaP3I/e9BaT0G3hvbZ6R6dr4f+lU=
X-Gm-Gg: ASbGnctKJ9C13mQiH0LSVGTMTAbgmA9ggUFcp85n6/EG+Bh4hb04I9YfceOWSsy1iqa
	hg1yGKyDtLuuhMKmmSM7Ds0PKhl08I+dJufQRNOhVM87919JjyTO7hsOKCZ3yrS4QoDyfG5H3YE
	tibufTnsvg0DH6MZ4D/jWU7WNc8xn9e/Eo7w==
X-Google-Smtp-Source: AGHT+IEMNxQwYe0PiRvW6i3nRvxF7iXoyc7113soCxABNzX5iPmSIF/KlgnecMzeHFZ7NAJdXj9IwClcMHKFmkzyqEc=
X-Received: by 2002:a17:907:8dcb:b0:ad5:1fe4:4d0d with SMTP id
 a640c23a62f3a-ad85b2065d0mr1493993766b.61.1748440529052; Wed, 28 May 2025
 06:55:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAN2Y7hxscai7JuC0fPE8DZ3QOPzO_KsE_AMCuyeTYRQQW_mA2w@mail.gmail.com>
 <aDcLIh2lPkAWOVCI@strlen.de> <CAN2Y7hzKd+VxWy56q9ad8xwCcHPy5qoEaswZapnF87YkyYMcsA@mail.gmail.com>
 <a752bbbf-08c0-3885-65ba-79577a1ad5a8@blackhole.kfki.hu>
In-Reply-To: <a752bbbf-08c0-3885-65ba-79577a1ad5a8@blackhole.kfki.hu>
From: ying chen <yc1082463@gmail.com>
Date: Wed, 28 May 2025 21:55:17 +0800
X-Gm-Features: AX0GCFv4WyVGNk1XgwUI6BUykrsR8nrzZf3wKx_YdLMfBB2SmClpyALWr5FpEic
Message-ID: <CAN2Y7hzOXtVGh1d84afxOWv-EcLLUCn+FmH4Yr1OHFBmFVZR4Q@mail.gmail.com>
Subject: Re: [bug report, linux 6.15-rc4] A large number of connections in the
 SYN_SENT state caused the nf_conntrack table to be full.
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc: Florian Westphal <fw@strlen.de>, pablo@netfilter.org, kadlec@netfilter.org, 
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 28, 2025 at 9:41=E2=80=AFPM Jozsef Kadlecsik
<kadlec@blackhole.kfki.hu> wrote:
>
> On Wed, 28 May 2025, ying chen wrote:
>
> > On Wed, May 28, 2025 at 9:10=E2=80=AFPM Florian Westphal <fw@strlen.de>=
 wrote:
> >>
> >> ying chen <yc1082463@gmail.com> wrote:
> >>> Hello all,
> >>>
> >>> I encountered an "nf_conntrack: table full" warning on Linux 6.15-rc4=
.
> >>> Running cat /proc/net/nf_conntrack showed a large number of
> >>> connections in the SYN_SENT state.
> >>> As is well known, if we attempt to connect to a non-existent port, th=
e
> >>> system will respond with an RST and then delete the conntrack entry.
> >>> However, when we frequently connect to non-existent ports, the
> >>> conntrack entries are not deleted, eventually causing the nf_conntrac=
k
> >>> table to fill up.
> >>
> >> Yes, what do you expect to happen?
> > I understand that the conntrack entry should be deleted immediately
> > after receiving the RST reply.
>
> No, the conntrack entry will be in the CLOSE state with the timeout value
> of /proc/sys/net/netfilter/nf_conntrack_tcp_timeout_close
>
> Best regards,
> Jozsef
The conntrack entry does not transition to the CLOSE state and remains
in the SYN_SENT state until the nf_conntrack_tcp_timeout_syn_sent
timeout is reached.
According to the code, the conntrack  entry should be deleted
immediately after the RST reply.
int nf_conntrack_tcp_packet(struct nf_conn *ct,
                            struct sk_buff *skb,
                            unsigned int dataoff,
                            enum ip_conntrack_info ctinfo,
                            const struct nf_hook_state *state)
{
        ......
        if (!test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
                /* If only reply is a RST, we can consider ourselves not to
                   have an established connection: this is a fairly common
                   problem case, so we can delete the conntrack
                   immediately.  --RR */
                if (th->rst) {
                        nf_ct_kill_acct(ct, ctinfo, skb);
                        return NF_ACCEPT;
                }
