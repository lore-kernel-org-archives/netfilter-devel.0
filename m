Return-Path: <SRS0=p5Wx=5L=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97A16C43331
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Mar 2020 18:30:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 701DF20722
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Mar 2020 18:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585247451;
	bh=XhcnQFhJIFgm/uABYCxN/nH2qh/mLvF66rhT0pB4WKY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=EQlBxyrqCjKKYN2eXeqalU7oej/pat9ubn1sdjr6nCE+3srsP0xVDdwZx7DdC79WI
	 zDiOWh96fIzOsN1jBW+KbvjLH0Wz74sGwy8J7JBOc1MCoOEFp1Jg9kyfCeTFearUWm
	 L3QKdel45vzxpIsBN0bTjJVnc1iqcizJGi++fPQw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbgCZSau (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 Mar 2020 14:30:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:40752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727192AbgCZSau (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Mar 2020 14:30:50 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF7802070A;
        Thu, 26 Mar 2020 18:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585247450;
        bh=XhcnQFhJIFgm/uABYCxN/nH2qh/mLvF66rhT0pB4WKY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=1ajKHDrlKbiw/GaqKSyVnJ1/CohCnxJi4BH/YGwCjKDDobUKNfSuN1pw29OtsGUaz
         NpaAr0rycwJmUp5tJICbyj68LYAcI3kdKZ6PiXu7z0L0qT12nx60a61GKbej4xo1iO
         kNyIT11+n+RsYGbelgqGxCtN0Zpw9g1XFq1YOqIk=
Date:   Thu, 26 Mar 2020 11:30:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maciej =?UTF-8?B?xbtlbmN6eWtvd3NraQ==?= <zenczykowski@gmail.com>
Cc:     Maciej =?UTF-8?B?xbtlbmN6eWtvd3NraQ==?= <maze@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>, Chenbo Feng <fengc@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH v2] iptables: open eBPF programs in read only mode
Message-ID: <20200326113048.250e7098@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200326142803.239183-1-zenczykowski@gmail.com>
References: <CAHo-OoxMNBTDZW_xqp1X3SGncM-twAySrdnc=ntS7_e2j0YEaA@mail.gmail.com>
        <20200326142803.239183-1-zenczykowski@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, 26 Mar 2020 07:28:03 -0700 Maciej =C5=BBenczykowski wrote:
> diff --git a/extensions/libxt_bpf.c b/extensions/libxt_bpf.c
> index 92958247..44cdd5cb 100644
> --- a/extensions/libxt_bpf.c
> +++ b/extensions/libxt_bpf.c
> @@ -61,11 +61,22 @@ static const struct xt_option_entry bpf_opts_v1[] =3D=
 {
>  	XTOPT_TABLEEND,
>  };
> =20
> -static int bpf_obj_get(const char *filepath)
> +static int bpf_obj_get_readonly(const char *filepath)
>  {
>  #if defined HAVE_LINUX_BPF_H && defined __NR_bpf && defined BPF_FS_MAGIC
>  	union bpf_attr attr;
> +	// file_flags && BPF_F_RDONLY requires Linux 4.15+ uapi kernel headers
> +#ifdef BPF_F_RDONLY

FWIW the BPF subsystem is about to break uAPI backward-compat and
replace the defines with enums. See commit 1aae4bdd7879 ("bpf: Switch
BPF UAPI #define constants used from BPF program side to enums").

> +	int fd;
> =20
> +	memset(&attr, 0, sizeof(attr));
> +	attr.pathname =3D (__u64) filepath;
> +	attr.file_flags =3D BPF_F_RDONLY;
> +	fd =3D syscall(__NR_bpf, BPF_OBJ_GET, &attr, sizeof(attr));
> +	if (fd >=3D 0) return fd;
> +
> +	// on any error fallback to default R/W access for pre-4.15-rc1 kernels
> +#endif
