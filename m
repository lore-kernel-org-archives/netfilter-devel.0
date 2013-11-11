From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH v2] tests: tests for libnftables
Date: Mon, 11 Nov 2013 20:39:32 +0100
Message-ID: <CAOkSjBgWRHYLtrbBtnydoXddotsGo0QptE3_-SxHa0LXMjZOYg@mail.gmail.com>
References: <1384191143-6447-1-git-send-email-anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>, kernel@linuxace.com
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:34461 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502Ab3KKTjy convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Nov 2013 14:39:54 -0500
Received: by mail-la0-f41.google.com with SMTP id hp15so307731lab.0
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Nov 2013 11:39:52 -0800 (PST)
In-Reply-To: <1384191143-6447-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 11 November 2013 18:32, Ana Rey <anarey@gmail.com> wrote:
> Makefile and tests files for libnftables.
>
> In this patch, I create a initial object 'a' and I set a testing valu=
es. Then,
> I convert this object in a Netlink message.
>
> From this Netlink message, I parse that (through nft_table_nlmsg_pars=
e
> function) in 'b' objetc.
>
> Thus, we make sure that object transformations are correct.
> ---
> v2: fix writing erorres in messages that I unintentionally added in v=
1 that
> were spotted by Phil Oester.
>
> Fix a multiline comment error. The nft-ruleset-test is not included
> in this patch, also, I delete it in the tests/test-script.sh. Those e=
rrors were
> spotted by Arturo Borrero.
>

Hi Ana, thanks for the update.

I've been testing your patch. Some comments below.

> diff --git a/tests/nft-expr_bitwise-test.c b/tests/nft-expr_bitwise-t=
est.c
> new file mode 100644
> index 0000000..46823d8
> --- /dev/null
> +++ b/tests/nft-expr_bitwise-test.c
> @@ -0,0 +1,104 @@
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +
> +#include <netinet/in.h>
> +#include <netinet/ip.h>
> +#include <linux/netfilter/nf_tables.h>
> +#include <libmnl/libmnl.h>
> +#include <libnftables/rule.h>
> +#include <libnftables/expr.h>
> +
> +static void die(const char *msg)
> +{
> +       printf("\033[31mERROR:\e[0m %s\n", msg);
> +       exit(EXIT_FAILURE);
> +}
> +
> +static void cmp_nft_rule_expr(struct nft_rule_expr *rule_a,
> +                             struct nft_rule_expr *rule_b)
> +{
> +       uint32_t maska =3D NULL;
> +       uint32_t maskb =3D NULL;
> +       uint32_t xora =3D NULL;
> +       uint32_t xorb =3D NULL;

I think those initialization are unnecessary. Also, my compiler says:

nft-expr_bitwise-test.c: In function =91cmp_nft_rule_expr=92:
nft-expr_bitwise-test.c:21:19: warning: initialization makes integer
from pointer without a cast [enabled by default]
nft-expr_bitwise-test.c:22:19: warning: initialization makes integer
from pointer without a cast [enabled by default]
nft-expr_bitwise-test.c:23:18: warning: initialization makes integer
from pointer without a cast [enabled by default]
nft-expr_bitwise-test.c:24:18: warning: initialization makes integer
from pointer without a cast [enabled by default]

Same in nft-expr_cmp-test.c

> diff --git a/tests/nft-expr_match-test.c b/tests/nft-expr_match-test.=
c
> new file mode 100644
> index 0000000..9a8b634
> --- /dev/null
> +++ b/tests/nft-expr_match-test.c
> @@ -0,0 +1,105 @@
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +
> +#include <arpa/inet.h>
> +#include <netinet/in.h>
> +#include <netinet/ip.h>
> +#include <linux/netfilter/nf_tables.h>
> +#include <linux/netfilter/xt_iprange.h>
> +#include <linux/netfilter_ipv4/ipt_LOG.h>

In file included from nft-expr_match-test.c:10:0:
/usr/include/linux/netfilter_ipv4/ipt_LOG.h:4:2: warning: #warning
"Please update iptables, this file will be removed soon!" [-Wcpp]

Should we ignore this warning?

Also found in nft-expr_target-test.c

> diff --git a/tests/nft-expr_target-test.c b/tests/nft-expr_target-tes=
t.c
> new file mode 100644
> index 0000000..756ab2d
> --- /dev/null
> +++ b/tests/nft-expr_target-test.c
> @@ -0,0 +1,112 @@
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +
> +#include <netinet/in.h>
> +#include <netinet/ip.h>
> +#include <linux/netfilter/nf_tables.h>
> +#include <linux/netfilter/xt_iprange.h>
> +#include <linux/netfilter_ipv4/ipt_LOG.h>
> +#include <libmnl/libmnl.h>
> +#include <libnftables/rule.h>
> +#include <libnftables/expr.h>
> +
> +static void die(const char *msg)
> +{
> +       printf("\033[31mERROR:\e[0m %s\n", msg);
> +       exit(EXIT_FAILURE);
> +}
> +
> +static void die2(const char *msg, uint32_t a, uint32_t b)
> +{
> +       printf("\033[31mERROR:\e[0m %s size a: %d b: %d \n",msg, a, b=
);
> +       exit(EXIT_FAILURE);
> +}
> +
> +static void cmp_nft_rule_expr(struct nft_rule_expr *rule_a,
> +                             struct nft_rule_expr *rule_b)
> +{
> +       uint32_t lena, lenb;
> +
> +       if (strcmp(nft_rule_expr_get_str(rule_a, NFT_EXPR_TG_NAME),
> +                  nft_rule_expr_get_str(rule_b, NFT_EXPR_TG_NAME)) !=
=3D 0)
> +               die("Expr TG_NAME mismatches");
> +
> +       if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_TG_REV) !=3D
> +           nft_rule_expr_get_u32(rule_b, NFT_EXPR_TG_REV))
> +               die("Expr TG_REV mismatches");
> +
> +       nft_rule_expr_get(rule_a, NFT_EXPR_TG_INFO, &lena);
> +       nft_rule_expr_get(rule_b, NFT_EXPR_TG_INFO, &lenb);
> +
> +       /* TODO =BFBUG? */
> +       if (lena !=3D lenb)
> +               die2("Expr TG_DATA size mismatches", lena, lenb);
> +}
> +

