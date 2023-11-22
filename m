Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3CA5C61D9B
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Nov 2023 12:33:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235084AbjKVMdl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Nov 2023 07:33:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230510AbjKVMdk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Nov 2023 07:33:40 -0500
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C79A91
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2023 04:33:37 -0800 (PST)
Received: from [78.30.43.141] (port=57258 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1r5mQ8-00Ce1z-P3; Wed, 22 Nov 2023 13:33:35 +0100
Date:   Wed, 22 Nov 2023 13:33:30 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 1/1] tests: prettify JSON in test output and add
 helper
Message-ID: <ZV31GgRsu6Y7UScC@calendula>
References: <20231122111946.439474-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231122111946.439474-1-thaller@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Wed, Nov 22, 2023 at 12:19:40PM +0100, Thomas Haller wrote:
> - add helper script "json-pretty.sh" for prettify/format JSON.
>   It uses either `jq` or a `python` fallback. In my tests, they
>   produce the same output, but the output is not guaranteed to be
>   stable. This is mainly for informational purpose.
> 
> - add a "json-diff-pretty.sh" which prettifies two JSON inputs and
>   shows a diff of them.
> 
> - in "test-wrapper.sh", after the check for a .json-nft dump fails, also
>   call "json-diff-pretty.sh" and write the output to "ruleset-diff.json.pretty".
>   This is beside "ruleset-diff.json", which contains the original diff.

One silly question: Does the prettify hightlights the difference?

tests/py clearly shows what is the difference in the JSON diff that
quickly helps you identify what is missing.

Thanks!

> Signed-off-by: Thomas Haller <thaller@redhat.com>
> ---
>  tests/shell/helpers/json-diff-pretty.sh | 17 +++++++++++++++++
>  tests/shell/helpers/json-pretty.sh      | 17 +++++++++++++++++
>  tests/shell/helpers/test-wrapper.sh     |  4 ++++
>  3 files changed, 38 insertions(+)
>  create mode 100755 tests/shell/helpers/json-diff-pretty.sh
>  create mode 100755 tests/shell/helpers/json-pretty.sh
> 
> diff --git a/tests/shell/helpers/json-diff-pretty.sh b/tests/shell/helpers/json-diff-pretty.sh
> new file mode 100755
> index 000000000000..bebb7e8ed006
> --- /dev/null
> +++ b/tests/shell/helpers/json-diff-pretty.sh
> @@ -0,0 +1,17 @@
> +#!/bin/bash -e
> +
> +BASEDIR="$(dirname "$0")"
> +
> +[ $# -eq 2 ] || (echo "$0: expects two JSON files as arguments" ; exit 1)
> +
> +FILE1="$1"
> +FILE2="$2"
> +
> +pretty()
> +{
> +	"$BASEDIR/json-pretty.sh" < "$1" 2>&1 || :
> +}
> +
> +echo "Cmd: \"$0\" \"$FILE1\" \"$FILE2\""
> +diff -u "$FILE1" "$FILE2" 2>&1 || :
> +diff -u <(pretty "$FILE1") <(pretty "$FILE2") 2>&1 || :
> diff --git a/tests/shell/helpers/json-pretty.sh b/tests/shell/helpers/json-pretty.sh
> new file mode 100755
> index 000000000000..0d6972b81e2f
> --- /dev/null
> +++ b/tests/shell/helpers/json-pretty.sh
> @@ -0,0 +1,17 @@
> +#!/bin/bash -e
> +
> +# WARNING: the output is not guaranteed to be stable.
> +
> +if command -v jq &>/dev/null ; then
> +	# If we have, use `jq`
> +	exec jq
> +fi
> +
> +# Fallback to python.
> +exec python -c '
> +import json
> +import sys
> +
> +parsed = json.load(sys.stdin)
> +print(json.dumps(parsed, indent=2))
> +'
> diff --git a/tests/shell/helpers/test-wrapper.sh b/tests/shell/helpers/test-wrapper.sh
> index 9e8e60581890..4ffc48184dd7 100755
> --- a/tests/shell/helpers/test-wrapper.sh
> +++ b/tests/shell/helpers/test-wrapper.sh
> @@ -202,6 +202,10 @@ if [ "$rc_test" -ne 77 -a "$dump_written" != y ] ; then
>  	fi
>  	if [ "$NFT_TEST_HAVE_json" != n -a -f "$JDUMPFILE" ] ; then
>  		if ! $DIFF -u "$JDUMPFILE" "$NFT_TEST_TESTTMPDIR/ruleset-after.json" &> "$NFT_TEST_TESTTMPDIR/ruleset-diff.json" ; then
> +			"$NFT_TEST_BASEDIR/helpers/json-diff-pretty.sh" \
> +				"$JDUMPFILE" \
> +				"$NFT_TEST_TESTTMPDIR/ruleset-after.json" \
> +				2>&1 > "$NFT_TEST_TESTTMPDIR/ruleset-diff.json.pretty"
>  			show_file "$NFT_TEST_TESTTMPDIR/ruleset-diff.json" "Failed \`$DIFF -u \"$JDUMPFILE\" \"$NFT_TEST_TESTTMPDIR/ruleset-after.json\"\`" >> "$NFT_TEST_TESTTMPDIR/rc-failed-dump"
>  			rc_dump=1
>  		else
> -- 
> 2.42.0
> 
