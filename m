From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 5/5] attr: avoid multiple definition of hidden variable
Date: Thu, 11 Nov 2010 14:08:38 +0100
Message-ID: <4CDBEAD6.9030505@netfilter.org>
References: <1289430485-16467-1-git-send-email-jengelh@medozas.de> <1289430485-16467-6-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55587 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755436Ab0KKNIm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Nov 2010 08:08:42 -0500
In-Reply-To: <1289430485-16467-6-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 11/11/10 00:08, Jan Engelhardt wrote:
> When nesting two mnl_attr_for_each loops, the __len__ variable will be
> declared twice, eliciting a warning when -Wshadow is turned on. There
> can also be warnings in pre-C99 because declarations and code are
> mixed. Do without any temporaries that are not explicitly specified as
> macro parameters.

I like this spot, some question below:

> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
[...]
> diff --git a/src/attr.c b/src/attr.c
> index e22a8ac..5137395 100644
> --- a/src/attr.c
> +++ b/src/attr.c
> @@ -106,9 +106,8 @@ bool mnl_attr_ok(const struct nlattr *attr, int len)
>   * as parameter. You have to use mnl_attr_ok() to ensure that the next
>   * attribute is valid.
>   */
> -struct nlattr *mnl_attr_next(const struct nlattr *attr, int *len)
> +struct nlattr *mnl_attr_next(const struct nlattr *attr)
>  {
> -	*len -= MNL_ALIGN(attr->nla_len);
>  	return (struct nlattr *)((void *)attr + MNL_ALIGN(attr->nla_len));
>  }

If we remove the len parameter from mnl_attr_next(), we may access
memory that may be out of the message boundary in mnl_attr_ok().