When I run the test:

root@debian:/home/aborrero/git/libnftables/tests# ./test-script.sh
/home/aborrero/git/libnftables/tests/.libs/lt-nft-chain-test: OK
/home/aborrero/git/libnftables/tests/.libs/lt-nft-expr_bitwise-test: OK
/home/aborrero/git/libnftables/tests/.libs/lt-nft-expr_byteorder-test: =
OK
/home/aborrero/git/libnftables/tests/.libs/lt-nft-expr_cmp-test: OK
/home/aborrero/git/libnftables/tests/.libs/lt-nft-expr_counter-test: OK
/home/aborrero/git/libnftables/tests/.libs/lt-nft-expr_ct-test: OK
/home/aborrero/git/libnftables/tests/.libs/lt-nft-expr_exthdr-test: OK
/home/aborrero/git/libnftables/tests/.libs/lt-nft-expr_immediate-test: =
OK
/home/aborrero/git/libnftables/tests/.libs/lt-nft-expr_limit-test: OK
/home/aborrero/git/libnftables/tests/.libs/lt-nft-expr_log-test: OK
/home/aborrero/git/libnftables/tests/.libs/lt-nft-expr_lookup-test: OK
/home/aborrero/git/libnftables/tests/.libs/lt-nft-expr_match-test: OK
/home/aborrero/git/libnftables/tests/.libs/lt-nft-expr_meta-test: OK
/home/aborrero/git/libnftables/tests/.libs/lt-nft-expr_nat-test: OK
/home/aborrero/git/libnftables/tests/.libs/lt-nft-expr_payload-test: OK
ERROR: Expr TG_DATA size mismatches size a: 32 b: 36
/home/aborrero/git/libnftables/tests/.libs/lt-nft-rule-test: OK
/home/aborrero/git/libnftables/tests/.libs/lt-nft-set-test: OK
/home/aborrero/git/libnftables/tests/.libs/lt-nft-table-test: OK

