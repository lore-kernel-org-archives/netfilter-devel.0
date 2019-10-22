Return-Path: <SRS0=RVZI=YP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE61FCA9EA0
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Oct 2019 10:37:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B467E20B7C
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Oct 2019 10:37:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="bZvVYvLU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388423AbfJVKhm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Oct 2019 06:37:42 -0400
Received: from kadath.azazel.net ([81.187.231.250]:56778 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388327AbfJVKhm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Oct 2019 06:37:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=yPvm82AV4YFf790SBdVQIpp7rBjEGg1cMk2RPR3++zk=; b=bZvVYvLUBVtGv8IMEcEfuYd9Xp
        +FsFdS6zl48HRqJEVJF3UkUtPtL9uwrSfCA78JUtGy1sM/X6BzPSSZrCBf4ZRWpGYnBi86JRoHJvf
        eq+F0D5plfnvMTI+zEgeaPQ1Ki8nX7n8TFF8iOYA1qPXXjkNtu8v0WzgOWCdwi3XX9jqJZnwuPsop
        BIRiCzkEzPmFP52V1XBmk6cK4ME2ELdxcS9PLkzK5XPfExkjonEWklrnCy+Q0g+0QzJqTRnonzrl+
        JRHmNqGWNQovcx4mLD3JxsYHVsEmRGuAG1TxGlmqGK/LtDiKZtrF6T+dSCAeDJxHi99f8PltpgbA3
        aGakYp7A==;
Received: from ulthar.dreamlands ([192.168.96.2] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iMrXo-0002Oz-2Y; Tue, 22 Oct 2019 11:37:40 +0100
Date:   Tue, 22 Oct 2019 11:37:38 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft v3 0/2] Add option to omit sets elements from
 listings.
Message-ID: <20191022103723.GA14764@azazel.net>
References: <20191021214922.8943-1-jeremy@azazel.net>
 <20191022074156.bhz3dfxg6kdcllu2@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="U+BazGySraz5kW0T"
Content-Disposition: inline
In-Reply-To: <20191022074156.bhz3dfxg6kdcllu2@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 192.168.96.2
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--U+BazGySraz5kW0T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2019-10-22, at 09:41:56 +0200, Pablo Neira Ayuso wrote:
> On Mon, Oct 21, 2019 at 10:49:20PM +0100, Jeremy Sowden wrote:
> > From https://bugzilla.netfilter.org/show_bug.cgi?id=1374:
> >
> >   Listing an entire ruleset or a table with 'nft list ...' will also
> >   print all elements of all set definitions within the ruleset or
> >   requested table. Seeing the full set contents is not often
> >   necessary especially when requesting to see someone's ruleset for
> >   help and support purposes. It would be helpful if there was an
> >   option/flag for the nft tool to suppress set contents when
> >   listing.
> >
> > This patch series implements the request by adding a new option:
> > `-t`, `--terse`.
>
> Series applied, thanks Jeremy.

Cheers.

While I was testing this, I noticed what appears to be an error in the
documentation.  From the man-page:

  SET STATEMENT
    The set statement is used to dynamically add or update elements in a
    set from the packet path. The set setname must already exist in the
    given table and must have been created with the dynamic flag.
    Furthermore, these sets must specify both a maximum set size (to
    prevent memory exhaustion) and a timeout (so that number of entries
    in set will not grow indefinitely). The set statement can be used to
    e.g. create dynamic blacklists.

In the following example it then defines a set as follows:

  nft add set ip filter blackhole \
    { type ipv4_addr; flags timeout; size 65536; }

There is no `dynamic` flag.  In my testing, I also omitted the `dynamic`
flag by accident, and inadvertently verified that it is indeed not neces-
sary.  AFAICT, from a far from thorough investigation, it (or rather
`NFT_SET_EVAL`) is only meaningful for the anonymous sets implicitly
created by meter definitions such as this from the same example:

  nft add rule ip filter input tcp flags syn tcp dport ssh \
    meter flood size 128000 \
    { ip saddr timeout 10s limit rate over 10/second } \
    add @blackhole { ip saddr timeout 1m } drop

Another related quirk (I've used the arp family in this example 'cause
it's empty on my dev box):

  # nft add table arp t
  # nft add set arp t s \
  > '{ type ipv4_addr ; size 256 ; flags dynamic,timeout; }'
  # nft list sets table arp t
  table arp t {
          set s {
                  type ipv4_addr
                  size 256
                  flags dynamic,timeout
          }
  }
  # nft list meters arp
  table arp t {
          set s {
                  type ipv4_addr
                  size 256
                  flags dynamic,timeout
          }
  }
  # nft list meter arp t s
  Error: No such file or directory
  list meter arp t s
                   ^
  # nft list set arp t s
  table arp t {
          set s {
                  type ipv4_addr
                  size 256
                  flags dynamic,timeout
          }
  }

> BTW, not your fault, but it seems libnftables documentation is missing
> an update for the (1 << 10) flag.

Yes, I noticed that.  I'll go back and fix it.

J.

--U+BazGySraz5kW0T
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEZ8d+2N/NBLDbUxIF0Z7UzfnX9sMFAl2u2/IACgkQ0Z7UzfnX
9sMvNg/9EZwb9HDYRCHUR0X3A26JLFlrAZwWUuVc+fyOANLQl6jvsmaUT7IMUDui
/H6kfhky0AVCSTCp04u4sRQZ7KJFxqQdcVHay8TP0dHAyI/K/Gaj4cFBqGg6vKCb
PqxPHTxUsBMWLin9xnqHFfiZL+IDf7sKXdckuX/dm20soYWECcfwhXrbCuhrymq5
54oEeWIUCS058pGXp+a7d+1HGLJ4w5j7sN/Rmv9RahfgvZoyeXLWSLckzBpXzLvd
jc2wI5vIGxGBGzU/qAqloqLHgE5dznaxfwz1sEU6JG85YStkjU6gqxF7rMi3i3lv
cVNhQ8eDWiZcx4SEwbOCN5aJvfxpsnqEXOapieFXwQEkI9MYpATZgb/pUsjoSqjZ
jbh/Mv2McTtaSkNBXSlhRA6f14lAEtyyKvhKfHnSVa4mBzptMiJkA6on7cQo02Gv
bXF9S6Yq/AsHXyUhPQDc5cdv5fEouQdwD3/8Z0tB50BGaUGBW/kNPGti/IaW5YAC
lASkyF+PVdJx4erD6F4TRssi1F96eMX3Z8pYnne68v3H+h9Z5aH+EomCUeAvGrnG
kFc3NN+L4+ONGAn2Rv8cqZ8aDr4e5225QaJPw/Q/sikYqfnDFcBqxdCJbpn9QrvY
jT6vWykyYrX8ylZt/Jt3FIvsuhMeBrGweJx+L5tuXg5Sto0vg5Y=
=V4F0
-----END PGP SIGNATURE-----

--U+BazGySraz5kW0T--
