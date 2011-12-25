From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: [PATCH] netfilter: ctnetlink: get and zero operations must be atomic
Date: Sun, 25 Dec 2011 22:09:24 +0800
Message-ID: <CABa6K_Ev77vYC7sFphT5CNAOMRMChVi-Lxoww_zODVBCCb-vdw@mail.gmail.com>
References: <1324734508-15043-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net,
	eric.dumazet@gmail.com
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:48931 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362Ab1LYOJq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 25 Dec 2011 09:09:46 -0500
Received: by vcbfk14 with SMTP id fk14so8131974vcb.19
        for <netfilter-devel@vger.kernel.org>; Sun, 25 Dec 2011 06:09:45 -0800 (PST)
In-Reply-To: <1324734508-15043-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Dec 24, 2011 at 9:48 PM,  <pablo@netfilter.org> wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
>
> The get and zero operations have to be done in an atomic context,
> otherwise counters added between them will be lost.
>
> This problem was spotted by Changli Gao while discussing the
> nfacct infrastructure.
>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Reviewed-by: Changli Gao <xiaosuo@gmail.com>

-- 
Regards,
Changli Gao(xiaosuo@gmail.com)
