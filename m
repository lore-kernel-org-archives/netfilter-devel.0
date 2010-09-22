From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/4] netfilter: ctnetlink: add support for user-space
 expectation helpers
Date: Wed, 22 Sep 2010 08:45:40 +0200
Message-ID: <4C99A614.1030207@trash.net>
References: <20100921092843.3279.6914.stgit@decadence> <20100921093529.3279.30748.stgit@decadence> <4C98CD4C.3040700@trash.net> <4C9933F1.2060200@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53406 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab0IVGpn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Sep 2010 02:45:43 -0400
In-Reply-To: <4C9933F1.2060200@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 22.09.2010 00:38, schrieb Pablo Neira Ayuso:
>>
>> My main question is - what will be cleaning up these expectations
>> on module unload? Currently expectations are cleaned up on unload
>> of the corresponding helper module, which obviously doesn't
>> happen in this case.
> 
> Indeed. I have reworked the patch to add the nf_ct_userspace_expect_list
> that is used to delete all the user-space created expectations if
> ctnetlink is unloaded.

> diff --git a/include/linux/netfilter/nf_conntrack_common.h b/include/linux/netfilter/nf_conntrack_common.h
> index fdc50ca..23a1a08 100644
> --- a/include/linux/netfilter/nf_conntrack_common.h
> +++ b/include/linux/netfilter/nf_conntrack_common.h
> @@ -103,6 +103,7 @@ enum ip_conntrack_expect_events {
>  /* expectation flags */
>  #define NF_CT_EXPECT_PERMANENT		0x1
>  #define NF_CT_EXPECT_INACTIVE		0x2
> +#define NF_CT_EXPECT_USERSPACE		0x4

Does this flag need to be exposed to userspace? I also don't
see anything preventing userspace incorrectly setting it on
an expectation that actually does have a master, which will
probably cause problems later on.

> diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
> index acb29cc..361a8ba 100644
> --- a/net/netfilter/nf_conntrack_expect.c
> +++ b/net/netfilter/nf_conntrack_expect.c
> @@ -38,20 +38,26 @@ static int nf_ct_expect_hash_rnd_initted __read_mostly;
>  
>  static struct kmem_cache *nf_ct_expect_cachep __read_mostly;
>  
> +static HLIST_HEAD(nf_ct_userspace_expect_list);
> +static int nf_ct_userspace_expect_list_counter;

This counter is write-only.
