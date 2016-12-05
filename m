From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] parser: Add glob support to include directive
Date: Mon, 5 Dec 2016 23:26:51 +0100
Message-ID: <20161205222651.GA14648@salvia>
References: <CAAVa8iscQtgaXbauR6MJ_iwU+YZuXpzaFCBM+4QR3676XHx5KQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Kohei Suzuki <eagletmt@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52560 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752626AbcLEW1C (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Dec 2016 17:27:02 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CF95E174D14
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Dec 2016 23:26:59 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C036CDA843
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Dec 2016 23:26:59 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 91308DA862
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Dec 2016 23:26:56 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CAAVa8iscQtgaXbauR6MJ_iwU+YZuXpzaFCBM+4QR3676XHx5KQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Please, add a description to this patch.

Thanks.

On Mon, Dec 05, 2016 at 08:58:38PM +0900, Kohei Suzuki wrote:
> ---
>  src/scanner.l                                 | 36 +++++++++++++++++----------
>  tests/shell/testcases/include/0005glob_0      | 32 ++++++++++++++++++++++++
>  tests/shell/testcases/include/0006globempty_1 | 14 +++++++++++
>  3 files changed, 69 insertions(+), 13 deletions(-)
>  create mode 100755 tests/shell/testcases/include/0005glob_0
>  create mode 100755 tests/shell/testcases/include/0006globempty_1
> 
> diff --git a/src/scanner.l b/src/scanner.l
> index 625023f..64fe6fc 100644
> --- a/src/scanner.l
> +++ b/src/scanner.l
> @@ -11,6 +11,7 @@
>  %{
> 
>  #include <limits.h>
> +#include <glob.h>
>  #include <netinet/in.h>
>  #include <arpa/inet.h>
>  #include <linux/types.h>
> @@ -640,37 +641,46 @@ int scanner_include_file(void *scanner, const
> char *filename,
>      struct parser_state *state = yyget_extra(scanner);
>      struct error_record *erec;
>      char buf[PATH_MAX];
> -    const char *name = buf;
>      unsigned int i;
> -    FILE *f;
> +    glob_t globbuf;
> 
> -    f = NULL;
> +    globbuf.gl_pathc = 0;
>      if (search_in_include_path(filename)) {
>          for (i = 0; i < INCLUDE_PATHS_MAX; i++) {
>              if (include_paths[i] == NULL)
>                  break;
>              snprintf(buf, sizeof(buf), "%s/%s",
>                   include_paths[i], filename);
> -            f = fopen(buf, "r");
> -            if (f != NULL)
> +            if (glob(buf, 0, NULL, &globbuf) != 0) {
>                  break;
> +            }
>          }
>      } else {
> -        f = fopen(filename, "r");
> -        name = filename;
> +        glob(filename, 0, NULL, &globbuf);
>      }
> -    if (f == NULL) {
> -        erec = error(loc, "Could not open file \"%s\": %s",
> -                 filename, strerror(errno));
> +    if (globbuf.gl_pathc == 0) {
> +        erec = error(loc, "Could not find file matching \"%s\"\n", filename);
>          goto err;
>      }
> 
> -    erec = scanner_push_file(scanner, name, f, loc);
> -    if (erec != NULL)
> -        goto err;
> +    for (i = 0; i < globbuf.gl_pathc; i++) {
> +        const char *name = globbuf.gl_pathv[i];
> +        FILE *f = fopen(name, "r");
> +        if (f == NULL) {
> +            erec = error(loc, "Could not open file \"%s\": %s\n",
> name, strerror(errno));
> +            goto err;
> +        }
> +        erec = scanner_push_file(scanner, name, f, loc);
> +        if (erec != NULL) {
> +            goto err;
> +        }
> +    }
> +
> +    globfree(&globbuf);
>      return 0;
> 
>  err:
> +    globfree(&globbuf);
>      erec_queue(erec, state->msgs);
>      return -1;
>  }
> diff --git a/tests/shell/testcases/include/0005glob_0
> b/tests/shell/testcases/include/0005glob_0
> new file mode 100755
> index 0000000..99dbf53
> --- /dev/null
> +++ b/tests/shell/testcases/include/0005glob_0
> @@ -0,0 +1,32 @@
> +#!/bin/bash
> +
> +set -e
> +
> +tmpdir=$(mktemp -d)
> +tmpfile=$(mktemp)
> +
> +trap "rm -rf $tmpdir $tmpfile" EXIT # cleanup if aborted
> +
> +RULESET1="add table x"
> +RULESET2="add table y"
> +RULESET3="include \"$tmpdir/*.conf\""
> +
> +echo "$RULESET1" > $tmpdir/ruleset1.conf
> +echo "$RULESET2" > $tmpdir/ruleset2.conf
> +echo "$RULESET3" > $tmpfile
> +
> +$NFT -f $tmpfile
> +if [ $? -ne 0 ] ; then
> +        echo "E: unable to load good ruleset" >&2
> +        exit 1
> +fi
> +$NFT list table x
> +if [ $? -ne 0 ] ; then
> +        echo "E: unable to include ruleset1.conf" >&2
> +        exit 1
> +fi
> +$NFT list table y
> +if [ $? -ne 0 ] ; then
> +        echo "E: unable to include ruleset2.conf" >&2
> +        exit 1
> +fi
> diff --git a/tests/shell/testcases/include/0006globempty_1
> b/tests/shell/testcases/include/0006globempty_1
> new file mode 100755
> index 0000000..3ac8c72
> --- /dev/null
> +++ b/tests/shell/testcases/include/0006globempty_1
> @@ -0,0 +1,14 @@
> +#!/bin/bash
> +
> +set -e
> +
> +tmpdir=$(mktemp -d)
> +tmpfile=$(mktemp)
> +
> +trap "rm -rf $tmpdir $tmpfile" EXIT # cleanup if aborted
> +
> +RULESET="include \"$tmpdir/*.conf\""
> +
> +echo "$RULESET" > $tmpfile
> +
> +$NFT -f $tmpfile 2>/dev/null
> -- 
> 2.10.2
> 
> 
> Kohei Suzuki
> eagletmt@gmail.com
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
