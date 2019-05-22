Return-Path: <SRS0=iiCe=TW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AEA7C282CE
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 May 2019 13:04:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3BD920851
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 May 2019 13:04:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729018AbfEVNEL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 May 2019 09:04:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47236 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728584AbfEVNEL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 May 2019 09:04:11 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 26DC03098558;
        Wed, 22 May 2019 13:03:48 +0000 (UTC)
Received: from egarver.localdomain (ovpn-122-108.rdu2.redhat.com [10.10.122.108])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9E5721001E81;
        Wed, 22 May 2019 13:03:43 +0000 (UTC)
Date:   Wed, 22 May 2019 09:03:42 -0400
From:   Eric Garver <eric@garver.life>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org,
        Jones Desougi <jones.desougi+netfilter@gmail.com>
Subject: Re: [nft PATCH v2 1/2] py: Implement JSON validation in nftables
 module
Message-ID: <20190522130342.wklpmg33hjhar2e7@egarver.localdomain>
Mail-Followup-To: Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org,
        Jones Desougi <jones.desougi+netfilter@gmail.com>
References: <20190517201758.1576-1-phil@nwl.cc>
 <20190517201758.1576-2-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190517201758.1576-2-phil@nwl.cc>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Wed, 22 May 2019 13:04:10 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, May 17, 2019 at 10:17:57PM +0200, Phil Sutter wrote:
> Using jsonschema it is possible to validate any JSON input to make sure
> it formally conforms with libnftables JSON API requirements.
> 
> Implement a simple validator class for use within a new Nftables class
> method 'json_validate' and ship a minimal schema definition along with
> the package.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  py/Makefile.am |  2 +-
>  py/nftables.py | 30 ++++++++++++++++++++++++++++++
>  py/schema.json | 17 +++++++++++++++++
>  py/setup.py    |  1 +
>  4 files changed, 49 insertions(+), 1 deletion(-)
>  create mode 100644 py/schema.json
> 
[..]
> diff --git a/py/nftables.py b/py/nftables.py
> index 33cd2dfd736d4..db0f502b2951f 100644
> --- a/py/nftables.py
> +++ b/py/nftables.py
> @@ -17,9 +17,24 @@
>  import json
>  from ctypes import *
>  import sys
> +import os
>  
>  NFTABLES_VERSION = "0.1"
>  
> +class SchemaValidator:
> +    """Libnftables JSON validator using jsonschema"""
> +
> +    def __init__(self):
> +        schema_path = os.path.join(os.path.dirname(__file__), "schema.json")
> +        schema_file = file(schema_path)

file() doesn't exist in python3. You should use open().
