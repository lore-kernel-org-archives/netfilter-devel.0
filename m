From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2, libnftnl] Use libnftnl comparators in all tests
Date: Fri, 12 Aug 2016 01:32:22 +0200
Message-ID: <20160811233222.GB5108@salvia>
References: <20160811132507.17842-1-carlosfg@riseup.net>
 <20160811132507.17842-2-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51102 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676AbcHKXc2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Aug 2016 19:32:28 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 38F981878BE
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2016 01:32:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 28B9DFF154
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2016 01:32:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id DD318FF153
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2016 01:32:23 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160811132507.17842-2-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Aug 11, 2016 at 03:25:07PM +0200, Carlos Falgueras García wrote:
> Use 'nftnl_expr_cmp' and 'nftnl_rule_cmp' in all tests instead of custom
> comparator for each one. If objects differ both are printed.
> 
> Signed-off-by: Carlos Falgueras García <carlosfg@riseup.net>
> ---
>  tests/libtest.c                 | 22 +++++++++++++++++++++
>  tests/libtest.h                 |  9 +++++++++
>  tests/nft-expr_bitwise-test.c   | 29 +++------------------------
>  tests/nft-expr_byteorder-test.c | 24 +++-------------------
>  tests/nft-expr_cmp-test.c       | 21 +++-----------------
>  tests/nft-expr_counter-test.c   | 15 +++-----------
>  tests/nft-expr_ct-test.c        | 17 +++-------------
>  tests/nft-expr_dup-test.c       | 15 +++-----------
>  tests/nft-expr_exthdr-test.c    | 21 +++-----------------
>  tests/nft-expr_fwd-test.c       | 12 +++--------
>  tests/nft-expr_immediate-test.c | 44 ++++++-----------------------------------
>  tests/nft-expr_limit-test.c     | 24 +++-------------------
>  tests/nft-expr_log-test.c       | 21 +++-----------------
>  tests/nft-expr_lookup-test.c    | 27 +++----------------------
>  tests/nft-expr_masq-test.c      | 18 +++--------------
>  tests/nft-expr_match-test.c     | 22 +++------------------
>  tests/nft-expr_meta-test.c      | 15 +++-----------
>  tests/nft-expr_nat-test.c       | 30 +++-------------------------
>  tests/nft-expr_payload-test.c   | 21 +++-----------------
>  tests/nft-expr_queue-test.c     | 15 +++-----------
>  tests/nft-expr_redir-test.c     | 18 +++--------------
>  tests/nft-expr_reject-test.c    | 15 +++-----------
>  tests/nft-expr_target-test.c    | 22 +++------------------
>  tests/nft-rule-test.c           | 38 +++--------------------------------
>  24 files changed, 100 insertions(+), 415 deletions(-)
> 
> diff --git a/tests/libtest.c b/tests/libtest.c
> index 91f2d5e..9ce38ff 100644
> --- a/tests/libtest.c
> +++ b/tests/libtest.c
> @@ -11,6 +11,8 @@
>  #define COLOR_GREEN   "\x1b[32m"
>  #define COLOR_RESET   "\x1b[0m"
>  
> +#define SNPRINTF_BUFF_LEN 1024
> +
>  static bool test_ok = true;
>  
>  void __oom(const char *prog, const char *file, int line)
> @@ -47,3 +49,23 @@ int test_exit(const char *prog)
>  		return EXIT_FAILURE;
>  	}
>  }

Better place the definition here, close to where it is used and
meaningful.