I guess the error above is the bug you spotted.

> +int main(int argc, char *argv[])
> +{
> +       struct nft_rule *a, *b;
> +       struct nft_rule_expr *ex;
> +       struct nlmsghdr *nlh;
> +       struct ipt_log_info *info;
> +       char buf[4096];
> +       struct nft_rule_expr_iter *iter_a, *iter_b;
> +       struct nft_rule_expr *rule_a, *rule_b;
> +
> +       a =3D nft_rule_alloc();
> +       b =3D nft_rule_alloc();
> +       if (a =3D=3D NULL || b =3D=3D NULL)
> +               die("OOM");
> +
> +       ex =3D nft_rule_expr_alloc("target");
> +       if (ex =3D=3D NULL)
> +               die("OOM");
> +       nft_rule_expr_set(ex, NFT_EXPR_TG_NAME, "LOG", strlen("LOG"))=
;
> +       nft_rule_expr_set_u32(ex, NFT_EXPR_TG_REV, 0x12345678);
> +
> +       info =3D calloc(1, sizeof(struct ipt_log_info));
> +       if (info =3D=3D NULL)
> +               die("OOM");
> +       sprintf(info->prefix, "test: ");
> +       info->prefix[sizeof(info->prefix)-1] =3D '\0';
> +       info->logflags =3D 0x0f;
> +       info->level =3D 5;
> +       nft_rule_expr_set(ex, NFT_EXPR_TG_INFO, info, sizeof(*info));
> +
> +       nft_rule_add_expr(a, ex);
> +
> +       nlh =3D nft_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INE=
T, 0, 1234);
> +       nft_rule_nlmsg_build_payload(nlh, a);
> +
> +       if (nft_rule_nlmsg_parse(nlh, b) < 0)
> +               die("parsing problems");
> +
> +       iter_a =3D nft_rule_expr_iter_create(a);
> +       iter_b =3D nft_rule_expr_iter_create(b);
> +       if (iter_a =3D=3D NULL || iter_b =3D=3D NULL)
> +               die("OOM");
> +
> +       rule_a =3D nft_rule_expr_iter_next(iter_a);
> +       rule_b =3D nft_rule_expr_iter_next(iter_b);
> +       if (rule_a =3D=3D NULL || rule_b =3D=3D NULL)
> +               die("OOM");
> +
> +       cmp_nft_rule_expr(rule_a, rule_b);
> +
> +       if (nft_rule_expr_iter_next(iter_a) !=3D NULL ||
> +           nft_rule_expr_iter_next(iter_b) !=3D NULL)
> +               die("More 1 expr.");
> +
> +       nft_rule_expr_iter_destroy(iter_a);
> +       nft_rule_expr_iter_destroy(iter_b);
> +       nft_rule_free(a);
> +       nft_rule_free(b);
> +       /* BUG: leak memory
> +          =3D=3D28351=3D=3D HEAP SUMMARY:
> +        * =3D=3D28351=3D=3D     in use at exit: 436 bytes in 8 block=
s
> +        * =3D=3D28351=3D=3D   total heap usage: 8 allocs, 0 frees, 4=
36 bytes allocated
> +       */

Do you think the leak is in nft_rule_expr_iter_destroy()?

=3D=3D1860=3D=3D 16 bytes in 1 blocks are definitely lost in loss recor=
d 2 of 8
=3D=3D1860=3D=3D    at 0x4C272B8: calloc (vg_replace_malloc.c:566)
=3D=3D1860=3D=3D    by 0x4E388D2: nft_rule_expr_iter_create (rule.c:860=
)
=3D=3D1860=3D=3D    by 0x400D6F: main (nft-expr_target-test.c:85)

Also, I think the comment itself is not in good format (sorry for
being repetitive).

Regards
--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
