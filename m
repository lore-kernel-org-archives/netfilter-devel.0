From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH v2 0/4] src: chain: Do not print unset values in
 json and xml
Date: Mon, 30 Jun 2014 14:38:35 +0200
Message-ID: <20140630123835.GA14314@localhost>
References: <1404129008-29564-1-git-send-email-anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40233 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755928AbaF3Mik (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:38:40 -0400
Content-Disposition: inline
In-Reply-To: <1404129008-29564-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 30, 2014 at 01:50:04PM +0200, Ana Rey wrote:
> In v1, this patchset contains the following patchs:
> 
> "Ana Rey (6):
>   src: chain: Free memory in the same function that is reserved
>   src: chain: Use nft_rule_expr_set_* in the xml parsing code
>   src: chain: add set, unset, get, parse and build payload
>     implementation for use value
>   src: chain: Do not print unset values in xml
>   src: chain: Rename variables in nft_jansson_parse_chain functions
>   src: chain: Do not print unser values in json
> "
> 
> I resend a v2 version of four of these six patches. The main change is in
> "src: chain: Add all support of use attribute" patch
> [ in v1 was "src: chain: add set, unset, get, parse and build payload implementation for use value"]

Series applied, thanks Ana.
