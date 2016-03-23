From: Mart Frauenlob <mart.frauenlob@chello.at>
Subject: Re: [nft PATCH] tests/shell: add chain validations tests
Date: Wed, 23 Mar 2016 01:09:06 +0100
Message-ID: <56F1DEA2.70409@chello.at>
References: <145865193086.6118.9200431804176858644.stgit@nfdev2.cica.es>
Reply-To: mart.frauenlob@chello.at
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vie01a-dmta-at01-1.mx.upcmail.net ([62.179.121.145]:15403 "EHLO
	vie01a-dmta-at01-1.mx.upcmail.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752628AbcCWAJI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Mar 2016 20:09:08 -0400
Received: from [172.31.216.43] (helo=vie01a-pemc-psmtp-pe01)
	by vie01a-dmta-at01.mx.upcmail.net with esmtp (Exim 4.72)
	(envelope-from <mart.frauenlob@chello.at>)
	id 1aiWMC-0006yY-Sl
	for netfilter-devel@vger.kernel.org; Wed, 23 Mar 2016 01:09:04 +0100
In-Reply-To: <145865193086.6118.9200431804176858644.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Good day,

On 22.03.2016 14:06, Arturo Borrero Gonzalez wrote:
> Some basic test regarding chains: jumps and validations.
>
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
> NOTE: the testcases/chains/0009masquerade_jump_1 file fails, seems like a bug
> in the kernel validation. Needs more investigation.
>
>   tests/shell/testcases/chains/0001jumps_0           |   17 +++++++++++++++
>   tests/shell/testcases/chains/0002jumps_1           |   22 ++++++++++++++++++++
>   tests/shell/testcases/chains/0003jump_loop_1       |   21 +++++++++++++++++++
>   tests/shell/testcases/chains/0004busy_1            |   11 ++++++++++
>   tests/shell/testcases/chains/0005busy_map_1        |   11 ++++++++++
>   tests/shell/testcases/chains/0006masquerade_0      |    7 ++++++
>   tests/shell/testcases/chains/0007masquerade_1      |    9 ++++++++
>   tests/shell/testcases/chains/0008masquerade_jump_1 |   11 ++++++++++
>   tests/shell/testcases/chains/0009masquerade_jump_1 |   11 ++++++++++
>   9 files changed, 120 insertions(+)
>   create mode 100755 tests/shell/testcases/chains/0001jumps_0
>   create mode 100755 tests/shell/testcases/chains/0002jumps_1
>   create mode 100755 tests/shell/testcases/chains/0003jump_loop_1
>   create mode 100755 tests/shell/testcases/chains/0004busy_1
>   create mode 100755 tests/shell/testcases/chains/0005busy_map_1
>   create mode 100755 tests/shell/testcases/chains/0006masquerade_0
>   create mode 100755 tests/shell/testcases/chains/0007masquerade_1
>   create mode 100755 tests/shell/testcases/chains/0008masquerade_jump_1
>   create mode 100755 tests/shell/testcases/chains/0009masquerade_jump_1
>
> diff --git a/tests/shell/testcases/chains/0001jumps_0 b/tests/shell/testcases/chains/0001jumps_0
> new file mode 100755
> index 0000000..b39df38
> --- /dev/null
> +++ b/tests/shell/testcases/chains/0001jumps_0
> @@ -0,0 +1,17 @@
> +#!/bin/bash

I've not looked up the code calling this, but:
First: bash only?
Second: It's not granted to be in /bin.
Third: May not be the wanted version.

So a shebang like:
#!/usr/bin/env bash
or
#!/urs/bin/env sh
should be more compatible and fail proof.

> +
> +set -e
> +
> +MAX_JUMPS=16
> +
> +$NFT add table t
Unquoted variable, may fail if, unlikely but possible, the name contains 
i.e. spaces.

> +
> +for i in $(seq 1 $MAX_JUMPS)
> +do
> +	$NFT add chain t c${i}
> +done
Requires `seq' binary.
I think for ((i=1; i<=$MAX_JUMPS; i++)) is more portable.

> +
> +for i in $(seq 1 $((MAX_JUMPS - 1)))
> +do
> +	$NFT add rule t c${i} jump c$((i + 1))
> +done

Why not add functions? i.e.

runft() {
"$NFT" "$@"
}

nfat() {
runft add table "$@"
}

nfac() {
runft add chain "$@"
}
....

[...]

Best regards,
Mart
