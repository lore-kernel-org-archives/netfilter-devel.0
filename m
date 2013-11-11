From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 1/3] Fix all set output from list/save when set with
 counters in use.
Date: Mon, 11 Nov 2013 22:31:53 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1311112230150.8236@blackhole.kfki.hu>
References: <2029158.eclrSoCAaG@tuxracer>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Sergey Popovich <popovich_sergei@mail.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:40081 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768Ab3KKVbz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Nov 2013 16:31:55 -0500
In-Reply-To: <2029158.eclrSoCAaG@tuxracer>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 7 Nov 2013, Sergey Popovich wrote:

> Using upstream version with counters support we have following
> output when listing all sets currently configured:
> --------------------------------------------------
> 
>  # ipset create test-1 hash:ip
>  # ipset create test-2 hash:ip counters
>  # ipset add test-2 192.0.2.1/32
>  # ipset create test-3 hash:ip
>  # ipset add test-3 192.0.2.1/32
>  # ipset list
>  Name: test-1
>  Type: hash:ip
>  Revision: 2
>  Header: family inet hashsize 1024 maxelem 65536
>  Size in memory: 16504
>  References: 0
>  Members:
> 
>  Name: test-2
>  Type: hash:ip
>  Revision: 2
>  Header: family inet hashsize 1024 maxelem 65536 counters
>  Size in memory: 16616
>  References: 0
>  Members:
>  192.0.2.1 packets 0 bytes 0
> 
>  Name: test-3
>  Type: hash:ip
>  Revision: 2
>  Header: family inet hashsize 1024 maxelem 65536 counters
>  Size in memory: 16520
>  References: 0
>  Members:
>  192.0.2.1 packets 0 bytes 0
> 
> Set test-3 created without counters, but displayed as with counters
> present.
> 
> Restricting output to list only test-3 set we have:
> ---------------------------------------------------
>   # ipset list test-3
>   Name: test-3
>   Type: hash:ip
>   Revision: 2
>   Header: family inet hashsize 1024 maxelem 65536
>   Size in memory: 16520
>   References: 0
>   Members:
>   192.0.2.1
> 
> So test-3 set created correctly without counters support, but in
> all sets listing it displayed as such one with counters.
> 
> It seems with commit 5a6021823aa0da24b83f8d03f46ad4202f149fa3
> (Support counters in the ipset library) we fogot to add counter
> options flags to IPSET_CREATE_FLAGS and IPSET_ADT_FLAGS defines to
> clear these flags when preparing output in callback_list() from
> lib/session.c.
> 
> Signed-off-by: Sergey Popovich <popovich_sergei@mail.ru>
> ---
>  include/libipset/data.h |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/include/libipset/data.h b/include/libipset/data.h
> index b6e75e8..fded8bd 100644
> --- a/include/libipset/data.h
> +++ b/include/libipset/data.h
> @@ -90,6 +90,9 @@ enum ipset_opt {
>  	| IPSET_FLAG(IPSET_OPT_PROBES)	\
>  	| IPSET_FLAG(IPSET_OPT_RESIZE)	\
>  	| IPSET_FLAG(IPSET_OPT_SIZE)	\
> +	| IPSET_FLAG(IPSET_OPT_COUNTERS)\
> +	| IPSET_FLAG(IPSET_OPT_PACKETS)	\
> +	| IPSET_FLAG(IPSET_OPT_BYTES)	\
>  	| IPSET_FLAG(IPSET_OPT_CREATE_COMMENT))

There's no need to add IPSET_OPT_PACKETS and IPSET_OPT_BYTES to the CREATE 
option flags, and
  
>  #define IPSET_ADT_FLAGS			\
> @@ -110,6 +113,9 @@ enum ipset_opt {
>  	| IPSET_FLAG(IPSET_OPT_BEFORE) \
>  	| IPSET_FLAG(IPSET_OPT_PHYSDEV) \
>  	| IPSET_FLAG(IPSET_OPT_NOMATCH) \
> +	| IPSET_FLAG(IPSET_OPT_COUNTERS)\
> +	| IPSET_FLAG(IPSET_OPT_PACKETS)	\
> +	| IPSET_FLAG(IPSET_OPT_BYTES)	\
>  	| IPSET_FLAG(IPSET_OPT_ADT_COMMENT))

similarly, IPSET_OPT_COUNTERS is not required at the ADT option flags.

Please resubmit the patch with these changes. Thanks.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
