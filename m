Return-Path: <SRS0=Lm+H=63=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2913ACA90AF
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 May 2020 09:28:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 097F620661
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 May 2020 09:28:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="o0I0h87F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbgEMJ2s (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 May 2020 05:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726492AbgEMJ2r (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 May 2020 05:28:47 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 503F8C061A0C
        for <netfilter-devel@vger.kernel.org>; Wed, 13 May 2020 02:28:46 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id i68so13608809qtb.5
        for <netfilter-devel@vger.kernel.org>; Wed, 13 May 2020 02:28:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CdVf4SgFHjgLpfIEcLy499lStPfmxw/48zFjBHeHUoI=;
        b=o0I0h87FDyM286c3gcOI5mhYNuyEOgq9RGYpTSSKT1ETbVz2FAc6i27p0Hc5qLnAuN
         hV3dHivXX/lRNnoWN84E5s3+MCCqWkmUi90fjynLp3s7Ig3nttargqvUNYbTCrXydqfo
         orBLVwfkRho6h149FBqgWWQrEI8PY4uahLh3C2dC2c7jqSwWeWA3of+Cnp4tZCPjQ+jo
         KQHK1VKUnBihJkrBDCqVZdBF3KJvEv5s6bqZ9fETBBX2xAP/Z3JHLHXtFTF+JkyQIg87
         1lFWdjFidUHN0L6cmD+cOpcBySRj2lCZO/AJbzAtu3FCGbJ2jGzO0ok2u0TB6HK6kqt9
         HuCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CdVf4SgFHjgLpfIEcLy499lStPfmxw/48zFjBHeHUoI=;
        b=PrZnsJZg/vKd3zg7ZQBMpcjbLuZlhsm9KJzJqiFQQdBXgFuCxqFeTkLHRLJ4AItxNN
         XAlewSwcbdPZ1sVWhubl7gzOopcSKbPI5lXlsHHMbuvjqUCghey56AWoVOQAh2lIy4Au
         EcRkn86xCQVMyLfADhgYP/LP8PvFtJF+80DsOBNhTqrbv5UQGiUIvM7Z99GlSHV67c7l
         lvSEB0LM8N3syS3M2zyCBxyamSfa3NqHdcspzdBOwcIviVyfoFPzFfMowKln2lt5GwAb
         iwrxGbLl6rOpEHNxrOjAGI3tDGzuHA3qbAHsTPS8H2JTOclQhUXaqJ2tt5xZLONrq0Tk
         mJ9Q==
X-Gm-Message-State: AGi0PuapmYDA8cTvM5fT8ADjgYuerOSclc/7aQdw4RYwazOY9ffGLlj0
        Xh6N1BANa2HU+3r3JV++YxyG4WURgX/GIBfh6vMZ7QpnGIU=
X-Google-Smtp-Source: APiQypLLWL+zJYh56/QnAXykLr4ls5csPc2oYZvuX26lgVFhd34E9IawxXyEkvOTiXiMyq+CRSwuAwFMOwDRAxuM+EE=
X-Received: by 2002:a05:6638:1131:: with SMTP id f17mr547219jar.61.1589362122397;
 Wed, 13 May 2020 02:28:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200513043908.GA25216@f3> <20200513091754.32090-1-jengelh@inai.de>
In-Reply-To: <20200513091754.32090-1-jengelh@inai.de>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Wed, 13 May 2020 02:28:25 -0700
Message-ID: <CANP3RGfNH1m=-rFdkAmGUt3vxFqaGmJnW+RKP-faU6WwOKWoZg@mail.gmail.com>
Subject: Re: [PATCH v3] doc: document danger of applying REJECT to INVALID CTs
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Linux NetDev <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

you still missed: succesful -> successful

On Wed, May 13, 2020 at 2:17 AM Jan Engelhardt <jengelh@inai.de> wrote:
>
> Signed-off-by: Jan Engelhardt <jengelh@inai.de>
> ---
>
> Spello fix near "indiscriminately".
>
>  extensions/libip6t_REJECT.man | 20 ++++++++++++++++++++
>  extensions/libipt_REJECT.man  | 20 ++++++++++++++++++++
>  2 files changed, 40 insertions(+)
>
> diff --git a/extensions/libip6t_REJECT.man b/extensions/libip6t_REJECT.ma=
n
> index 0030a51f..7387436c 100644
> --- a/extensions/libip6t_REJECT.man
> +++ b/extensions/libip6t_REJECT.man
> @@ -30,3 +30,23 @@ TCP RST packet to be sent back.  This is mainly useful=
 for blocking
>  hosts (which won't accept your mail otherwise).
>  \fBtcp\-reset\fP
>  can only be used with kernel versions 2.6.14 or later.
> +.PP
> +\fIWarning:\fP You should not indiscriminately apply the REJECT target t=
o
> +packets whose connection state is classified as INVALID; instead, you sh=
ould
> +only DROP these.
> +.PP
> +Consider a source host transmitting a packet P, with P experiencing so m=
uch
> +delay along its path that the source host issues a retransmission, P_2, =
with
> +P_2 being succesful in reaching its destination and advancing the connec=
tion
> +state normally. It is conceivable that the late-arriving P may be consid=
ered to
> +be not associated with any connection tracking entry. Generating a rejec=
t
> +packet for this packet would then terminate the healthy connection.
> +.PP
> +So, instead of:
> +.PP
> +-A INPUT ... -j REJECT
> +.PP
> +do consider using:
> +.PP
> +-A INPUT ... -m conntrack --ctstate INVALID -j DROP
> +-A INPUT ... -j REJECT
> diff --git a/extensions/libipt_REJECT.man b/extensions/libipt_REJECT.man
> index 8a360ce7..618a766c 100644
> --- a/extensions/libipt_REJECT.man
> +++ b/extensions/libipt_REJECT.man
> @@ -30,3 +30,23 @@ TCP RST packet to be sent back.  This is mainly useful=
 for blocking
>  hosts (which won't accept your mail otherwise).
>  .IP
>  (*) Using icmp\-admin\-prohibited with kernels that do not support it wi=
ll result in a plain DROP instead of REJECT
> +.PP
> +\fIWarning:\fP You should not indiscriminately apply the REJECT target t=
o
> +packets whose connection state is classified as INVALID; instead, you sh=
ould
> +only DROP these.
> +.PP
> +Consider a source host transmitting a packet P, with P experiencing so m=
uch
> +delay along its path that the source host issues a retransmission, P_2, =
with
> +P_2 being succesful in reaching its destination and advancing the connec=
tion
> +state normally. It is conceivable that the late-arriving P may be consid=
ered to
> +be not associated with any connection tracking entry. Generating a rejec=
t
> +packet for this packet would then terminate the healthy connection.
> +.PP
> +So, instead of:
> +.PP
> +-A INPUT ... -j REJECT
> +.PP
> +do consider using:
> +.PP
> +-A INPUT ... -m conntrack --ctstate INVALID -j DROP
> +-A INPUT ... -j REJECT
> --
> 2.26.2
>
Maciej =C5=BBenczykowski, Kernel Networking Developer @ Google
