From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH v2] iptables-compat: unset context flags in netlink
 delinearize step
Date: Fri, 20 Feb 2015 20:11:11 +0100
Message-ID: <CAOkSjBhaFMPxZ9qKOtHS5wDz3c_K_hcFVD2QdOZUfwN5oJwuSg@mail.gmail.com>
References: <1424302341-21509-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:38043 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754938AbbBTTLe convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Feb 2015 14:11:34 -0500
Received: by lamq1 with SMTP id q1so8066904lam.5
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Feb 2015 11:11:33 -0800 (PST)
In-Reply-To: <1424302341-21509-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 19 February 2015 at 00:32, Pablo Neira Ayuso <pablo@netfilter.org> w=
rote:
> Once the data that the compare expression provides have been digested=
=2E
>
> For example:
>
> -A INPUT -i noexist -p udplite -s 10.10.10.10/32 -d 10.0.0.10/32 -j A=
CCEPT
>
> doesn't show anymore the following broken output via iptables-compat-=
save:
>
> -A INPUT -i
>
> +t -p udplite -s 10.10.10.10/32 -d 10.0.0.10/32 -j ACCEPT
>
> Reported-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  iptables/nft-arp.c    |   12 ++++++++----
>  iptables/nft-ipv4.c   |   14 ++++++++++----
>  iptables/nft-ipv6.c   |   20 ++++++++++++--------
>  iptables/nft-shared.c |    8 ++++++--
>  4 files changed, 36 insertions(+), 18 deletions(-)

It works (v2).

Tested-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>

best regards.

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
