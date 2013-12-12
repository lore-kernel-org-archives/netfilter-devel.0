From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [nftables kernel PATCH v2] netfilter: nf_tables: fix
 nft_meta_target module
Date: Thu, 12 Dec 2013 13:40:03 +0100
Message-ID: <CAOkSjBhcYQQH8+J9cBL_BcD1kwc-Ho+J3Ytg-fXEYA+YAdio_A@mail.gmail.com>
References: <20131212111201.4462.9945.stgit@nfdev.cica.es> <52A9ABA5.4020200@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:53782 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab3LLMkY convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Dec 2013 07:40:24 -0500
Received: by mail-la0-f50.google.com with SMTP id el20so258693lab.9
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Dec 2013 04:40:23 -0800 (PST)
In-Reply-To: <52A9ABA5.4020200@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 12 December 2013 13:27, Tomasz Bursztyka
<tomasz.bursztyka@linux.intel.com> wrote:
> You have to move NFTA_META_VALUE after NFTA_META_KEY, or then it will=
 break
> with 3.13 kernel API version.
> (your patch is going to be part of 3.14 I guess)

OK :(

> Besides that the _match/_target naming looks still awkward to me.
> But _get/_set would be more "semantically relevant" imho.
>

Sounds good. @pablo, what do you think?

Thanks Tomasz for your time.

regards
--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
