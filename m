Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39E48CDB482
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Oct 2023 09:04:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234793AbjJQJEw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Oct 2023 05:04:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234779AbjJQJEv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Oct 2023 05:04:51 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E32798E
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2023 02:04:48 -0700 (PDT)
Received: from [78.30.34.192] (port=51750 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qsg0I-004IbP-JM; Tue, 17 Oct 2023 11:04:44 +0200
Date:   Tue, 17 Oct 2023 11:04:41 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft v2 2/3] tests/shell: skip "table_onoff" test on older
 kernels
Message-ID: <ZS5OKQycMX0cScgb@calendula>
References: <20231017085133.1203402-1-thaller@redhat.com>
 <20231017085133.1203402-3-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231017085133.1203402-3-thaller@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Oct 17, 2023 at 10:49:07AM +0200, Thomas Haller wrote:
> The "table_onoff" test can only pass with certain (recent) kernels.
> Conditionally exit with status 77, if "eval-exit-code" determines that
> we don't have a suitable kernel version.
> 
> In this case, we can find the fixes in:
> 
>  v6.6      : https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=c9bd26513b3a11b3adb3c2ed8a31a01a87173ff1
>  v6.5.6    : https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=5e5754e9e77ce400d70ff3c30fea466c8dfe9a9f
>  v6.1.56   : https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=c4b0facd5c20ceae3d07018a3417f06302fa9cd1
>  v5.15.135 : https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=0dcc9b4097d860d9af52db5366a8755c13468d13

I am not sure it worth this level of tracking.

Soon these patches will be in upstream stable and this extra shell
code will be simply deadcode in little time.

> Fixes: bcca2d67656f ('tests: add test for dormant on/off/on bug')
> Signed-off-by: Thomas Haller <thaller@redhat.com>
> ---
>  tests/shell/testcases/transactions/table_onoff | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/tests/shell/testcases/transactions/table_onoff b/tests/shell/testcases/transactions/table_onoff
> index 831d4614c1f2..0e70ad2cc3f4 100755
> --- a/tests/shell/testcases/transactions/table_onoff
> +++ b/tests/shell/testcases/transactions/table_onoff
> @@ -11,7 +11,9 @@ delete table ip t
>  EOF
>  
>  if [ $? -eq 0 ]; then
> -	exit 1
> +	echo "Command to re-awaken a dormant table did not fail. Lacking https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=c9bd26513b3a11b3adb3c2ed8a31a01a87173ff1 ?"
> +	"$NFT_TEST_BASEDIR/helpers/eval-exit-code" kernel  6.6  6.5.6  6.1.56  5.15.135
> +	exit $?
>  fi
>  
>  set -e
> -- 
> 2.41.0
> 
