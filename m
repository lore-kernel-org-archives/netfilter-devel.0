Return-Path: <SRS0=Dw8A=A6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 133EAC433DF
	for <netfilter-devel@archiver.kernel.org>; Sun, 19 Jul 2020 15:50:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB34220684
	for <netfilter-devel@archiver.kernel.org>; Sun, 19 Jul 2020 15:50:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b="EAs0f9hK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726529AbgGSPub (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 19 Jul 2020 11:50:31 -0400
Received: from gateway34.websitewelcome.com ([192.185.148.194]:42736 "EHLO
        gateway34.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726093AbgGSPua (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 19 Jul 2020 11:50:30 -0400
X-Greylist: delayed 1317 seconds by postgrey-1.27 at vger.kernel.org; Sun, 19 Jul 2020 11:50:29 EDT
Received: from cm11.websitewelcome.com (cm11.websitewelcome.com [100.42.49.5])
        by gateway34.websitewelcome.com (Postfix) with ESMTP id A0B715D5A
        for <netfilter-devel@vger.kernel.org>; Sun, 19 Jul 2020 10:28:31 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id xBEtjFAJuhmVTxBEtjgV1w; Sun, 19 Jul 2020 10:28:31 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Y2KRAypxaSf7L8J6SNC316OrNhETt59LKGD/8HqPd3k=; b=EAs0f9hKg/X4Pq0I/GUTCFolTc
        5KZt7ww1vLJ2ntkFZnaX/bTWUOaVZd3Omb9IKE3zzOOENkM/pk4MGENXdnmX6axz37WGvGV8qItkc
        qLbb/jhKb+Y3O9ypqPEYDpkakuCaImNqVvEXSel7g+bKi4k7Ja+DH3c0ibNgf/AHMehqBopriFx9d
        WS2VE4tluCn6PH9E++lOcQ2Yi17EvftOGLYsWlq8UXzRg7I+4R2XNulaTV5bYtJxitjNFfzDkA3Ml
        hmJf1I3t3AywOGo5zimMy5LV6QXHaeMkzHVFzQOrjAv2ZMXAec1wgnvyhLfiFYFvU4tR/CAqtONtk
        qGbf6/eg==;
Received: from [201.162.168.129] (port=25301 helo=[192.168.43.132])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <gustavo@embeddedor.com>)
        id 1jxBEt-001EMd-BB; Sun, 19 Jul 2020 10:28:31 -0500
Subject: Re: [nf-next PATCH v2] netfilter: include: uapi: Use C99 flexible
 array member
To:     Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <20200719100220.4666-1-phil@nwl.cc>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Autocrypt: addr=gustavo@embeddedor.com; keydata=
 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
 AP7RWS474w==
Message-ID: <0297a19d-2afb-1285-a91c-d32fb9799c33@embeddedor.com>
Date:   Sun, 19 Jul 2020 10:34:01 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200719100220.4666-1-phil@nwl.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 201.162.168.129
X-Source-L: No
X-Exim-ID: 1jxBEt-001EMd-BB
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: ([192.168.43.132]) [201.162.168.129]:25301
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 3
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

Please, see this:

https://git.kernel.org/linus/1e6e9d0f4859ec698d55381ea26f4136eff3afe1

We are refraining from doing flexible-array conversions in UAPI, for now.

--
Gustavo

On 7/19/20 05:02, Phil Sutter wrote:
> Recent versions of gcc started to complain about the old-style
> zero-length array as last member of various structs. For instance, while
> compiling iptables:
> 
> | In file included from /usr/include/string.h:495,
> |                  from libip4tc.c:15:
> | In function 'memcpy',
> |     inlined from 'iptcc_compile_chain' at libiptc.c:1172:2,
> |     inlined from 'iptcc_compile_table' at libiptc.c:1243:13,
> |     inlined from 'iptc_commit' at libiptc.c:2572:8,
> |     inlined from 'iptc_commit' at libiptc.c:2510:1:
> | /usr/include/bits/string_fortified.h:34:10: warning: writing 16 bytes into a region of size 0 [-Wstringop-overflow=]
> |    34 |   return __builtin___memcpy_chk (__dest, __src, __len, __bos0 (__dest));
> |       |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> | In file included from ../include/libiptc/libiptc.h:12,
> |                  from libip4tc.c:29:
> | libiptc.c: In function 'iptc_commit':
> | ../include/linux/netfilter_ipv4/ip_tables.h:202:19: note: at offset 0 to object 'entries' with size 0 declared here
> |   202 |  struct ipt_entry entries[0];
> |       |                   ^~~~~~~
> 
> (Similar for libip6tc.c.)
> 
> Avoid this warning by declaring these fields as an ISO C99 flexible
> array member. This makes gcc aware of the intended use and enables
> sanity checking as described in:
> https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> 
> This patch is actually a follow-up on commit 6daf14140129d ("netfilter:
> Replace zero-length array with flexible-array member") which seems to
> have missed a few spots. Like it, alignment attribute syntax is fixed
> where found in line with zero-length array fields.
> 
> Cc: Gustavo A. R. Silva <gustavo@embeddedor.com>
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
> Changes since v1:
> - Fix up any zero-length arrays found via:
>   `grep -r '\[0\]' include/uapi/linux/netfilter*`.
> - Perform alignment attribute syntax fixup just like 6daf14140129d does.
> - Point at relationship with 6daf14140129d in commit message.
> - Add Gustavo to Cc: for verification.
> ---
>  include/uapi/linux/netfilter/x_tables.h         |  6 +++---
>  include/uapi/linux/netfilter_arp/arp_tables.h   |  6 +++---
>  include/uapi/linux/netfilter_bridge/ebt_among.h |  2 +-
>  include/uapi/linux/netfilter_bridge/ebtables.h  | 10 +++++-----
>  include/uapi/linux/netfilter_ipv4/ip_tables.h   |  6 +++---
>  include/uapi/linux/netfilter_ipv6/ip6_tables.h  |  6 +++---
>  6 files changed, 18 insertions(+), 18 deletions(-)
> 
> diff --git a/include/uapi/linux/netfilter/x_tables.h b/include/uapi/linux/netfilter/x_tables.h
> index a8283f7dbc519..7a52c69c74a2b 100644
> --- a/include/uapi/linux/netfilter/x_tables.h
> +++ b/include/uapi/linux/netfilter/x_tables.h
> @@ -28,7 +28,7 @@ struct xt_entry_match {
>  		__u16 match_size;
>  	} u;
>  
> -	unsigned char data[0];
> +	unsigned char data[];
>  };
>  
>  struct xt_entry_target {
> @@ -51,7 +51,7 @@ struct xt_entry_target {
>  		__u16 target_size;
>  	} u;
>  
> -	unsigned char data[0];
> +	unsigned char data[];
>  };
>  
>  #define XT_TARGET_INIT(__name, __size)					       \
> @@ -119,7 +119,7 @@ struct xt_counters_info {
>  	unsigned int num_counters;
>  
>  	/* The counters (actually `number' of these). */
> -	struct xt_counters counters[0];
> +	struct xt_counters counters[];
>  };
>  
>  #define XT_INV_PROTO		0x40	/* Invert the sense of PROTO. */
> diff --git a/include/uapi/linux/netfilter_arp/arp_tables.h b/include/uapi/linux/netfilter_arp/arp_tables.h
> index bbf5af2b67a8f..a6ac2463f787a 100644
> --- a/include/uapi/linux/netfilter_arp/arp_tables.h
> +++ b/include/uapi/linux/netfilter_arp/arp_tables.h
> @@ -109,7 +109,7 @@ struct arpt_entry
>  	struct xt_counters counters;
>  
>  	/* The matches (if any), then the target. */
> -	unsigned char elems[0];
> +	unsigned char elems[];
>  };
>  
>  /*
> @@ -181,7 +181,7 @@ struct arpt_replace {
>  	struct xt_counters __user *counters;
>  
>  	/* The entries (hang off end: not really an array). */
> -	struct arpt_entry entries[0];
> +	struct arpt_entry entries[];
>  };
>  
>  /* The argument to ARPT_SO_GET_ENTRIES. */
> @@ -193,7 +193,7 @@ struct arpt_get_entries {
>  	unsigned int size;
>  
>  	/* The entries. */
> -	struct arpt_entry entrytable[0];
> +	struct arpt_entry entrytable[];
>  };
>  
>  /* Helper functions */
> diff --git a/include/uapi/linux/netfilter_bridge/ebt_among.h b/include/uapi/linux/netfilter_bridge/ebt_among.h
> index 9acf757bc1f79..73b26a280c4fd 100644
> --- a/include/uapi/linux/netfilter_bridge/ebt_among.h
> +++ b/include/uapi/linux/netfilter_bridge/ebt_among.h
> @@ -40,7 +40,7 @@ struct ebt_mac_wormhash_tuple {
>  struct ebt_mac_wormhash {
>  	int table[257];
>  	int poolsize;
> -	struct ebt_mac_wormhash_tuple pool[0];
> +	struct ebt_mac_wormhash_tuple pool[];
>  };
>  
>  #define ebt_mac_wormhash_size(x) ((x) ? sizeof(struct ebt_mac_wormhash) \
> diff --git a/include/uapi/linux/netfilter_bridge/ebtables.h b/include/uapi/linux/netfilter_bridge/ebtables.h
> index a494cf43a7552..0b4f8994a0a54 100644
> --- a/include/uapi/linux/netfilter_bridge/ebtables.h
> +++ b/include/uapi/linux/netfilter_bridge/ebtables.h
> @@ -87,7 +87,7 @@ struct ebt_entries {
>  	/* nr. of entries */
>  	unsigned int nentries;
>  	/* entry list */
> -	char data[0] __attribute__ ((aligned (__alignof__(struct ebt_replace))));
> +	char data[] __aligned(__alignof__(struct ebt_replace));
>  };
>  
>  /* used for the bitmask of struct ebt_entry */
> @@ -129,7 +129,7 @@ struct ebt_entry_match {
>  	} u;
>  	/* size of data */
>  	unsigned int match_size;
> -	unsigned char data[0] __attribute__ ((aligned (__alignof__(struct ebt_replace))));
> +	unsigned char data[] __aligned(__alignof__(struct ebt_replace));
>  };
>  
>  struct ebt_entry_watcher {
> @@ -142,7 +142,7 @@ struct ebt_entry_watcher {
>  	} u;
>  	/* size of data */
>  	unsigned int watcher_size;
> -	unsigned char data[0] __attribute__ ((aligned (__alignof__(struct ebt_replace))));
> +	unsigned char data[] __aligned(__alignof__(struct ebt_replace));
>  };
>  
>  struct ebt_entry_target {
> @@ -155,7 +155,7 @@ struct ebt_entry_target {
>  	} u;
>  	/* size of data */
>  	unsigned int target_size;
> -	unsigned char data[0] __attribute__ ((aligned (__alignof__(struct ebt_replace))));
> +	unsigned char data[] __aligned(__alignof__(struct ebt_replace));
>  };
>  
>  #define EBT_STANDARD_TARGET "standard"
> @@ -188,7 +188,7 @@ struct ebt_entry {
>  	unsigned int target_offset;
>  	/* sizeof ebt_entry + matches + watchers + target */
>  	unsigned int next_offset;
> -	unsigned char elems[0] __attribute__ ((aligned (__alignof__(struct ebt_replace))));
> +	unsigned char elems[] __aligned(__alignof__(struct ebt_replace));
>  };
>  
>  static __inline__ struct ebt_entry_target *
> diff --git a/include/uapi/linux/netfilter_ipv4/ip_tables.h b/include/uapi/linux/netfilter_ipv4/ip_tables.h
> index 50c7fee625ae9..1485df28b2391 100644
> --- a/include/uapi/linux/netfilter_ipv4/ip_tables.h
> +++ b/include/uapi/linux/netfilter_ipv4/ip_tables.h
> @@ -121,7 +121,7 @@ struct ipt_entry {
>  	struct xt_counters counters;
>  
>  	/* The matches (if any), then the target. */
> -	unsigned char elems[0];
> +	unsigned char elems[];
>  };
>  
>  /*
> @@ -203,7 +203,7 @@ struct ipt_replace {
>  	struct xt_counters __user *counters;
>  
>  	/* The entries (hang off end: not really an array). */
> -	struct ipt_entry entries[0];
> +	struct ipt_entry entries[];
>  };
>  
>  /* The argument to IPT_SO_GET_ENTRIES. */
> @@ -215,7 +215,7 @@ struct ipt_get_entries {
>  	unsigned int size;
>  
>  	/* The entries. */
> -	struct ipt_entry entrytable[0];
> +	struct ipt_entry entrytable[];
>  };
>  
>  /* Helper functions */
> diff --git a/include/uapi/linux/netfilter_ipv6/ip6_tables.h b/include/uapi/linux/netfilter_ipv6/ip6_tables.h
> index d9e364f96a5cf..d4d7f47d9104d 100644
> --- a/include/uapi/linux/netfilter_ipv6/ip6_tables.h
> +++ b/include/uapi/linux/netfilter_ipv6/ip6_tables.h
> @@ -125,7 +125,7 @@ struct ip6t_entry {
>  	struct xt_counters counters;
>  
>  	/* The matches (if any), then the target. */
> -	unsigned char elems[0];
> +	unsigned char elems[];
>  };
>  
>  /* Standard entry */
> @@ -243,7 +243,7 @@ struct ip6t_replace {
>  	struct xt_counters __user *counters;
>  
>  	/* The entries (hang off end: not really an array). */
> -	struct ip6t_entry entries[0];
> +	struct ip6t_entry entries[];
>  };
>  
>  /* The argument to IP6T_SO_GET_ENTRIES. */
> @@ -255,7 +255,7 @@ struct ip6t_get_entries {
>  	unsigned int size;
>  
>  	/* The entries. */
> -	struct ip6t_entry entrytable[0];
> +	struct ip6t_entry entrytable[];
>  };
>  
>  /* Helper functions */
> 
