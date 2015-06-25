From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [RESEND PATCH V2] Add element count to hash headers
Date: Thu, 25 Jun 2015 10:04:26 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1506251002530.6678@blackhole.kfki.hu>
References: <1432913785-22187-1-git-send-email-emunson@akamai.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Josh Hunt <johunt@akamai.com>, netfilter-devel@vger.kernel.org
To: Eric B Munson <emunson@akamai.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:39326 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502AbbFYIEW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Jun 2015 04:04:22 -0400
In-Reply-To: <1432913785-22187-1-git-send-email-emunson@akamai.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Fri, 29 May 2015, Eric B Munson wrote:

> It would be useful for userspace to query the size of an ipset hash,
> however, this data is not exposed to userspace outside of counting the
> number of member entries.  This patch uses the attribute
> IPSET_ATTR_ELEMENTS to indicate the size in the the header that is
> exported to userspace.  This field is then printed by the userspace
> tool for hashes.
> 
> Because it is only meaningful for hashes to report their size, the
> output is conditional on the set type.  To do this checking the
> MATCH_TYPENAME macro was moved to utils.h.

The patch is applied with a slight modification: "Number of 
entries" is printed instead of "Number of Entries". Thank you!

Best regards,
Jozsef

> The bulk of this patch changes the expected test suite to account for
> the change in output.
> 
> Signed-off-by: Eric B Munson <emunson@akamai.com>
> Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> Cc: Josh Hunt <johunt@akamai.com>
> Cc: netfilter-devel@vger.kernel.org
> ---
> This is the same as the V2 I posted in Decemeber with a rebase to the
> latest upstream
> 
>  include/libipset/utils.h                     |  3 +++
>  kernel/net/netfilter/ipset/ip_set_hash_gen.h |  3 ++-
>  lib/errcode.c                                |  2 --
>  lib/session.c                                | 14 ++++++++++++--
>  tests/check_cidrs.sh                         |  4 ++--
>  tests/comment.t.list2                        |  3 ++-
>  tests/comment.t.list21                       |  3 ++-
>  tests/comment.t.list22                       |  3 ++-
>  tests/comment.t.list3                        |  9 ++++++---
>  tests/hash:ip,mark.t.list0                   |  3 ++-
>  tests/hash:ip,mark.t.list1                   |  3 ++-
>  tests/hash:ip,port,ip.t.list0                |  3 ++-
>  tests/hash:ip,port,ip.t.list1                |  3 ++-
>  tests/hash:ip,port,net.t.list0               |  3 ++-
>  tests/hash:ip,port.t.list0                   |  3 ++-
>  tests/hash:ip,port.t.list1                   |  3 ++-
>  tests/hash:ip,port.t.list2                   |  3 ++-
>  tests/hash:ip.t.list0                        |  3 ++-
>  tests/hash:ip.t.list1                        |  3 ++-
>  tests/hash:ip.t.list2                        |  3 ++-
>  tests/hash:ip.t.list3                        |  3 ++-
>  tests/hash:ip6,mark.t.list0                  |  3 ++-
>  tests/hash:ip6,mark.t.list1                  |  3 ++-
>  tests/hash:ip6,port,ip6.t.list0              |  4 +++-
>  tests/hash:ip6,port,ip6.t.list1              |  3 ++-
>  tests/hash:ip6,port,net6.t.list0             |  3 ++-
>  tests/hash:ip6,port.t.list0                  |  3 ++-
>  tests/hash:ip6,port.t.list1                  |  3 ++-
>  tests/hash:ip6.t.list0                       |  3 ++-
>  tests/hash:ip6.t.list1                       |  3 ++-
>  tests/hash:ip6.t.list2                       |  3 ++-
>  tests/hash:ip6.t.list3                       |  3 ++-
>  tests/hash:mac.t.list0                       |  3 ++-
>  tests/hash:mac.t.list1                       |  3 ++-
>  tests/hash:mac.t.list2                       |  3 ++-
>  tests/hash:mac.t.list3                       |  3 ++-
>  tests/hash:net,iface.t                       |  2 +-
>  tests/hash:net,iface.t.list0                 |  3 ++-
>  tests/hash:net,iface.t.list1                 |  3 ++-
>  tests/hash:net,iface.t.list2                 |  3 ++-
>  tests/hash:net,net.t.list0                   |  3 ++-
>  tests/hash:net,net.t.list1                   |  3 ++-
>  tests/hash:net,net.t.list2                   |  3 ++-
>  tests/hash:net,port,net.t.list0              |  3 ++-
>  tests/hash:net,port.t.list0                  |  3 ++-
>  tests/hash:net,port.t.list1                  |  3 ++-
>  tests/hash:net.t.list0                       |  3 ++-
>  tests/hash:net.t.list1                       |  3 ++-
>  tests/hash:net.t.list2                       |  3 ++-
>  tests/hash:net6,net6.t.list0                 |  3 ++-
>  tests/hash:net6,net6.t.list1                 |  3 ++-
>  tests/hash:net6,port,net6.t.list0            |  3 ++-
>  tests/hash:net6,port.t.list0                 |  3 ++-
>  tests/hash:net6,port.t.list1                 |  3 ++-
>  tests/hash:net6.t.list0                      |  3 ++-
>  tests/hash:net6.t.list1                      |  3 ++-
>  tests/iphash.t.list0                         |  3 ++-
>  tests/iphash.t.list1                         |  3 ++-
>  tests/ipmarkhash.t.list0                     |  3 ++-
>  tests/ipmarkhash.t.list1                     |  3 ++-
>  tests/ipporthash.t.list0                     |  3 ++-
>  tests/ipporthash.t.list1                     |  3 ++-
>  tests/ipportiphash.t.list0                   |  3 ++-
>  tests/ipportiphash.t.list1                   |  3 ++-
>  tests/iptables.sh                            |  2 +-
>  tests/nethash.t.list0                        |  3 ++-
>  tests/resizet.sh                             |  2 +-
>  tests/restore.t.list0                        |  3 ++-
>  tests/restore.t.list1                        |  3 ++-
>  tests/setlist.t.list4                        | 12 ++++++++----
>  tests/sort.sh                                |  4 ++--
>  71 files changed, 159 insertions(+), 79 deletions(-)
> 
> diff --git a/include/libipset/utils.h b/include/libipset/utils.h
> index 3cd29da..ceedd45 100644
> --- a/include/libipset/utils.h
> +++ b/include/libipset/utils.h
> @@ -19,6 +19,9 @@
>  #define STRCASEQ(a, b)		(strcasecmp(a, b) == 0)
>  #define STRNCASEQ(a, b, n)	(strncasecmp(a, b, n) == 0)
>  
> +/* Match set type names */
> +#define MATCH_TYPENAME(a, b)    STRNEQ(a, b, strlen(b))
> +
>  /* Stringify tokens */
>  #define _STR(c)			#c
>  #define STR(c)			_STR(c)
> diff --git a/kernel/net/netfilter/ipset/ip_set_hash_gen.h b/kernel/net/netfilter/ipset/ip_set_hash_gen.h
> index 878d35f..bfa1fc7 100644
> --- a/kernel/net/netfilter/ipset/ip_set_hash_gen.h
> +++ b/kernel/net/netfilter/ipset/ip_set_hash_gen.h
> @@ -1068,7 +1068,8 @@ mtype_head(struct ip_set *set, struct sk_buff *skb)
>  		goto nla_put_failure;
>  #endif
>  	if (nla_put_net32(skb, IPSET_ATTR_REFERENCES, htonl(set->ref - 1)) ||
> -	    nla_put_net32(skb, IPSET_ATTR_MEMSIZE, htonl(memsize)))
> +	    nla_put_net32(skb, IPSET_ATTR_MEMSIZE, htonl(memsize)) ||
> +	    nla_put_net32(skb, IPSET_ATTR_ELEMENTS, htonl(h->elements)))
>  		goto nla_put_failure;
>  	if (unlikely(ip_set_put_flags(skb, set)))
>  		goto nla_put_failure;
> diff --git a/lib/errcode.c b/lib/errcode.c
> index 8eb275b..3881121 100644
> --- a/lib/errcode.c
> +++ b/lib/errcode.c
> @@ -148,8 +148,6 @@ static const struct ipset_errcode_table list_errcode_table[] = {
>  	{ },
>  };
>  
> -#define MATCH_TYPENAME(a, b)	STRNEQ(a, b, strlen(b))
> -
>  /**
>   * ipset_errcode - interpret a kernel error code
>   * @session: session structure
> diff --git a/lib/session.c b/lib/session.c
> index 013d9d8..be45a87 100644
> --- a/lib/session.c
> +++ b/lib/session.c
> @@ -931,6 +931,10 @@ list_create(struct ipset_session *session, struct nlattr *nla[])
>  		safe_dprintf(session, ipset_print_number, IPSET_OPT_MEMSIZE);
>  		safe_snprintf(session, "\nReferences: ");
>  		safe_dprintf(session, ipset_print_number, IPSET_OPT_REFERENCES);
> +		if (MATCH_TYPENAME(type->name , "hash:")) {
> +			safe_snprintf(session, "\nNumber of Entries: ");
> +			safe_dprintf(session, ipset_print_number, IPSET_OPT_ELEMENTS);
> +		}
>  		safe_snprintf(session,
>  			session->envopts & IPSET_ENV_LIST_HEADER ?
>  			"\n" : "\nMembers:\n");
> @@ -940,10 +944,16 @@ list_create(struct ipset_session *session, struct nlattr *nla[])
>  		safe_dprintf(session, ipset_print_number, IPSET_OPT_MEMSIZE);
>  		safe_snprintf(session, "</memsize>\n<references>");
>  		safe_dprintf(session, ipset_print_number, IPSET_OPT_REFERENCES);
> +		safe_snprintf(session, "</references>\n");
> +		if (MATCH_TYPENAME(type->name , "hash:")) {
> +			safe_snprintf(session, "<numentries>");
> +			safe_dprintf(session, ipset_print_number, IPSET_OPT_ELEMENTS);
> +			safe_snprintf(session, "</numentries>\n");
> +		}
>  		safe_snprintf(session,
>  			session->envopts & IPSET_ENV_LIST_HEADER ?
> -			"</references>\n</header>\n" :
> -			"</references>\n</header>\n<members>\n");
> +			"</header>\n" :
> +			"</header>\n<members>\n");
>  		break;
>  	default:
>  		break;
> diff --git a/tests/check_cidrs.sh b/tests/check_cidrs.sh
> index 38f735f..2206b18 100755
> --- a/tests/check_cidrs.sh
> +++ b/tests/check_cidrs.sh
> @@ -10,14 +10,14 @@ $ipset n test hash:net
>  for x in `seq 1 32`; do
>      $ipset a test 10.0.0.0/$x
>      n=`$ipset l test | wc -l`
> -    n=$((n - 7))
> +    n=$((n - 8))
>      test $n -eq $x || exit 1
>  done
>  for x in `seq 32 -1 1`; do
>      $ipset d test 10.0.0.0/$x
>      n=`$ipset l test | wc -l`
>      # We deleted one element
> -    n=$((n - 7 + 1))
> +    n=$((n - 8 + 1))
>      test $n -eq $x || exit 1
>  done
>  $ipset x test
> diff --git a/tests/comment.t.list2 b/tests/comment.t.list2
> index 76d0cea..d751822 100644
> --- a/tests/comment.t.list2
> +++ b/tests/comment.t.list2
> @@ -1,8 +1,9 @@
>  Name: test
>  Type: hash:net,net
>  Header: family inet hashsize 128 maxelem 65536 comment
> -Size in memory: 3392
> +Size in memory: 1288
>  References: 0
> +Number of Entries: 4
>  Members:
>  1.1.1.1,1.1.1.2 comment "text 1.1.1.1/32,1.1.1.2/32"
>  192.168.68.64/27,192.168.129.64/27 comment "text 192.168.68.69/27,192.168.129.69/27"
> diff --git a/tests/comment.t.list21 b/tests/comment.t.list21
> index a40889e..739639f 100644
> --- a/tests/comment.t.list21
> +++ b/tests/comment.t.list21
> @@ -1,8 +1,9 @@
>  Name: test
>  Type: hash:ip
>  Header: family inet hashsize 1024 maxelem 65536 timeout x comment
> -Size in memory: 101400
> +Size in memory: 95168
>  References: 0
> +Number of Entries: 512
>  Members:
>  2.0.0.0 timeout x comment "text message 0"
>  2.0.0.1 timeout x comment "text message 1"
> diff --git a/tests/comment.t.list22 b/tests/comment.t.list22
> index 1ae1bf1..458ab57 100644
> --- a/tests/comment.t.list22
> +++ b/tests/comment.t.list22
> @@ -1,8 +1,9 @@
>  Name: test
>  Type: hash:ip
>  Header: family inet hashsize 1024 maxelem 65536 timeout x comment
> -Size in memory: 100152
> +Size in memory: 98256
>  References: 0
> +Number of Entries: 512
>  Members:
>  2.0.1.0 timeout x comment "text message 0"
>  2.0.1.1 timeout x comment "text message 1"
> diff --git a/tests/comment.t.list3 b/tests/comment.t.list3
> index d460bf5..1bd0ba7 100644
> --- a/tests/comment.t.list3
> +++ b/tests/comment.t.list3
> @@ -1,22 +1,25 @@
>  Name: a
>  Type: hash:ip
>  Header: family inet hashsize 1024 maxelem 65536
> -Size in memory: 16536
> +Size in memory: 128
>  References: 1
> +Number of Entries: 0
>  Members:
>  
>  Name: b
>  Type: hash:ip
>  Header: family inet hashsize 1024 maxelem 65536
> -Size in memory: 16536
> +Size in memory: 128
>  References: 1
> +Number of Entries: 0
>  Members:
>  
>  Name: c
>  Type: hash:ip
>  Header: family inet hashsize 1024 maxelem 65536
> -Size in memory: 16536
> +Size in memory: 128
>  References: 1
> +Number of Entries: 0
>  Members:
>  
>  Name: test
> diff --git a/tests/hash:ip,mark.t.list0 b/tests/hash:ip,mark.t.list0
> index 715654c..fbdb56b 100644
> --- a/tests/hash:ip,mark.t.list0
> +++ b/tests/hash:ip,mark.t.list0
> @@ -1,8 +1,9 @@
>  Name: test
>  Type: hash:ip,mark
>  Header: family inet markmask 0xffffffff hashsize 1024 maxelem 65536 timeout x
> -Size in memory: 8836
> +Size in memory: 640
>  References: 0
> +Number of Entries: 4
>  Members:
>  2.0.0.0,0x00000005 timeout x
>  2.0.0.1,0x00000005 timeout x
> diff --git a/tests/hash:ip,mark.t.list1 b/tests/hash:ip,mark.t.list1
> index 093c94f..784bc7a 100644
> --- a/tests/hash:ip,mark.t.list1
> +++ b/tests/hash:ip,mark.t.list1
> @@ -1,6 +1,7 @@
>  Name: test
>  Type: hash:ip,mark
>  Header: family inet markmask 0xffffffff hashsize 1024 maxelem 65536 timeout 5
> -Size in memory: 8836
> +Size in memory: 640
>  References: 0
> +Number of Entries: 4
>  Members:
> diff --git a/tests/hash:ip,port,ip.t.list0 b/tests/hash:ip,port,ip.t.list0
> index 7218937..df811ce 100644
> --- a/tests/hash:ip,port,ip.t.list0
> +++ b/tests/hash:ip,port,ip.t.list0
> @@ -1,8 +1,9 @@
>  Name: test
>  Type: hash:ip,port,ip
>  Header: family inet hashsize 1024 maxelem 65536 timeout x
> -Size in memory: 8720
> +Size in memory: 840
>  References: 0
> +Number of Entries: 4
>  Members:
>  2.0.0.0,tcp:5,1.1.1.1 timeout x
>  2.0.0.1,tcp:5,1.1.1.1 timeout x
> diff --git a/tests/hash:ip,port,ip.t.list1 b/tests/hash:ip,port,ip.t.list1
> index 78ad1fd..d00c9d7 100644
> --- a/tests/hash:ip,port,ip.t.list1
> +++ b/tests/hash:ip,port,ip.t.list1
> @@ -1,6 +1,7 @@
>  Name: test
>  Type: hash:ip,port,ip
>  Header: family inet hashsize 1024 maxelem 65536 timeout 5
> -Size in memory: 8304
> +Size in memory: 840
>  References: 0
> +Number of Entries: 4
>  Members:
> diff --git a/tests/hash:ip,port,net.t.list0 b/tests/hash:ip,port,net.t.list0
> index c214ead..ea0e963 100644
> --- a/tests/hash:ip,port,net.t.list0
> +++ b/tests/hash:ip,port,net.t.list0
> @@ -1,8 +1,9 @@
>  Name: test
>  Type: hash:ip,port,net
>  Header: family inet hashsize 1024 maxelem 65536 timeout x
> -Size in memory: 8720
> +Size in memory: 1096
>  References: 0
> +Number of Entries: 4
>  Members:
>  2.0.0.0,tcp:5,192.168.0.0/25 timeout x
>  2.0.0.1,tcp:5,192.168.0.0/24 timeout x
> diff --git a/tests/hash:ip,port.t.list0 b/tests/hash:ip,port.t.list0
> index fb9c57b..24b8b99 100644
> --- a/tests/hash:ip,port.t.list0
> +++ b/tests/hash:ip,port.t.list0
> @@ -1,8 +1,9 @@
>  Name: test
>  Type: hash:ip,port
>  Header: family inet hashsize 1024 maxelem 65536 timeout x
> -Size in memory: 8592
> +Size in memory: 640
>  References: 0
> +Number of Entries: 4
>  Members:
>  2.0.0.0,tcp:5 timeout x
>  2.0.0.1,tcp:5 timeout x
> diff --git a/tests/hash:ip,port.t.list1 b/tests/hash:ip,port.t.list1
> index eab115c..7a82514 100644
> --- a/tests/hash:ip,port.t.list1
> +++ b/tests/hash:ip,port.t.list1
> @@ -1,6 +1,7 @@
>  Name: test
>  Type: hash:ip,port
>  Header: family inet hashsize 1024 maxelem 65536 timeout 5
> -Size in memory: 8304
> +Size in memory: 640
>  References: 0
> +Number of Entries: 4
>  Members:
> diff --git a/tests/hash:ip,port.t.list2 b/tests/hash:ip,port.t.list2
> index 7e7f3ad..2e7cf42 100644
> --- a/tests/hash:ip,port.t.list2
> +++ b/tests/hash:ip,port.t.list2
> @@ -1,8 +1,9 @@
>  Name: test
>  Type: hash:ip,port
>  Header: family inet hashsize 1024 maxelem 65536
> -Size in memory: 8432
> +Size in memory: 320
>  References: 0
> +Number of Entries: 3
>  Members:
>  2.0.0.1,tcp:80
>  2.0.0.1,udp:80
> diff --git a/tests/hash:ip.t.list0 b/tests/hash:ip.t.list0
> index 3d13afc..4f6f241 100644
> --- a/tests/hash:ip.t.list0
> +++ b/tests/hash:ip.t.list0
> @@ -1,7 +1,8 @@
>  Name: test
>  Type: hash:ip
>  Header: family inet hashsize 128 maxelem 65536 timeout 5
> -Size in memory: 1208
> +Size in memory: 352
>  References: 0
> +Number of Entries: 2
>  Members:
>  192.168.68.69 timeout 0
> diff --git a/tests/hash:ip.t.list1 b/tests/hash:ip.t.list1
> index ffd4f72..45b5e04 100644
> --- a/tests/hash:ip.t.list1
> +++ b/tests/hash:ip.t.list1
> @@ -1,7 +1,8 @@
>  Name: test
>  Type: hash:ip
>  Header: family inet hashsize 128 maxelem 65536 netmask 24 timeout 5
> -Size in memory: 1352
> +Size in memory: 464
>  References: 0
> +Number of Entries: 3
>  Members:
>  200.100.10.0 timeout 0
> diff --git a/tests/hash:ip.t.list2 b/tests/hash:ip.t.list2
> index 274cf47..dc74248 100644
> --- a/tests/hash:ip.t.list2
> +++ b/tests/hash:ip.t.list2
> @@ -1,8 +1,9 @@
>  Name: test
>  Type: hash:ip
>  Header: family inet hashsize 128 maxelem 65536 timeout x
> -Size in memory: 1280
> +Size in memory: 352
>  References: 0
> +Number of Entries: 2
>  Members:
>  192.168.68.69 timeout x
>  2.0.0.1 timeout x
> diff --git a/tests/hash:ip.t.list3 b/tests/hash:ip.t.list3
> index 5077710..95eb07b 100644
> --- a/tests/hash:ip.t.list3
> +++ b/tests/hash:ip.t.list3
> @@ -1,8 +1,9 @@
>  Name: test
>  Type: hash:ip
>  Header: family inet hashsize 128 maxelem 65536 netmask 24 timeout x
> -Size in memory: 1352
> +Size in memory: 464
>  References: 0
> +Number of Entries: 3
>  Members:
>  192.168.68.0 timeout x
>  2.0.0.0 timeout x
> diff --git a/tests/hash:ip6,mark.t.list0 b/tests/hash:ip6,mark.t.list0
> index f905b2a..625497d 100644
> --- a/tests/hash:ip6,mark.t.list0
> +++ b/tests/hash:ip6,mark.t.list0
> @@ -1,8 +1,9 @@
>  Name: test
>  Type: hash:ip,mark
>  Header: family inet6 markmask 0xffffffff hashsize 1024 maxelem 65536 timeout x
> -Size in memory: 9316
> +Size in memory: 1088
>  References: 0
> +Number of Entries: 4
>  Members:
>  2:1::,0x00000080 timeout x
>  2:1::1,0x00000080 timeout x
> diff --git a/tests/hash:ip6,mark.t.list1 b/tests/hash:ip6,mark.t.list1
> index d40faed..c562b8d 100644
> --- a/tests/hash:ip6,mark.t.list1
> +++ b/tests/hash:ip6,mark.t.list1
> @@ -1,6 +1,7 @@
>  Name: test
>  Type: hash:ip,mark
>  Header: family inet6 markmask 0xffffffff hashsize 1024 maxelem 65536 timeout 5
> -Size in memory: 9316
> +Size in memory: 1088
>  References: 0
> +Number of Entries: 4
>  Members:
> diff --git a/tests/hash:ip6,port,ip6.t.list0 b/tests/hash:ip6,port,ip6.t.list0
> index 41ac1c0..c60599b 100644
> --- a/tests/hash:ip6,port,ip6.t.list0
> +++ b/tests/hash:ip6,port,ip6.t.list0
> @@ -1,8 +1,10 @@
>  Name: test
>  Type: hash:ip,port,ip
>  Header: family inet6 hashsize 1024 maxelem 65536 timeout x
> -Size in memory: 9104
> +Size in memory: 1608
>  References: 0
> +Size in memory: 9104
> +Number of Entries: 4
>  Members:
>  2:1::,tcp:128,2:2:2::2 timeout x
>  2:1::1,tcp:128,2:2:2::2 timeout x
> diff --git a/tests/hash:ip6,port,ip6.t.list1 b/tests/hash:ip6,port,ip6.t.list1
> index 7a3a4ad..01d83ae 100644
> --- a/tests/hash:ip6,port,ip6.t.list1
> +++ b/tests/hash:ip6,port,ip6.t.list1
> @@ -1,6 +1,7 @@
>  Name: test
>  Type: hash:ip,port,ip
>  Header: family inet6 hashsize 1024 maxelem 65536 timeout 5
> -Size in memory: 8304
> +Size in memory: 1608
>  References: 0
> +Number of Entries: 4
>  Members:
> diff --git a/tests/hash:ip6,port,net6.t.list0 b/tests/hash:ip6,port,net6.t.list0
> index 78472ff..a1e71a2 100644
> --- a/tests/hash:ip6,port,net6.t.list0
> +++ b/tests/hash:ip6,port,net6.t.list0
> @@ -1,8 +1,9 @@
>  Name: test
>  Type: hash:ip,port,net
>  Header: family inet6 hashsize 1024 maxelem 65536
> -Size in memory: 9928
> +Size in memory: 1864
>  References: 0
> +Number of Entries: 4
>  Members:
>  2:1::,tcp:128,::/12
>  2:1::1,tcp:128,::/12
> diff --git a/tests/hash:ip6,port.t.list0 b/tests/hash:ip6,port.t.list0
> index 5edbaac..cfed8c4 100644
> --- a/tests/hash:ip6,port.t.list0
> +++ b/tests/hash:ip6,port.t.list0
> @@ -1,8 +1,9 @@
>  Name: test
>  Type: hash:ip,port
>  Header: family inet6 hashsize 1024 maxelem 65536 timeout x
> -Size in memory: 8848
> +Size in memory: 1088
>  References: 0
> +Number of Entries: 4
>  Members:
>  2:1::,tcp:128 timeout x
>  2:1::1,tcp:128 timeout x
> diff --git a/tests/hash:ip6,port.t.list1 b/tests/hash:ip6,port.t.list1
> index bf31179..638f685 100644
> --- a/tests/hash:ip6,port.t.list1
> +++ b/tests/hash:ip6,port.t.list1
> @@ -1,6 +1,7 @@
>  Name: test
>  Type: hash:ip,port
>  Header: family inet6 hashsize 1024 maxelem 65536 timeout 5
> -Size in memory: 8304
> +Size in memory: 1088
>  References: 0
> +Number of Entries: 4
>  Members:
> diff --git a/tests/hash:ip6.t.list0 b/tests/hash:ip6.t.list0
> index df81e38..a64a38f 100644
> --- a/tests/hash:ip6.t.list0
> +++ b/tests/hash:ip6.t.list0
> @@ -1,7 +1,8 @@
>  Name: test
>  Type: hash:ip
>  Header: family inet6 hashsize 128 maxelem 65536 timeout 5
> -Size in memory: 1240
> +Size in memory: 512
>  References: 0
> +Number of Entries: 2
>  Members:
>  192:168:68::69 timeout 0
> diff --git a/tests/hash:ip6.t.list1 b/tests/hash:ip6.t.list1
> index c3b1c30..50227dd 100644
> --- a/tests/hash:ip6.t.list1
> +++ b/tests/hash:ip6.t.list1
> @@ -1,7 +1,8 @@
>  Name: test
>  Type: hash:ip
>  Header: family inet6 hashsize 128 maxelem 65536 netmask 64 timeout 5
> -Size in memory: 1448
> +Size in memory: 704
>  References: 0
> +Number of Entries: 3
>  Members:
>  200:100:10:: timeout 0
> diff --git a/tests/hash:ip6.t.list2 b/tests/hash:ip6.t.list2
> index 1989efd..d7fd068 100644
> --- a/tests/hash:ip6.t.list2
> +++ b/tests/hash:ip6.t.list2
> @@ -1,8 +1,9 @@
>  Name: test
>  Type: hash:ip
>  Header: family inet6 hashsize 128 maxelem 65536 timeout x
> -Size in memory: 1344
> +Size in memory: 512
>  References: 0
> +Number of Entries: 2
>  Members:
>  192:168:68::69 timeout x
>  2::1 timeout x
> diff --git a/tests/hash:ip6.t.list3 b/tests/hash:ip6.t.list3
> index ece96d6..9a03f31 100644
> --- a/tests/hash:ip6.t.list3
> +++ b/tests/hash:ip6.t.list3
> @@ -1,8 +1,9 @@
>  Name: test
>  Type: hash:ip
>  Header: family inet6 hashsize 128 maxelem 65536 netmask 64 timeout x
> -Size in memory: 1448
> +Size in memory: 704
>  References: 0
> +Number of Entries: 3
>  Members:
>  192:168:68:: timeout x
>  200:100:10:: timeout x
> diff --git a/tests/hash:mac.t.list0 b/tests/hash:mac.t.list0
> index c2bbfd6..885f558 100644
> --- a/tests/hash:mac.t.list0
> +++ b/tests/hash:mac.t.list0
> @@ -1,7 +1,8 @@
>  Name: test
>  Type: hash:mac
>  Header: hashsize 128 maxelem 65536 timeout 5
> -Size in memory: 2488
> +Size in memory: 384
>  References: 0
> +Number of Entries: 2
>  Members:
>  00:0A:00:00:00:00 timeout 0
> diff --git a/tests/hash:mac.t.list1 b/tests/hash:mac.t.list1
> index 185f35f..cd48b8e 100644
> --- a/tests/hash:mac.t.list1
> +++ b/tests/hash:mac.t.list1
> @@ -1,8 +1,9 @@
>  Name: test
>  Type: hash:mac
>  Header: hashsize 1024 maxelem 65536 skbinfo
> -Size in memory: 17304
> +Size in memory: 1088
>  References: 0
> +Number of Entries: 6
>  Members:
>  01:02:03:04:05:06 skbmark 0x123456
>  01:02:03:04:05:07 skbmark 0x1234ab/0xffff
> diff --git a/tests/hash:mac.t.list2 b/tests/hash:mac.t.list2
> index 2bec98d..aef2669 100644
> --- a/tests/hash:mac.t.list2
> +++ b/tests/hash:mac.t.list2
> @@ -1,8 +1,9 @@
>  Name: test
>  Type: hash:mac
>  Header: hashsize 128 maxelem 65536 timeout x
> -Size in memory: 2488
> +Size in memory: 384
>  References: 0
> +Number of Entries: 2
>  Members:
>  00:00:00:00:02:00 timeout x
>  00:0A:00:00:00:00 timeout x
> diff --git a/tests/hash:mac.t.list3 b/tests/hash:mac.t.list3
> index ab0bf9e..e35f058 100644
> --- a/tests/hash:mac.t.list3
> +++ b/tests/hash:mac.t.list3
> @@ -1,8 +1,9 @@
>  Name: test
>  Type: hash:mac
>  Header: hashsize 1024 maxelem 2 skbinfo
> -Size in memory: 632
> +Size in memory: 448
>  References: 0
> +Number of Entries: 2
>  Members:
>  01:02:03:04:05:06 skbprio 1:10
>  01:02:03:04:05:07 skbprio 1:12 skbqueue 8
> diff --git a/tests/hash:net,iface.t b/tests/hash:net,iface.t
> index 21ba1c7..c19de2b 100644
> --- a/tests/hash:net,iface.t
> +++ b/tests/hash:net,iface.t
> @@ -131,7 +131,7 @@
>  # Add clashing elements
>  0 (set -e; for x in `seq 0 63`; do ipset add test 10.0.0.0/16,eth$x; done)
>  # Check listing
> -0 n=`ipset list test | grep -v Revision: | wc -l` && test $n -eq 70
> +0 n=`ipset list test | grep -v Revision: | wc -l` && test $n -eq 71
>  # Delete test set
>  0 ipset destroy test
>  # Create test set with timeout support
> diff --git a/tests/hash:net,iface.t.list0 b/tests/hash:net,iface.t.list0
> index 4bf10fe..4bd53cc 100644
> --- a/tests/hash:net,iface.t.list0
> +++ b/tests/hash:net,iface.t.list0
> @@ -1,8 +1,9 @@
>  Name: test
>  Type: hash:net,iface
>  Header: family inet hashsize 128 maxelem 65536
> -Size in memory: 2928
> +Size in memory: 928
>  References: 0
> +Number of Entries: 4
>  Members:
>  1.1.1.1,eth0
>  192.168.68.64/27,eth1
> diff --git a/tests/hash:net,iface.t.list1 b/tests/hash:net,iface.t.list1
> index de56129..f46e6ad 100644
> --- a/tests/hash:net,iface.t.list1
> +++ b/tests/hash:net,iface.t.list1
> @@ -1,8 +1,9 @@
>  Name: test
>  Type: hash:net,iface
>  Header: family inet hashsize 1024 maxelem 65536
> -Size in memory: 18512
> +Size in memory: 3872
>  References: 0
> +Number of Entries: 27
>  Members:
>  192.0.0.0/10,eth10
>  192.0.0.0/11,eth11
> diff --git a/tests/hash:net,iface.t.list2 b/tests/hash:net,iface.t.list2
> index fbd502c..f19bc7a 100644
> --- a/tests/hash:net,iface.t.list2
> +++ b/tests/hash:net,iface.t.list2
> @@ -1,8 +1,9 @@
>  Name: test
>  Type: hash:net,iface
>  Header: family inet hashsize 1024 maxelem 65536
> -Size in memory: 17168
> +Size in memory: 928
>  References: 0
> +Number of Entries: 4
>  Members:
>  10.2.0.0/24,eth0
>  10.2.1.0/29,eth0
> diff --git a/tests/hash:net,net.t.list0 b/tests/hash:net,net.t.list0
> index b759316..cc2784e 100644
> --- a/tests/hash:net,net.t.list0
> +++ b/tests/hash:net,net.t.list0
> @@ -1,8 +1,9 @@
>  Name: test
>  Type: hash:net,net
>  Header: family inet hashsize 128 maxelem 65536 timeout x
> -Size in memory: 3040
> +Size in memory: 1288
>  References: 0
> +Number of Entries: 4
>  Members:
>  1.1.1.1,1.1.1.2 timeout x
>  192.168.68.64/27,192.168.129.64/27 timeout x
> diff --git a/tests/hash:net,net.t.list1 b/tests/hash:net,net.t.list1
> index d27b4a4..5a154d3 100644
> --- a/tests/hash:net,net.t.list1
> +++ b/tests/hash:net,net.t.list1
> @@ -1,6 +1,7 @@
>  Name: test
>  Type: hash:net,net
>  Header: family inet hashsize 128 maxelem 65536 timeout 5
> -Size in memory: 3040
> +Size in memory: 1288
>  References: 0
> +Number of Entries: 4
>  Members:
> diff --git a/tests/hash:net,net.t.list2 b/tests/hash:net,net.t.list2
> index adf26ff..07a288a 100644
> --- a/tests/hash:net,net.t.list2
> +++ b/tests/hash:net,net.t.list2
> @@ -1,8 +1,9 @@
>  Name: test
>  Type: hash:net,net
>  Header: family inet hashsize 1024 maxelem 65536
> -Size in memory: 17664
> +Size in memory: 2056
>  References: 0
> +Number of Entries: 16
>  Members:
>  10.2.0.0/24,10.3.0.0/24
>  10.2.0.0/24,10.3.1.0/29
> diff --git a/tests/hash:net,port,net.t.list0 b/tests/hash:net,port,net.t.list0
> index 0d90e62..19c91ad 100644
> --- a/tests/hash:net,port,net.t.list0
> +++ b/tests/hash:net,port,net.t.list0
> @@ -1,8 +1,9 @@
>  Name: test
>  Type: hash:net,port,net
>  Header: family inet hashsize 1024 maxelem 65536 timeout x
> -Size in memory: 17672
> +Size in memory: 1288
>  References: 0
> +Number of Entries: 4
>  Members:
>  2.0.0.0/24,tcp:5,192.168.0.0/24 timeout x
>  2.0.0.0/24,tcp:5,192.168.0.0/25 timeout x
> diff --git a/tests/hash:net,port.t.list0 b/tests/hash:net,port.t.list0
> index e28b4a3..6cf4326 100644
> --- a/tests/hash:net,port.t.list0
> +++ b/tests/hash:net,port.t.list0
> @@ -1,8 +1,9 @@
>  Name: test
>  Type: hash:net,port
>  Header: family inet hashsize 128 maxelem 65536 timeout x
> -Size in memory: 2072
> +Size in memory: 1024
>  References: 0
> +Number of Entries: 5
>  Members:
>  1.1.1.1,tcp:5 timeout x
>  192.168.68.64/27,tcp:8 timeout x
> diff --git a/tests/hash:net,port.t.list1 b/tests/hash:net,port.t.list1
> index 10031e4..d777e4f 100644
> --- a/tests/hash:net,port.t.list1
> +++ b/tests/hash:net,port.t.list1
> @@ -1,6 +1,7 @@
>  Name: test
>  Type: hash:net,port
>  Header: family inet hashsize 128 maxelem 65536 timeout 5
> -Size in memory: 2000
> +Size in memory: 1024
>  References: 0
> +Number of Entries: 4
>  Members:
> diff --git a/tests/hash:net.t.list0 b/tests/hash:net.t.list0
> index a71fa74..5060479 100644
> --- a/tests/hash:net.t.list0
> +++ b/tests/hash:net.t.list0
> @@ -1,8 +1,9 @@
>  Name: test
>  Type: hash:net
>  Header: family inet hashsize 128 maxelem 65536 timeout x
> -Size in memory: 1672
> +Size in memory: 896
>  References: 0
> +Number of Entries: 4
>  Members:
>  1.1.1.1 timeout x
>  192.168.68.64/27 timeout x
> diff --git a/tests/hash:net.t.list1 b/tests/hash:net.t.list1
> index 7ea6afc..9d4ed0f 100644
> --- a/tests/hash:net.t.list1
> +++ b/tests/hash:net.t.list1
> @@ -1,6 +1,7 @@
>  Name: test
>  Type: hash:net
>  Header: family inet hashsize 128 maxelem 65536 timeout 5
> -Size in memory: 1672
> +Size in memory: 895
>  References: 0
> +Number of Entries: 4
>  Members:
> diff --git a/tests/hash:net.t.list2 b/tests/hash:net.t.list2
> index bc81b5e..f064c43 100644
> --- a/tests/hash:net.t.list2
> +++ b/tests/hash:net.t.list2
> @@ -1,8 +1,9 @@
>  Name: test
>  Type: hash:net
>  Header: family inet hashsize 1024 maxelem 65536
> -Size in memory: 17016
> +Size in memory: 640
>  References: 0
> +Number of Entries: 4
>  Members:
>  10.2.0.0/24
>  10.2.1.0/29
> diff --git a/tests/hash:net6,net6.t.list0 b/tests/hash:net6,net6.t.list0
> index ea78bbb..6f04003 100644
> --- a/tests/hash:net6,net6.t.list0
> +++ b/tests/hash:net6,net6.t.list0
> @@ -1,8 +1,9 @@
>  Name: test
>  Type: hash:net,net
>  Header: family inet6 hashsize 128 maxelem 65536 timeout x
> -Size in memory: 4672
> +Size in memory: 3144
>  References: 0
> +Number of Entries: 4
>  Members:
>  192:160::/27,172:16:68::/48 timeout x
>  1:1:1::1,2:2:2::2 timeout x
> diff --git a/tests/hash:net6,net6.t.list1 b/tests/hash:net6,net6.t.list1
> index 0e1b7d2..9107e33 100644
> --- a/tests/hash:net6,net6.t.list1
> +++ b/tests/hash:net6,net6.t.list1
> @@ -1,6 +1,7 @@
>  Name: test
>  Type: hash:net,net
>  Header: family inet6 hashsize 128 maxelem 65536 timeout 5
> -Size in memory: 4672
> +Size in memory: 3144
>  References: 0
> +Number of Entries: 4
>  Members:
> diff --git a/tests/hash:net6,port,net6.t.list0 b/tests/hash:net6,port,net6.t.list0
> index 8a927ec..589c0b7 100644
> --- a/tests/hash:net6,port,net6.t.list0
> +++ b/tests/hash:net6,port,net6.t.list0
> @@ -1,8 +1,9 @@
>  Name: test
>  Type: hash:net,port,net
>  Header: family inet6 hashsize 1024 maxelem 65536
> -Size in memory: 18824
> +Size in memory: 2440
>  References: 0
> +Number of Entries: 4
>  Members:
>  2:1::,tcp:128,::/12
>  2:1::1,tcp:128,::/12
> diff --git a/tests/hash:net6,port.t.list0 b/tests/hash:net6,port.t.list0
> index f0a27b4..b66ad2c 100644
> --- a/tests/hash:net6,port.t.list0
> +++ b/tests/hash:net6,port.t.list0
> @@ -1,8 +1,9 @@
>  Name: test
>  Type: hash:net,port
>  Header: family inet6 hashsize 128 maxelem 65536 timeout x
> -Size in memory: 2328
> +Size in memory: 2352
>  References: 0
> +Number of Entries: 5
>  Members:
>  192:160::/27,ipv6-icmp:echo-request timeout x
>  192:168:68::95,ipv6-icmp:port-unreachable timeout x
> diff --git a/tests/hash:net6,port.t.list1 b/tests/hash:net6,port.t.list1
> index e5e90a4..5043e0a 100644
> --- a/tests/hash:net6,port.t.list1
> +++ b/tests/hash:net6,port.t.list1
> @@ -1,7 +1,8 @@
>  Name: test
>  Type: hash:net,port
>  Header: family inet6 hashsize 128 maxelem 65536 timeout 5
> -Size in memory: 2328
> +Size in memory: 2352
>  References: 0
> +Number of Entries: 5
>  Members:
>  1:1:1::1,tcp:8 timeout 0
> diff --git a/tests/hash:net6.t.list0 b/tests/hash:net6.t.list0
> index 52b0ce5..beae54b 100644
> --- a/tests/hash:net6.t.list0
> +++ b/tests/hash:net6.t.list0
> @@ -1,8 +1,9 @@
>  Name: test
>  Type: hash:net
>  Header: family inet6 hashsize 128 maxelem 65536 timeout x
> -Size in memory: 2696
> +Size in memory: 2112
>  References: 0
> +Number of Entries: 4
>  Members:
>  192:160::/27 timeout x
>  1:1:1::1 timeout x
> diff --git a/tests/hash:net6.t.list1 b/tests/hash:net6.t.list1
> index e92da52..cd3b3b3 100644
> --- a/tests/hash:net6.t.list1
> +++ b/tests/hash:net6.t.list1
> @@ -1,6 +1,7 @@
>  Name: test
>  Type: hash:net
>  Header: family inet6 hashsize 128 maxelem 65536 timeout 5
> -Size in memory: 2696
> +Size in memory: 2112
>  References: 0
> +Number of Entries: 4
>  Members:
> diff --git a/tests/iphash.t.list0 b/tests/iphash.t.list0
> index 2302485..a74d1e3 100644
> --- a/tests/iphash.t.list0
> +++ b/tests/iphash.t.list0
> @@ -1,8 +1,9 @@
>  Name: test
>  Type: hash:ip
>  Header: family inet hashsize 128 maxelem 65536
> -Size in memory: 1184
> +Size in memory: 224
>  References: 0
> +Number of Entries: 2
>  Members:
>  192.168.68.69
>  2.0.0.1
> diff --git a/tests/iphash.t.list1 b/tests/iphash.t.list1
> index ea5d2a1..fc470a5 100644
> --- a/tests/iphash.t.list1
> +++ b/tests/iphash.t.list1
> @@ -1,8 +1,9 @@
>  Name: test
>  Type: hash:ip
>  Header: family inet hashsize 128 maxelem 65536 netmask 24
> -Size in memory: 1184
> +Size in memory: 224
>  References: 0
> +Number of Entries: 2
>  Members:
>  192.168.68.0
>  2.0.0.0
> diff --git a/tests/ipmarkhash.t.list0 b/tests/ipmarkhash.t.list0
> index 1157c69..35caa4d 100644
> --- a/tests/ipmarkhash.t.list0
> +++ b/tests/ipmarkhash.t.list0
> @@ -1,8 +1,9 @@
>  Name: test
>  Type: hash:ip,mark
>  Header: family inet markmask 0xffffffff hashsize 1024 maxelem 65536
> -Size in memory: 8516
> +Size in memory: 384
>  References: 0
> +Number of Entries: 4
>  Members:
>  2.0.0.0,0x00000005
>  2.0.0.1,0x00000005
> diff --git a/tests/ipmarkhash.t.list1 b/tests/ipmarkhash.t.list1
> index 5455be9..5cc4935 100644
> --- a/tests/ipmarkhash.t.list1
> +++ b/tests/ipmarkhash.t.list1
> @@ -1,8 +1,9 @@
>  Name: test
>  Type: hash:ip,mark
>  Header: family inet markmask 0xffffffff hashsize 1024 maxelem 65536
> -Size in memory: 8468
> +Size in memory: 384
>  References: 0
> +Number of Entries: 4
>  Members:
>  1.255.255.255,0x00000005
>  2.0.0.0,0x00000005
> diff --git a/tests/ipporthash.t.list0 b/tests/ipporthash.t.list0
> index 20c805d..9d33a41 100644
> --- a/tests/ipporthash.t.list0
> +++ b/tests/ipporthash.t.list0
> @@ -1,8 +1,9 @@
>  Name: test
>  Type: hash:ip,port
>  Header: family inet hashsize 1024 maxelem 65536
> -Size in memory: 8464
> +Size in memory: 384
>  References: 0
> +Number of Entries: 4
>  Members:
>  2.0.0.0,tcp:5
>  2.0.0.1,tcp:5
> diff --git a/tests/ipporthash.t.list1 b/tests/ipporthash.t.list1
> index 0834a00..709dcf7 100644
> --- a/tests/ipporthash.t.list1
> +++ b/tests/ipporthash.t.list1
> @@ -1,8 +1,9 @@
>  Name: test
>  Type: hash:ip,port
>  Header: family inet hashsize 1024 maxelem 65536
> -Size in memory: 8464
> +Size in memory: 384
>  References: 0
> +Number of Entries: 4
>  Members:
>  1.255.255.255,tcp:5
>  2.0.0.0,tcp:5
> diff --git a/tests/ipportiphash.t.list0 b/tests/ipportiphash.t.list0
> index fc881ad..3e4dc05 100644
> --- a/tests/ipportiphash.t.list0
> +++ b/tests/ipportiphash.t.list0
> @@ -1,8 +1,9 @@
>  Name: test
>  Type: hash:ip,port,ip
>  Header: family inet hashsize 1024 maxelem 65536
> -Size in memory: 8528
> +Size in memory: 456
>  References: 0
> +Number of Entries: 4
>  Members:
>  2.0.0.0,tcp:5,1.1.1.1
>  2.0.0.1,tcp:5,1.1.1.1
> diff --git a/tests/ipportiphash.t.list1 b/tests/ipportiphash.t.list1
> index 9a7d1f0..343d397 100644
> --- a/tests/ipportiphash.t.list1
> +++ b/tests/ipportiphash.t.list1
> @@ -1,8 +1,9 @@
>  Name: test
>  Type: hash:ip,port,ip
>  Header: family inet hashsize 1024 maxelem 65536
> -Size in memory: 8416
> +Size in memory: 296
>  References: 0
> +Number of Entries: 2
>  Members:
>  2.0.0.0,tcp:5,1.1.1.1
>  2.0.255.255,tcp:128,2.2.2.2
> diff --git a/tests/iptables.sh b/tests/iptables.sh
> index 7ea90e0..7273066 100755
> --- a/tests/iptables.sh
> +++ b/tests/iptables.sh
> @@ -1,6 +1,6 @@
>  #!/bin/sh
>  
> -# set -x
> +set -x
>  set -e
>  
>  ipset=${IPSET_BIN:-../src/ipset}
> diff --git a/tests/nethash.t.list0 b/tests/nethash.t.list0
> index 1a157e9..2e7695d 100644
> --- a/tests/nethash.t.list0
> +++ b/tests/nethash.t.list0
> @@ -1,8 +1,9 @@
>  Name: test
>  Type: hash:net
>  Header: family inet hashsize 128 maxelem 65536
> -Size in memory: 1544
> +Size in memory: 640
>  References: 0
> +Number of Entries: 4
>  Members:
>  1.1.1.1
>  192.168.68.64/27
> diff --git a/tests/resizet.sh b/tests/resizet.sh
> index 7dc309f..eed4abf 100755
> --- a/tests/resizet.sh
> +++ b/tests/resizet.sh
> @@ -1,6 +1,6 @@
>  #!/bin/sh
>  
> -# set -x
> +#set -x
>  set -e
>  
>  ipset=${IPSET_BIN:-../src/ipset}
> diff --git a/tests/restore.t.list0 b/tests/restore.t.list0
> index 65aa8b8..21387ba 100644
> --- a/tests/restore.t.list0
> +++ b/tests/restore.t.list0
> @@ -1,8 +1,9 @@
>  Name: a
>  Type: hash:ip
>  Header: family inet6 hashsize 1024 maxelem 65536
> -Size in memory: 16704
> +Size in memory: 416
>  References: 0
> +Number of Entries: 3
>  Members:
>  3::3
>  4::4
> diff --git a/tests/restore.t.list1 b/tests/restore.t.list1
> index 0602ab6..cdf9a02 100644
> --- a/tests/restore.t.list1
> +++ b/tests/restore.t.list1
> @@ -1,8 +1,9 @@
>  Name: b
>  Type: hash:ip
>  Header: family inet6 hashsize 1024 maxelem 65536
> -Size in memory: 16704
> +Size in memory: 416
>  References: 0
> +Number of Entries: 3
>  Members:
>  1::1
>  2::2
> diff --git a/tests/setlist.t.list4 b/tests/setlist.t.list4
> index bce5824..ef17470 100644
> --- a/tests/setlist.t.list4
> +++ b/tests/setlist.t.list4
> @@ -1,29 +1,33 @@
>  Name: a
>  Type: hash:ip
>  Header: family inet hashsize 1024 maxelem 65536
> -Size in memory: 16504
> +Size in memory: 128
>  References: 1
> +Number of Entries: 0
>  Members:
>  
>  Name: b
>  Type: hash:ip
>  Header: family inet hashsize 1024 maxelem 65536
> -Size in memory: 16504
> +Size in memory: 128
>  References: 0
> +Number of Entries: 0
>  Members:
>  
>  Name: c
>  Type: hash:ip
>  Header: family inet hashsize 1024 maxelem 65536
> -Size in memory: 16504
> +Size in memory: 128
>  References: 0
> +Number of Entries: 0
>  Members:
>  
>  Name: d
>  Type: hash:ip
>  Header: family inet hashsize 1024 maxelem 65536
> -Size in memory: 16504
> +Size in memory: 128
>  References: 0
> +Number of Entries: 0
>  Members:
>  
>  Name: test
> diff --git a/tests/sort.sh b/tests/sort.sh
> index 69aebd5..c5edad1 100755
> --- a/tests/sort.sh
> +++ b/tests/sort.sh
> @@ -1,5 +1,5 @@
>  #!/bin/sh
>  
> -head -n 6 $1 > .foo
> -tail -n +7 $1 | grep  '[[:alnum:]]' | sort >> .foo
> +head -n 7 $1 > .foo
> +tail -n +8 $1 | grep  '[[:alnum:]]' | sort >> .foo
>  rm $1
> -- 
> 1.9.1
> 

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary

