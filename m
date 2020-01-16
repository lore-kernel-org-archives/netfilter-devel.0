Return-Path: <SRS0=22nV=3F=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92999C33CB1
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jan 2020 14:48:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F1E320684
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jan 2020 14:48:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbgAPOsi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Jan 2020 09:48:38 -0500
Received: from correo.us.es ([193.147.175.20]:54634 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726370AbgAPOsi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Jan 2020 09:48:38 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6D8604FFE0F
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Jan 2020 15:48:36 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5E117DA70F
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Jan 2020 15:48:36 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 53637DA702; Thu, 16 Jan 2020 15:48:36 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 52833DA713;
        Thu, 16 Jan 2020 15:48:34 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 16 Jan 2020 15:48:34 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 3510E42EF9E1;
        Thu, 16 Jan 2020 15:48:34 +0100 (CET)
Date:   Thu, 16 Jan 2020 15:48:33 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next v4 00/10] netfilter: nft_bitwise: shift support
Message-ID: <20200116144833.jeshvfqvjpbl6fez@salvia>
References: <20200115213216.77493-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200115213216.77493-1-jeremy@azazel.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jan 15, 2020 at 09:32:06PM +0000, Jeremy Sowden wrote:
> The connmark xtables extension supports bit-shifts.  Add support for
> shifts to nft_bitwise in order to allow nftables to do likewise, e.g.:
> 
>   nft add rule t c oif lo ct mark set meta mark << 8 | 0xab
>   nft add rule t c iif lo meta mark & 0xff 0xab ct mark set meta mark >> 8
> 
> Changes since v3:
> 
>   * the length of shift values sent by nft may be less than sizeof(u32).
> 
> Changes since v2:
> 
>   * convert NFTA_BITWISE_DATA from u32 to nft_data;
>   * add check that shift value is not too large;
>   * use BITS_PER_TYPE to get the size of u32, rather than hard-coding it
>     when evaluating shifts.

Series applied, thanks.

I made a few updates:

* Replaced -EINVAL by -EOPNOTSUPP in case NFTA_BITWISE_OP is not
  supported. -EINVAL is usually reserved to missing netlink attribute /
  malformed netlink message (actually, you can find many spots where
  this is a bit overloaded with different "meanings", but just trying
  to stick to those semantics here).

* Replaced:

        return nft_bitwise_init_bool(priv, tb);

  by:

        err = nft_bitwise_init_bool(priv, tb);
        break;
  }

  return err;

  in a few spots, I hope I did not break anything.

I tend to find that easier to read today, minor things like this are
very much debatable.

Thanks.
