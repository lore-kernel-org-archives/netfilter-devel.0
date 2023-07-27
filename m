Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86EA6C0015E
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Jul 2023 17:02:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbjG0RC5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 Jul 2023 13:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbjG0RC4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Jul 2023 13:02:56 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FF28F7
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Jul 2023 10:02:55 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qP4O6-0003St-1C; Thu, 27 Jul 2023 19:02:54 +0200
Date:   Thu, 27 Jul 2023 19:02:54 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft v3 PATCH 4/4] py: add Nftables.input_{set,get}_flags() API
Message-ID: <ZMKjPtfVkeycyU8s@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Thomas Haller <thaller@redhat.com>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
References: <20230720143147.669250-1-thaller@redhat.com>
 <20230720143147.669250-5-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230720143147.669250-5-thaller@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jul 20, 2023 at 04:27:03PM +0200, Thomas Haller wrote:
> Add new API to expose the input flags in the Python API.
> 
> Note that the chosen approach differs from the existing
> nft_ctx_output_get_flags() and nft_ctx_output_get_debug()
> API, which themselves are inconsistent approaches.
> 
> The new API directly exposes the underlying C API, that is, the numeric
> flags.

Insisting on forcing users to set input flags differently than output
flags is a bit odd, but once complaints come in we can still follow-up I
guess.

[...]
> diff --git a/py/nftables.py b/py/nftables.py
> index 68fcd7dd103c..e2417b7598c0 100644
> --- a/py/nftables.py
> +++ b/py/nftables.py
[...]
> @@ -152,6 +182,30 @@ class Nftables:
>      def __del__(self):
>          self.nft_ctx_free(self.__ctx)
>  
> +    def input_get_flags(self):
> +        """Query input flags for the nft context.
> +
> +        See input_get_flags() for supported flags.
> +
> +        Returns the currently set input flags as number.
> +        """
> +        return self.nft_ctx_input_get_flags(self.__ctx)
> +
> +    def input_set_flags(self, flags):
> +        """Set input flags for the nft context as number.
> +
> +        By default, a new context objects has flags set to zero.
> +
> +        The following flags are currently supported.
> +        NFT_CTX_INPUT_NO_DNS (0x1) disables blocking address lookup.
> +        NFT_CTX_INPUT_JSON (0x2) enables JSON mode for input.
> +
> +        Unknown flags are silently accepted.
> +
> +        Returns nothing.
> +        """
> +        self.nft_ctx_input_set_flags(self.__ctx, flags)

Please make this return the old flags. It makes temporary flag setting
much easier, see this snippet from tests/py/nft-test.py for instance:

|  # Check for matching ruleset listing
|  numeric_proto_old = nftables.set_numeric_proto_output(True)
|  stateless_old = nftables.set_stateless_output(True)
|  list_cmd = 'list table %s' % table
|  rc, pre_output, err = nftables.cmd(list_cmd)
|  nftables.set_numeric_proto_output(numeric_proto_old)
|  nftables.set_stateless_output(stateless_old)

Thanks, Phil
