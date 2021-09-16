Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 914A3C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Sep 2021 10:48:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C1F86108F
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Sep 2021 10:48:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235628AbhIPKty (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Sep 2021 06:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237017AbhIPKtw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Sep 2021 06:49:52 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E459DC061767
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Sep 2021 03:48:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=X8s7E8NCwcQ5Q9k0KHXhid9MB5/kKdmr31bAh84m6lY=; b=FqqW0M106BgUBdXx2/zmurI66b
        vZ3jg3tIHlYBhuwFb8NCK9cucrHU9NJcQKrj0Jk7VqLQjkssTNsGVn85lxNNZ+h87mZqf9M3kvEwX
        gwwjwvTbwTERM+VaQWLgwp2KT3KumuUA/Z5rYLE0nSVxl7eY63oFH8MmtWPomyvQOrCDwMr87R5YV
        QyX9VkqisJDRTTtVXSbZ5GZPMzExMxmW9LvVDNRWUt80K1Ql0qSQ8oq9QDzSoB9wvi7X1OA2Pb02x
        aYKTSmtQ8009wfNFe8T5dFH49TSNi4WIR9fs5JZA1mhvJMM0+GjNsVQtPXq2nEQa3iisO7ViqGg+g
        n5ZGCArg==;
Received: from [2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mQowO-002FmZ-Fn; Thu, 16 Sep 2021 11:48:28 +0100
Date:   Thu, 16 Sep 2021 11:48:27 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft,v2] doc: fix sinopsis of named counter, quota and ct
 {helper,timeout,expect}
Message-ID: <YUMg+7SnNKUYMp75@azazel.net>
References: <20210916104009.10259-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="uFq04OyNFFGFYXWg"
Content-Disposition: inline
In-Reply-To: <20210916104009.10259-1-pablo@netfilter.org>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--uFq04OyNFFGFYXWg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2021-09-16, at 12:40:09 +0200, Pablo Neira Ayuso wrote:
> Sinopsis is not complete. Add examples for counters and quotas.

That should be "Synopsis".

J.

> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  doc/nft.txt              |  8 +++---
>  doc/stateful-objects.txt | 62 ++++++++++++++++++++++++++++++++++++----
>  2 files changed, 61 insertions(+), 9 deletions(-)
>
> diff --git a/doc/nft.txt b/doc/nft.txt
> index 13fe8b1f6671..c9bb901b85b9 100644
> --- a/doc/nft.txt
> +++ b/doc/nft.txt
> @@ -291,7 +291,7 @@ Effectively, this is the nft-equivalent of *iptables-save* and
>  TABLES
>  ------
>  [verse]
> -{*add* | *create*} *table* ['family'] 'table' [*{ flags* 'flags' *; }*]
> +{*add* | *create*} *table* ['family'] 'table' [ {*comment* 'comment' *;*'} *{ flags* 'flags' *; }*]
>  {*delete* | *list* | *flush*} *table* ['family'] 'table'
>  *list tables* ['family']
>  *delete table* ['family'] *handle* 'handle'
> @@ -344,7 +344,7 @@ add table inet mytable
>  CHAINS
>  ------
>  [verse]
> -{*add* | *create*} *chain* ['family'] 'table' 'chain' [*{ type* 'type' *hook* 'hook' [*device* 'device'] *priority* 'priority' *;* [*policy* 'policy' *;*] *}*]
> +{*add* | *create*} *chain* ['family'] 'table' 'chain' [*{ type* 'type' *hook* 'hook' [*device* 'device'] *priority* 'priority' *;* [*policy* 'policy' *;*] [*comment* 'comment' *;*'] *}*]
>  {*delete* | *list* | *flush*} *chain* ['family'] 'table' 'chain'
>  *list chains* ['family']
>  *delete chain* ['family'] 'table' *handle* 'handle'
> @@ -527,7 +527,7 @@ The sets allowed_hosts and allowed_ports need to be created first. The next
>  section describes nft set syntax in more detail.
>
>  [verse]
> -*add set* ['family'] 'table' 'set' *{ type* 'type' | *typeof* 'expression' *;* [*flags* 'flags' *;*] [*timeout* 'timeout' *;*] [*gc-interval* 'gc-interval' *;*] [*elements = {* 'element'[*,* ...] *} ;*] [*size* 'size' *;*] [*policy* 'policy' *;*] [*auto-merge ;*] *}*
> +*add set* ['family'] 'table' 'set' *{ type* 'type' | *typeof* 'expression' *;* [*flags* 'flags' *;*] [*timeout* 'timeout' *;*] [*gc-interval* 'gc-interval' *;*] [*elements = {* 'element'[*,* ...] *} ;*] [*size* 'size' *;*] [*comment* 'comment' *;*'] [*policy* 'policy' *;*] [*auto-merge ;*] *}*
>  {*delete* | *list* | *flush*} *set* ['family'] 'table' 'set'
>  *list sets* ['family']
>  *delete set* ['family'] 'table' *handle* 'handle'
> @@ -580,7 +580,7 @@ automatic merge of adjacent/overlapping set elements (only for interval sets) |
>  MAPS
>  -----
>  [verse]
> -*add map* ['family'] 'table' 'map' *{ type* 'type' | *typeof* 'expression' [*flags* 'flags' *;*] [*elements = {* 'element'[*,* ...] *} ;*] [*size* 'size' *;*] [*policy* 'policy' *;*] *}*
> +*add map* ['family'] 'table' 'map' *{ type* 'type' | *typeof* 'expression' [*flags* 'flags' *;*] [*elements = {* 'element'[*,* ...] *} ;*] [*size* 'size' *;*] [*comment* 'comment' *;*'] [*policy* 'policy' *;*] *}*
>  {*delete* | *list* | *flush*} *map* ['family'] 'table' 'map'
>  *list maps* ['family']
>
> diff --git a/doc/stateful-objects.txt b/doc/stateful-objects.txt
> index c7488b28d21e..4972969eb250 100644
> --- a/doc/stateful-objects.txt
> +++ b/doc/stateful-objects.txt
> @@ -1,7 +1,9 @@
>  CT HELPER
>  ~~~~~~~~~
>  [verse]
> -*ct helper* 'helper' *{ type* 'type' *protocol* 'protocol' *;* [*l3proto* 'family' *;*] *}*
> +*add* *ct helper* ['family'] 'table' 'name' *{ type* 'type' *protocol* 'protocol' *;* [*l3proto* 'family' *;*] *}*
> +*delete* *ct helper* ['family'] 'table' 'name'
> +*list* *ct helpers*
>
>  Ct helper is used to define connection tracking helpers that can then be used in
>  combination with the *ct helper set* statement. 'type' and 'protocol' are
> @@ -22,6 +24,9 @@ string (e.g. ip)
>  |l3proto |
>  layer 3 protocol of the helper |
>  address family (e.g. ip)
> +|comment |
> +per ct helper comment field |
> +string
>  |=================
>
>  .defining and assigning ftp helper
> @@ -43,7 +48,9 @@ table inet myhelpers {
>  CT TIMEOUT
>  ~~~~~~~~~~
>  [verse]
> -*ct timeout* 'name' *{ protocol* 'protocol' *; policy = {* 'state'*:* 'value' [*,* ...] *} ;* [*l3proto* 'family' *;*] *}*
> +*add* *ct timeout*  ['family'] 'table' 'name' *{ protocol* 'protocol' *; policy = {* 'state'*:* 'value' [*,* ...] *} ;* [*l3proto* 'family' *;*] *}*
> +*delete* *ct timeout* ['family'] 'table' 'name'
> +*list* *ct timeouts*
>
>  Ct timeout is used to update connection tracking timeout values.Timeout policies are assigned
>  with the *ct timeout set* statement. 'protocol' and 'policy' are
> @@ -65,6 +72,9 @@ unsigned integer
>  |l3proto |
>  layer 3 protocol of the timeout object |
>  address family (e.g. ip)
> +|comment |
> +per ct timeout comment field |
> +string
>  |=================
>
>  .defining and assigning ct timeout policy
> @@ -98,7 +108,9 @@ sport=41360 dport=22
>  CT EXPECTATION
>  ~~~~~~~~~~~~~~
>  [verse]
> -*ct expectation* 'name' *{ protocol* 'protocol' *; dport* 'dport' *; timeout* 'timeout' *; size* 'size' *; [*l3proto* 'family' *;*] *}*
> +*add* *ct expectation*  ['family'] 'table' 'name' *{ protocol* 'protocol' *; dport* 'dport' *; timeout* 'timeout' *; size* 'size' *; [*l3proto* 'family' *;*] *}*
> +*delete* *ct expectation*  ['family'] 'table' 'name'
> +*list* *ct expectations*
>
>  Ct expectation is used to create connection expectations. Expectations are
>  assigned with the *ct expectation set* statement. 'protocol', 'dport',
> @@ -124,6 +136,9 @@ unsigned integer
>  |l3proto |
>  layer 3 protocol of the expectation object |
>  address family (e.g. ip)
> +|comment |
> +per ct expectation comment field |
> +string
>  |=================
>
>  .defining and assigning ct expectation policy
> @@ -147,7 +162,9 @@ table ip filter {
>  COUNTER
>  ~~~~~~~
>  [verse]
> -*counter* ['packets bytes']
> +*add* *counter* ['family'] 'table' 'name' [*{* [ *packets* 'packets' *bytes* 'bytes' ';' ] [ *comment* 'comment' ';' *}*]
> +*delete* *counter* ['family'] 'table' 'name'
> +*list* *counters*
>
>  .Counter specifications
>  [options="header"]
> @@ -159,12 +176,31 @@ unsigned integer (64 bit)
>  |bytes |
>  initial count of bytes |
>  unsigned integer (64 bit)
> +|comment |
> +per counter comment field |
> +string
>  |=================
>
> +.*Using named counters*
> +------------------
> +nft add counter filter http
> +nft add rule filter input tcp dport 80 counter name \"http\"
> +------------------
> +
> +.*Using named counters with maps*
> +------------------
> +nft add counter filter http
> +nft add counter filter https
> +nft add rule filter input counter name tcp dport map { 80 : \"http\", 443 : \"https\" }
> +------------------
> +
>  QUOTA
>  ~~~~~
>  [verse]
> -*quota* [*over* | *until*] ['used']
> +*add* *quota* ['family'] 'table' 'name' *{* [*over*|*until*] 'bytes' 'BYTE_UNIT' [ *used* 'bytes' 'BYTE_UNIT' ] ';' [ *comment* 'comment' ';' ] *}*
> +BYTE_UNIT := bytes | kbytes | mbytes
> +*delete* *quota* ['family'] 'table' 'name'
> +*list* *quotas*
>
>  .Quota specifications
>  [options="header"]
> @@ -177,4 +213,20 @@ Two arguments, unsigned integer (64 bit) and string: bytes, kbytes, mbytes.
>  |used |
>  initial value of used quota |
>  Two arguments, unsigned integer (64 bit) and string: bytes, kbytes, mbytes
> +|comment |
> +per quota comment field |
> +string
>  |=================
> +
> +.*Using named quotas*
> +------------------
> +nft add quota filter user123 { over 20 mbytes }
> +nft add rule filter input ip saddr 192.168.10.123 quota name \"user123\"
> +------------------
> +
> +.*Using named quotas with maps*
> +------------------
> +nft add quota filter user123 { over 20 mbytes }
> +nft add quota filter user124 { over 20 mbytes }
> +nft add rule filter input quota name ip saddr map { 192.168.10.123 : \"user123\", 192.168.10.124 : \"user124\" }
> +------------------
> --
> 2.20.1
>
>

--uFq04OyNFFGFYXWg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmFDIPQACgkQKYasCr3x
BA3NtRAAoFH6Vo1wW4BdBGgFTZ6VfpsJKplut68qP/AfyiGiFzimkDT5T6PFsweJ
or9hxtKz2h23LRpYZsk9NF//Z99WQCXlHDzXF8K3nMDDg89rZwx/FN6XYpNRPYeU
qVMqbf5qFCS8T37zzyiOqnO0haWmgAgMl3vvc/GX6IYVn7yaZ0znRhWS0Q9JrO2/
S+V6FF3sf0xUrvly8zzjU6UXeCl7OdS8KNsOkfadXwhTb62zaO+abWM7jU2xROns
R08lb9WjeOErhHkhNv0Sz+N7euTXykSDDDbdtM34fCAniNWVW4nQ+5sZvgycnlUm
WIjQ3UlUUVrWAeI2btq6fWTOT1qJCqSB4wpZHetByjUE03+3Q0NF6/c035SkBnRq
wg28cx/3kX+MBTRCJMAO0BFEZYgBpId2LXHNSd6GR4aPtAYisFoKkDdRHfUJylRV
zzEhVq6qMRQu3tmArVjl8iAYSjCJA/o3GFcOhW+8+7kr73jLt2JWS+126bkVKGgU
fdEEt2FbgPTbCGNtrZBRUF67JIw7slQeMiaEi4sCwp8m7DKGkiSfJQ+tNPo5dhp3
bvglDI7UOfCg4VzD54lbyA9ivgnbNGFtQsYkb9321fAsEq38i0kfvWTV3jSVIFBD
Li+2xFP4q5fEQbJKd+mGIb0046fFZYXkc+flT+LZKd+OP7hUWr0=
=MdSo
-----END PGP SIGNATURE-----

--uFq04OyNFFGFYXWg--
