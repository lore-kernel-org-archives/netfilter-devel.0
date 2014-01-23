From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [nft PATCH v3] This patch adds the following operation:
Date: Thu, 23 Jan 2014 10:54:23 +0100
Message-ID: <CAOkSjBhCzxOoGsi0QmP6f6kWasyetda-1PoRvgPdedn+Vve=WA@mail.gmail.com>
References: <20140123094743.17227.18043.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:34088 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbaAWJyo convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Jan 2014 04:54:44 -0500
Received: by mail-la0-f51.google.com with SMTP id c6so1275372lan.10
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Jan 2014 01:54:43 -0800 (PST)
In-Reply-To: <20140123094743.17227.18043.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 23 January 2014 10:49, Arturo Borrero Gonzalez
<arturo.borrero.glez@gmail.com> wrote:
>  :~# nft export <xml|json>
>
> The XML/JSON output is provided raw by libnftnl, thus without format.
>
> In case of XML, you can give format with the `xmllint' tool from libx=
ml2-tools:
>  :~# nft list ruleset xml | xmllint --format -
>
> In case of JSON, you can use `json_pp' from perl standar package:
>  :~# nft list ruleset json | json_pp
>
> A format field is added in struct cmd, and it will be reused in the i=
mport
> operation.
>
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com=
>
> ---
> v2: address comments by Patrick: use CMD_OBJ_RULESET, move some inclu=
des, etc.
> v3: rebase against nft's next-3.14 branch.

ops, I lost the subject line :(

--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
