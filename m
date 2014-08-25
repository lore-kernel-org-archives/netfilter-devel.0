From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH 1/2] utils: ensure \0 is in place in
 nft_fprintf()
Date: Mon, 25 Aug 2014 16:09:08 +0200
Message-ID: <20140825140908.GA5147@salvia>
References: <20140825130221.23329.86583.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42079 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755703AbaHYOIm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Aug 2014 10:08:42 -0400
Content-Disposition: inline
In-Reply-To: <20140825130221.23329.86583.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 25, 2014 at 03:02:21PM +0200, Arturo Borrero Gonzalez wrote:
> We must make sure the buffer contains a \0 in the last position,
> to avoid printing trash by the last fprintf() call.

snprintf already guarantees that the string is nul-terminated if there
is enough room to add \0.

        ret = snprintf_cb(buf, bufsiz, obj, type, flags);
        if (ret < 0)
                goto out;

        if (ret >= NFT_SNPRINTF_BUFSIZ) {
                bufsiz = ret + 1;

                buf = malloc(bufsiz);
                if (buf == NULL)
                        return -1;

                ret = snprintf_cb(buf, bufsiz, obj, type, flags);
                if (ret < 0)
                        goto out;
        }

        ret = fprintf(fp, "%s", buf);

I think we have guarantees that buf is always nul-terminated after the
second try.

Patch 2/2 looks good to enough to me since it already resolves the
printed "garbage" at the end of the output issue.
