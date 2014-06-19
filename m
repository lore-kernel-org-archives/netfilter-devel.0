From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v2 libnetfilter_conntrack] zero value handling of mark
 and zone
Date: Thu, 19 Jun 2014 17:16:11 +0200
Message-ID: <20140619151611.GC13029@breakpoint.cc>
References: <20140617120405.GA24712@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>, Florian Westphal <fw@strlen.de>
To: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:42063 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756959AbaFSPQM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jun 2014 11:16:12 -0400
Content-Disposition: inline
In-Reply-To: <20140617120405.GA24712@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ken-ichirou MATSUZAWA <chamaken@gmail.com> wrote:
> This patch enables comparison of 0 value with mark and zone since
> both CTA_MARK and CTA_ZONE are not set in case of its value is 0.
> These changes has been done in cmp_meta() and its own cmp function
> as Florian pointed out.
> 
> This enables `conntrack -L --zone 0' to work expctedly too.
> 
> Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
> ---
>  src/conntrack/compare.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/src/conntrack/compare.c b/src/conntrack/compare.c
> index f4a194a..384050e 100644
> --- a/src/conntrack/compare.c
> +++ b/src/conntrack/compare.c
> @@ -291,7 +291,10 @@ cmp_mark(const struct nf_conntrack *ct1,
>  	 const struct nf_conntrack *ct2,
>  	 unsigned int flags)
>  {
> -	return (ct1->mark == ct2->mark);
> +	return (flags & NFCT_CMP_MASK &&
> +		!test_bit(ATTR_MARK, ct1->head.set)) ||
> +		nfct_get_attr_u32(ct1, ATTR_MARK)
> +		== nfct_get_attr_u32(ct2, ATTR_MARK);
>  }

I spoke too soon.

This is problematic and will most likely cause regression.

Ex.
ct1: attr is not set
ct2: attr is set to 42

Current behaviour:
- With STRICT, they are not equal
- Without, they are qual

Now, even without STRICT, they are considered
to not match since 0 != 42.  But without STRICT, they should
be equal, since default behaviour is to only compare an
attribute if it is set in both conntrack objects.

I've updated the regression test suite in qa/test_api
with your reported bug case:

http://git.netfilter.org/libnetfilter_conntrack/commit/?id=169b1a3f37a70018aa402d90ba564ad01cb3a4cd

IOW, 'make -C qa test_api && qa/test_api' will fail
due to assertion failure in line 275.

I am afraid you will need to come up with a common
handler similar to __cmp() to deals with this, and
then use that handler for MARK and ZONE attributes.

With your new patch, the test suite would hopefully succeed
again.

Also, feel free to update/mangle the test cases if needed,
it will help us to make sure we do not accidentally alter
standing library behaviour.

Best Regards,
Florian
