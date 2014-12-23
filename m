From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] add systemd service file
Date: Tue, 23 Dec 2014 15:20:27 +0100
Message-ID: <20141223142027.GA17448@salvia>
References: <20141219140258.787a4c4e@turingmachine>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: =?iso-8859-1?Q?J=F6rg?= Thalheim <joerg@higgsboson.tk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43398 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754155AbaLWOR5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Dec 2014 09:17:57 -0500
Content-Disposition: inline
In-Reply-To: <20141219140258.787a4c4e@turingmachine>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 19, 2014 at 02:02:58PM +0100, J=F6rg Thalheim wrote:
> Signed-off-by: J=F6rg Thalheim <joerg@higgsboson.tk>
> ---
>  configure.ac                   | 34 ++++++++++++++++++++++++++++++++=
++
>  files/Makefile.am              |  3 ++-
>  files/nftables/nftables.conf   |  0
>  files/systemd/Makefile.am      | 12 ++++++++++++
>  files/systemd/nftables-reload  | 16 ++++++++++++++++
>  files/systemd/nftables.service | 12 ++++++++++++
>  6 files changed, 76 insertions(+), 1 deletion(-)
>  create mode 100644 files/nftables/nftables.conf
>  create mode 100644 files/systemd/Makefile.am
>  create mode 100755 files/systemd/nftables-reload
>  create mode 100644 files/systemd/nftables.service

I'd prefer if distributors take care of this instead, I think these
scripts are glue integration code. Looking at what it happened to
other userspace netfilter codebase, my experience is that they tend to
get rotten unmaintained in the source code tree.

Thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
