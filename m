From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH] tests: tests for libnftables
Date: Sun, 10 Nov 2013 20:59:34 +0100
Message-ID: <CAOkSjBhPGXoZcGeLbnkEhT5qAJ3QJktodH6MSPczqgftiRahWA@mail.gmail.com>
References: <1384105067-6745-1-git-send-email-anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:44882 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab3KJT75 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 10 Nov 2013 14:59:57 -0500
Received: by mail-la0-f42.google.com with SMTP id ec20so935420lab.29
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Nov 2013 11:59:55 -0800 (PST)
In-Reply-To: <1384105067-6745-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 10 November 2013 18:37, Ana Rey <anarey@gmail.com> wrote:

Hi Ana, What a nice work. Two small comments below.

> diff --git a/tests/nft-table-test.c b/tests/nft-table-test.c
> new file mode 100644
> index 0000000..ae7e2ac
> --- /dev/null
> +++ b/tests/nft-table-test.c
> @@ -0,0 +1,62 @@
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <netinet/in.h>
> +
> +#include <linux/netfilter/nf_tables.h>
> +#include <libnftables/table.h>
> +
> +static void die(const char *msg)
> +{
> +       printf("\033[31mERROR:\e[0m %s\n", msg);
> +       exit(EXIT_FAILURE);
> +}
> +
> +static void cmp_nft_table(struct nft_table *a, struct nft_table *b)
> +{
> +       if (strcmp(nft_table_attr_get_str(a, NFT_TABLE_ATTR_NAME),
> +                  nft_table_attr_get_str(b, NFT_TABLE_ATTR_NAME)) !=3D=
 0)
> +               die("table name mismatches");
> +       if (nft_table_attr_get_u32(a, NFT_TABLE_ATTR_FLAGS) !=3D
> +           nft_table_attr_get_u32(b, NFT_TABLE_ATTR_FLAGS))
> +               die("table flags mismatches");
> +               /*TODO nft_table_attr_get_u8
> +                * nft_table_atrr_set
> +                * ## NFT_TABLE_ATTR_FAMILY is uint8_t */

I think multiline comment format is:
/* xxx
 * xxx
 */

> diff --git a/tests/test-script.sh b/tests/test-script.sh
> new file mode 100755
> index 0000000..5c475d5
> --- /dev/null
> +++ b/tests/test-script.sh
> @@ -0,0 +1,20 @@
> +./nft-chain-test
> +./nft-expr_bitwise-test
> +./nft-expr_byteorder-test
> +./nft-expr_cmp-test
> +./nft-expr_counter-test
> +./nft-expr_ct-test
> +./nft-expr_exthdr-test
> +./nft-expr_immediate-test
> +./nft-expr_limit-test
> +./nft-expr_log-test
> +./nft-expr_lookup-test
> +./nft-expr_match-test
> +./nft-expr_meta-test
> +./nft-expr_nat-test
> +./nft-expr_payload-test
> +./nft-expr_target-test
> +./nft-rule-test
> +./nft-ruleset-test

I think the file 'nft-ruleset-test' is not included in this patch.

Also, new files doesn't seem to include a copyrigth notice. @pablo, I
don't know if those tests files should have one in place.

Thanks for your work. Best regards.

--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
