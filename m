From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] build: bump library versioning
Date: Wed, 16 Sep 2015 19:28:36 +0200
Message-ID: <20150916172836.GA29575@salvia>
References: <1442423567-12120-1-git-send-email-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36910 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683AbbIPRV7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Sep 2015 13:21:59 -0400
Content-Disposition: inline
In-Reply-To: <1442423567-12120-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Sep 16, 2015 at 07:12:47PM +0200, Jan Engelhardt wrote:
> Commit libnftnl-1.0.3-31-g5ea54b2 removed a symbol. Such requires a
> bumped to n+1:0:0.

Right, nft_rule_expr_build_payload() was gone. But noone was using it
in our tree. But we have to update LIBTOOL version according, yes.

> The symbol groups can be merged again to save time
> processing them as the groups are relative to a particular SONAME
> (of which we have a new one).
> 
> Signed-off-by: Jan Engelhardt <jengelh@inai.de>
> ---
> This essentially supersedes "[PATCH libnftnl 0/2] map fixes".
> The use of LIBNFTNL_4 as a symbol name is modeled upon the LIBVERSION
> number. Doing this instead of _x.y is a (more) sensible choice,
> because the next modification to the symbol map (LIBNFTNL_5) needs to
> be accompanied by LIBVERSION=5:0:something in any case.
> 
> 
>  src/libnftnl.map | 14 ++------------
>  1 file changed, 2 insertions(+), 12 deletions(-)
> 
> diff --git a/src/libnftnl.map b/src/libnftnl.map
> index 14ec88c..991fe9d 100644
> --- a/src/libnftnl.map
> +++ b/src/libnftnl.map
> @@ -1,4 +1,4 @@
> -LIBNFTNL_1.0 {
> +LIBNFTNL_4 {

This is breaking hard existing nft binaries, which is what I was
trying to avoid.

But I can use LIBNFTNL_4 for the new nftnl_ symbols.

Will send a new patchset round. Thanks.
