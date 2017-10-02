From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] tests: shell: Add test for chain rename.
Date: Mon, 2 Oct 2017 14:35:42 +0200
Message-ID: <20171002123542.GA8929@salvia>
References: <20171002110154.19721-1-rvarsha016@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Varsha Rao <rvarsha016@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from [213.95.27.120] ([213.95.27.120]:57177 "EHLO
        ganesha.gnumonks.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750984AbdJBMg4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Oct 2017 08:36:56 -0400
Content-Disposition: inline
In-Reply-To: <20171002110154.19721-1-rvarsha016@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Oct 02, 2017 at 04:31:54PM +0530, Varsha Rao wrote:
> This patch adds test for chain rename use case.
> 
> Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
> ---
>  tests/shell/testcases/chains/0013rename_1 | 9 +++++++++
>  1 file changed, 9 insertions(+)
>  create mode 100755 tests/shell/testcases/chains/0013rename_1
> 
> diff --git a/tests/shell/testcases/chains/0013rename_1 b/tests/shell/testcases/chains/0013rename_1
> new file mode 100755
> index 0000000..a69d855
> --- /dev/null
> +++ b/tests/shell/testcases/chains/0013rename_1
> @@ -0,0 +1,9 @@
> +#!/bin/bash
> +
> +set -e
> +
> +$NFT add table t
> +$NFT add chain t c1
> +# kernel should return EEXIST

Wait, I guess you mean here: "kernel should not return EEXIST as per
0d18779be13766b33c69cbc26df38383598da373", right? I can mangle this
line here before applying.

> +$NFT rename chain t c1 c2 2>/dev/null
> +echo "E: Renamed chain with non existing chain" >&2

BTW, could you also add a test to make sure we don't allow a rename
from 'c1' to 'c2' if chain 'c2' already exists.
