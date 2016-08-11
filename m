From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2, libnftnl] tests: Consolidate printing error utilities
Date: Fri, 12 Aug 2016 01:26:23 +0200
Message-ID: <20160811232623.GA5108@salvia>
References: <20160811132507.17842-1-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50506 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741AbcHKX0c (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Aug 2016 19:26:32 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 42CBC1878BB
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2016 01:26:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 3335FDA7FC
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2016 01:26:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 3690EFF153
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2016 01:26:28 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160811132507.17842-1-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Aug 11, 2016 at 03:25:06PM +0200, Carlos Falgueras García wrote:
> Created libtest.[hc] in order to consolidate code that is repeated in all
> tests.

Please, use present tense, eg.

This patch adds libtest.c and libtest.h to reduce test code and
consolidate it.

> diff --git a/tests/libtest.c b/tests/libtest.c
> new file mode 100644
> index 0000000..91f2d5e
> --- /dev/null
> +++ b/tests/libtest.c
> @@ -0,0 +1,49 @@
> +#include <libtest.h>
> +
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <stdarg.h>
> +#include <string.h>
> +#include <errno.h>
> +#include <stdbool.h>
> +
> +#define COLOR_RED     "\x1b[31m"
> +#define COLOR_GREEN   "\x1b[32m"
> +#define COLOR_RESET   "\x1b[0m"
> +
> +static bool test_ok = true;

I don't like this internal test_ok.

> +void __oom(const char *prog, const char *file, int line)
> +{
> +	fprintf(stderr,
> +		COLOR_RED "OOM" COLOR_RESET " at %s:%d\n\t%s\n", file, line,
> +		strerror(errno));
> +
> +	test_ok = false;
> +	test_exit(prog);
> +	exit(EXIT_FAILURE);
> +}
> +
> +void print_err(const char *fmt, ...)
> +{
> +	va_list args;
> +
> +	fprintf(stderr, COLOR_RED "ERROR: " COLOR_RESET);
> +	va_start(args, fmt);
> +	vfprintf(stderr, fmt, args);
> +	va_end(args);
> +	fprintf(stderr, "\n");
> +
> +	test_ok = false;
> +}
> +
> +int test_exit(const char *prog)
> +{
> +	if (test_ok) {
> +		printf("%s: " COLOR_GREEN "OK\n" COLOR_RESET, prog);
> +		return EXIT_SUCCESS;
> +	} else {
> +		printf("%s: " COLOR_RED "FAIL\n" COLOR_RESET, prog);
> +		return EXIT_FAILURE;
> +	}

Looks better like this?

	switch (test_ok) {
        case true:
		printf("%s: " COLOR_GREEN "OK\n" COLOR_RESET, prog);
		return EXIT_SUCCESS;
        case false:
        	printf("%s: " COLOR_RED "FAIL\n" COLOR_RESET, prog);
               	return EXIT_FAILURE;
        }

> +}
> diff --git a/tests/libtest.h b/tests/libtest.h
> new file mode 100644
> index 0000000..810bd82
> --- /dev/null
> +++ b/tests/libtest.h
> @@ -0,0 +1,9 @@
> +#ifndef _TESTS_UTILS_H
> +#define _TESTS_UTILS_H
> +
> +#define oom(prog) __oom(prog, __FILE__, __LINE__)
> +void __oom(const char *prog, const char *file, int line);
> +void print_err(const char *fmt, ...);
> +int test_exit(const char *prog);
> +
> +#endif
> diff --git a/tests/nft-chain-test.c b/tests/nft-chain-test.c
> index d678d46..82431c2 100644
> --- a/tests/nft-chain-test.c
> +++ b/tests/nft-chain-test.c
> @@ -15,13 +15,7 @@
>  #include <linux/netfilter/nf_tables.h>
>  #include <libnftnl/chain.h>
>  
> -static int test_ok = 1;
> -
> -static void print_err(const char *msg)
> -{
> -	test_ok = 0;
> -	printf("\033[31mERROR:\e[0m %s\n", msg);
> -}
> +#include <libtest.h>

Please, use:

#include "libtest.h" instead, I prefer it so we know this is locally
declare it.

>  static void cmp_nftnl_chain(struct nftnl_chain *a, struct nftnl_chain *b)
>  {
> @@ -73,7 +67,7 @@ int main(int argc, char *argv[])
>  	a = nftnl_chain_alloc();
>  	b = nftnl_chain_alloc();
>  	if (a == NULL || b == NULL)
> -		print_err("OOM");
> +		oom(argv[0]);

You can replace this above by:

        test_assert(a != NULL);
        test_assert(b != NULL);

>  	nftnl_chain_set_str(a, NFTNL_CHAIN_NAME, "test");
>  	nftnl_chain_set_u32(a, NFTNL_CHAIN_FAMILY, AF_INET);
> @@ -101,10 +95,6 @@ int main(int argc, char *argv[])
>  	nftnl_chain_free(a);
>  	nftnl_chain_free(b);
>  
> -	if (!test_ok)
> -		exit(EXIT_FAILURE);
> -
> -	printf("%s: \033[32mOK\e[0m\n", argv[0]);
> -	return EXIT_SUCCESS;
> +	return test_exit(argv[0]);

Better name, instead of test_exit:

        return test_report(argv[0]);