> +const char *rule2str(const struct nftnl_rule *r)
> +{
> +	static char buff[SNPRINTF_BUFF_LEN];
> +
> +	nftnl_rule_snprintf(buff, SNPRINTF_BUFF_LEN, r,
> +			    NFTNL_OUTPUT_DEFAULT, 0);

This fits into one line:

	nftnl_rule_snprintf(buf, sizeof(buf), r, NFTNL_OUTPUT_DEFAULT, 0);

> +
> +	return buff;
> +}
> +
> +const char *expr2str(const struct nftnl_expr *e)
> +{
> +	static char buff[SNPRINTF_BUFF_LEN];
> +
> +	nftnl_expr_snprintf(buff, SNPRINTF_BUFF_LEN, e,
> +			    NFTNL_OUTPUT_DEFAULT, 0);
> +
> +	return buff;
> +}
> diff --git a/tests/libtest.h b/tests/libtest.h
> index 810bd82..af469ce 100644
> --- a/tests/libtest.h
> +++ b/tests/libtest.h
> @@ -1,9 +1,18 @@
>  #ifndef _TESTS_UTILS_H
>  #define _TESTS_UTILS_H
>  
> +#include <stdbool.h>
> +#include <libmnl/libmnl.h>
> +#include <libnftnl/common.h>
> +#include <libnftnl/rule.h>
> +#include <libnftnl/expr.h>
> +
>  #define oom(prog) __oom(prog, __FILE__, __LINE__)
>  void __oom(const char *prog, const char *file, int line);
>  void print_err(const char *fmt, ...);
>  int test_exit(const char *prog);
>  
> +const char *rule2str(const struct nftnl_rule *r);
> +const char *expr2str(const struct nftnl_expr *e);
> +
>  #endif
> diff --git a/tests/nft-expr_bitwise-test.c b/tests/nft-expr_bitwise-test.c
> index bf76cb2..a661be6 100644
> --- a/tests/nft-expr_bitwise-test.c
> +++ b/tests/nft-expr_bitwise-test.c
> @@ -21,31 +21,6 @@
>  
>  #include <libtest.h>
>  
> -static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
> -			      struct nftnl_expr *rule_b)
> -{
> -	uint32_t maska, maskb;
> -	uint32_t xora, xorb;
> -
> -	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_BITWISE_DREG) !=
> -	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_BITWISE_DREG))
> -		print_err("Expr BITWISE_DREG mismatches");
> -	if (nftnl_expr_get_u32(rule_a, NFTNL_EXPR_BITWISE_SREG) !=
> -	    nftnl_expr_get_u32(rule_b, NFTNL_EXPR_BITWISE_SREG))
> -		print_err("Expr BITWISE_SREG mismatches");
> -	if (nftnl_expr_get_u16(rule_a, NFTNL_EXPR_BITWISE_LEN) !=
> -	    nftnl_expr_get_u16(rule_b, NFTNL_EXPR_BITWISE_LEN))
> -		print_err("Expr BITWISE_DREG mismatches");
> -	nftnl_expr_get(rule_a, NFTNL_EXPR_BITWISE_MASK, &maska);
> -	nftnl_expr_get(rule_b, NFTNL_EXPR_BITWISE_MASK, &maskb);
> -	if (maska != maskb)
> -		print_err("Size of BITWISE_MASK mismatches");
> -	nftnl_expr_get(rule_a, NFTNL_EXPR_BITWISE_XOR, &xora);
> -	nftnl_expr_get(rule_b, NFTNL_EXPR_BITWISE_XOR, &xorb);
> -	if (xora != xorb)
> -		print_err("Size of BITWISE_XOR mismatches");
> -
> -}
>  int main(int argc, char *argv[])
>  {
>  	struct nftnl_rule *a, *b = NULL;
> @@ -96,7 +71,9 @@ int main(int argc, char *argv[])
>  	nftnl_expr_iter_destroy(iter_a);
>  	nftnl_expr_iter_destroy(iter_b);
>  
> -	cmp_nftnl_expr(rule_a,rule_b);
> +	if (!nftnl_expr_cmp(rule_a, rule_b))
> +		print_err("expressions mismatches:\n\texpr 1: %s\n\texpr 2: %s",
> +			  expr2str(rule_a), expr2str(rule_b));

Better, add something like

                print_expr_mismatch(rule_a, rule_b);

This should be "expressions mismatch" instead of "expressions
mismatches".
