Return-Path: <SRS0=UjrQ=SG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1020C4360F
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Apr 2019 12:01:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BC292082E
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Apr 2019 12:01:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729003AbfDDMB3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 4 Apr 2019 08:01:29 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:59548 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbfDDMB2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 Apr 2019 08:01:28 -0400
Received: from sys.soleta.eu ([212.170.55.40] helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.84_2)
        (envelope-from <pablo@gnumonks.org>)
        id 1hC13c-0003yn-3F; Thu, 04 Apr 2019 14:01:26 +0200
Date:   Thu, 4 Apr 2019 14:01:23 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     netfilter-devel@vger.kernel.org, duncan_roe@optusnet.com.au
Subject: Re: [PATCH nft] doc: update nft list plural form parameters
Message-ID: <20190404120123.5d3mpuf2unlmmg6n@salvia>
References: <20190404114158.5758-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190404114158.5758-1-ffmancera@riseup.net>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Cc'ing Duncan, he's been helping with reviewing documentation.

On Thu, Apr 04, 2019 at 01:41:58PM +0200, Fernando Fernandez Mancera wrote:
> Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
> ---
>  doc/nft.txt | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/doc/nft.txt b/doc/nft.txt
> index d162dad..36a92fe 100644
> --- a/doc/nft.txt
> +++ b/doc/nft.txt
> @@ -256,6 +256,7 @@ TABLES
>  [verse]
>  {add | create} *table* ['family'] 'table' [ {flags 'flags'} ]
>  {delete | list | flush} *table* ['family'] 'table'
> +list *tables*
>  delete *table* ['family'] handle 'handle'
>  
>  Tables are containers for chains, sets and stateful objects. They are identified
> @@ -266,7 +267,8 @@ nfproto* keyword can be used to test which family (ipv4 or ipv6) context the
>  packet is being processed in. When no address family is specified, *ip* is used
>  by default. The only difference between add and create is that the former will
>  not return an error if the specified table already exists while *create* will
> -return an error.
> +return an error. The plural form of list can be used to list all the existing
> +tables.

Not sure we need this sentence, I mean, not sure if reader will
correlate this with 'list tables'.

Probably just adding:

list *tables*

and so on, for other objects in the [verse] area is just enough.

Thanks!
