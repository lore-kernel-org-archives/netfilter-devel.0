From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] mnl_attr_get_str: document that the result is not
 NUL-terminated
Date: Tue, 14 Aug 2012 13:10:08 +0200
Message-ID: <20120814111008.GA25235@1984>
References: <502A2624.6050701@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53208 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752610Ab2HNLKL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Aug 2012 07:10:11 -0400
Content-Disposition: inline
In-Reply-To: <502A2624.6050701@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 14, 2012 at 12:19:16PM +0200, Florian Weimer wrote:
> Hi,
>
> while reviewing from libmnl-using code, I discovered that the result
> of mnl_attr_get_str was used as a NUL-terminated string, although in
> reality the string wasn't.  I think this should be mentioned in the
> documentation.

Looking at the kernel:

static inline int nla_put_string(struct sk_buff *skb, int attrtype,
                                 const char *str)
{
        return nla_put(skb, attrtype, strlen(str) + 1, str);
}

It seems it always returns the string plus one byte (that is assumed
to be NULL).

Are you looking at any netlink subsystem in particular? What are you
noticing?

> Florian
> --
> Florian Weimer / Red Hat Product Security Team

> From 1e4b192907eb15f4fbfd581c8c0fa8359aa9439f Mon Sep 17 00:00:00 2001
> From: Florian Weimer <fweimer@redhat.com>
> Date: Tue, 14 Aug 2012 12:16:32 +0200
> Subject: [PATCH] mnl_attr_get_str: document that the result is not
>  NUL-terminated
>
> Signed-off-by: Florian Weimer <fweimer@redhat.com>
> ---
>  src/attr.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/src/attr.c b/src/attr.c
> index 1136c50..c890bf2 100644
> --- a/src/attr.c
> +++ b/src/attr.c
> @@ -393,6 +393,7 @@ EXPORT_SYMBOL(mnl_attr_get_u64);
>   * \param attr pointer to netlink attribute
>   *
>   * This function returns the payload of string attribute value.
> + * Note that the string is not necessarily NUL-terminated.
>   */
>  const char *mnl_attr_get_str(const struct nlattr *attr)
>  {
> --
> 1.7.7.6
>

