From: tingwei liu <tingw.liu@gmail.com>
Subject: Re: iptables domain match
Date: Thu, 5 May 2011 11:44:54 +0800
Message-ID: <BANLkTimN31-+_7Jp3RKt78_FVfbt9wmf5w@mail.gmail.com>
References: <BANLkTi=2XpuuqMZgwVggH6-RPH_XvywGyA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53797 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426Ab1EEDoz convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 May 2011 23:44:55 -0400
Received: by pwi15 with SMTP id 15so805995pwi.19
        for <netfilter-devel@vger.kernel.org>; Wed, 04 May 2011 20:44:55 -0700 (PDT)
In-Reply-To: <BANLkTi=2XpuuqMZgwVggH6-RPH_XvywGyA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 3, 2011 at 5:08 PM, tingwei liu <tingw.liu@gmail.com> wrote=
:
> I have written a netfilter match called domain.
> Such as: iptables -A OUTPUT -m domain --domain ".google.com" -j DROP
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 Then it will drop the dns query which domain like
> "www.google.com,news.google.com,mail.google.com,..."
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0iptables -I OUTPUT -m=
 domain --domain "map.google.com" -j ACCEPT
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 Then it will accept the dns query which domain is
> "map.google.com".
> I known this match is trival,but I want to know how to submit this pa=
tch.
>
> Thanks for any response.
>
=E6=80=8E=E4=B9=88=E6=B2=A1=E4=BA=BA=E5=9B=9E=E5=A4=8D=E5=95=8A=EF=BC=9F
=E9=82=A3=E5=B0=B1=E7=94=A8=E6=B1=89=E8=AF=AD=E9=97=AE=E4=B8=80=E4=B8=8B=
=EF=BC=8C=E9=97=AE=E9=A2=98=E5=90=8C=E4=B8=8A=E3=80=82
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
