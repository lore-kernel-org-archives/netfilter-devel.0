Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 945C4132103
	for <netfilter-devel@vger.kernel.org>; Wed, 18 Jun 2025 22:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750286802; cv=none; b=XzHd/FaL79lY+znpZJ9LXDdPsxVKFkRJx61Rjl2Yas9yYr+T/Ib6fBeORb4S4w4gEkmN3UZgZSB0N9/sskBdVLinMnNfzVhbKQgO8dFvJMZQZmdB4vXeiWCbFTdhcb6YrDtFWs4WEOBiLf/Wn+PJfOMA2B2l+isDRoboZ+OGMdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750286802; c=relaxed/simple;
	bh=mJIypwr/a1upDL1TWAm95RzXJR8sIPs/RbNPEIyIbUI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rerKUuBZRzequWpS+zbd6sfQq6TdhZt2yO1aTdigdwqKt7gbt8qzlU+jSjM5JQUMJoiVGrJnbO5RduW+RqH+id1Ks/eMYjvtdDqxgMc94uPNztnZNS255Qg78GFaim2Z274/vqNEqC60yQ9ii9gMeQ8xMi+pFieaWmE7kZt8weg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 0FAF9612C3; Thu, 19 Jun 2025 00:46:37 +0200 (CEST)
Date: Thu, 19 Jun 2025 00:46:36 +0200
From: Florian Westphal <fw@strlen.de>
To: Yi Chen <yiche@redhat.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] tests: shell: Add a test case to verify the limit
 statement.
Message-ID: <aFNBzJOssxBN-ck4@strlen.de>
References: <20250617104128.27188-1-yiche@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250617104128.27188-1-yiche@redhat.com>

Yi Chen <yiche@redhat.com> wrote:
> Signed-off-by: Yi Chen <yiche@redhat.com>
> ---
>  tests/shell/features/ncat.sh                |   4 +
>  tests/shell/testcases/packetpath/rate_limit | 154 ++++++++++++++++++++
>  2 files changed, 158 insertions(+)
>  create mode 100755 tests/shell/features/ncat.sh
>  create mode 100755 tests/shell/testcases/packetpath/rate_limit
> 
> diff --git a/tests/shell/features/ncat.sh b/tests/shell/features/ncat.sh
> new file mode 100755
> index 00000000..eb1581ce
> --- /dev/null
> +++ b/tests/shell/features/ncat.sh
> @@ -0,0 +1,4 @@
> +#!/bin/sh
> +
> +# check whether ncat is installed
> +ncat -h >/dev/null 2>&1

Could you convert the test to use socat, which is already
used by many other tests?

> +assert_pass()
> +{
> +	local ret=$?
> +	if [ $ret != 0 ]; then
> +		echo "FAIL: ${@}"
> +		exit 1
> +	else
> +		echo "PASS: ${@}"
> +	fi
> +}

This is now the 3rd copy of this helper.

Maybe its time to add a library/utility file that has these
functions?

test-wrapper.sh could export an environment variable pointing to it, e.g.

export NFT_TEST_LIBRARY_FILE="$NFT_TEST_BASEDIR/helpers/lib.sh"

or whatever.  Then tests can do

. $NFT_TEST_LIBRARY_FILE

and gain these helpers in case they need them.

> +# tcp test
> +ip netns exec $S ncat -lk 80 > /dev/null & sleep 1

I guess sleep 1 is fine. But maybe its time to add a central
helper for this wait.

You could submit a patch that adds the helpers/lib.sh file and
then lifts the "wait_local_port_listen" helper function from

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/diff/tools/testing/selftests/net/lib.sh?id=d9d836bfa5e6e255c411733b4b1ce7a1f8346c54

Other than that I think the test looks good, thanks Yi!
