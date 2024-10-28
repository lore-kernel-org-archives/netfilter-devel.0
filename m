Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96CBB1865E3
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Oct 2024 23:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730158127; cv=none; b=ulKCSyiQ0YWXEmW5jKexrSXPDLK1txQmxXr043gykNxxORxdKVL4Dku8Ej3TokETs887bkRJj0S3kQ6Buk1Qedcf+UFBRPrGVe4CfFRNY+HTMfkJ2B0Rrlf3jc/FmW9YiqT7p9zzN1IbIp30a8UtwPweDbcT5o+z7ut68m9LlWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730158127; c=relaxed/simple;
	bh=+D7Fy8/0fMSnQoiOiNZn8PBHol4npE2vLlnwBO/nkiA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KCC3X+StDUr0cs2iNds+chwIrx3zZbBMY1qCPIsmUGRNleV0dkfumHF2ZrijEThuMV7a+Jg4E4liTid2AtZEBjWYJvCcy9ei2gjH5e9N5zmEC4WLAoOaDlbwv6u1SaCM2DS5dTqlhZB4J3aYaEZ9ROFgXmum0uKo4LQtMYvoIs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=58482 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t5ZA8-004vis-Lh; Tue, 29 Oct 2024 00:28:42 +0100
Date: Tue, 29 Oct 2024 00:28:39 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] tests: shell: don't rely on writable test directory
Message-ID: <ZyAeJ0lvifWevOuM@calendula>
References: <20241022140956.8160-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241022140956.8160-1-fw@strlen.de>
X-Spam-Score: -1.9 (-)

On Tue, Oct 22, 2024 at 04:09:54PM +0200, Florian Westphal wrote:
> Running shell tests from a virtme-ng instance with ro mapped test dir
> hangs due to runaway 'awk' reading from stdin instead of the intended
> $tmpfile (variable is empty).
> 
> Some tests want to check relative includes and try to create temporary
> files in the current directory.
> 
> [ -w ! $foo ... doesn't catch the error due to missing "".
> Add quotes and return the skip retval so those tests get flagged as
> skipped.
> 
> It would be better to resolve this by creating all temporary
> files in /tmp, but this is more intrusive change.
>
> 0013input_descriptors_included_files_0 and 0020include_chain_0 are
> switched to normal tmpfiles, there is nothing in the test that needs
> relative includes.
>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  tests/shell/testcases/include/0002relative_0  | 13 ++++----
>  .../0013input_descriptors_included_files_0    | 30 +++++++++----------
>  .../testcases/include/0020include_chain_0     |  9 +++---
>  3 files changed, 25 insertions(+), 27 deletions(-)
> 
> diff --git a/tests/shell/testcases/include/0002relative_0 b/tests/shell/testcases/include/0002relative_0
> index a91cd8f00047..30f4bbdbff79 100755
> --- a/tests/shell/testcases/include/0002relative_0
> +++ b/tests/shell/testcases/include/0002relative_0
> @@ -1,21 +1,20 @@
>  #!/bin/bash
>  
> -set -e
> -
>  tmpfile1=$(mktemp -p .)
> -if [ ! -w $tmpfile1 ] ; then
> +if [ ! -w "$tmpfile1" ] ; then
>          echo "Failed to create tmp file" >&2
> -        exit 0
> +        exit 77
>  fi
>  
> +trap "rm -rf $tmpfile1 $tmpfile2" EXIT # cleanup if aborted
> +set -e
> +
>  tmpfile2=$(mktemp -p .)
> -if [ ! -w $tmpfile2 ] ; then
> +if [ ! -w "$tmpfile2" ] ; then
>          echo "Failed to create tmp file" >&2
>          exit 0

this does not return 77, see below...

>  fi
>  
> -trap "rm -rf $tmpfile1 $tmpfile2" EXIT # cleanup if aborted
> -
>  RULESET1="add table x"
>  RULESET2="include \"$tmpfile1\""
>  
> diff --git a/tests/shell/testcases/include/0013input_descriptors_included_files_0 b/tests/shell/testcases/include/0013input_descriptors_included_files_0
> index 03de50b3c499..9dc6615dd332 100755
> --- a/tests/shell/testcases/include/0013input_descriptors_included_files_0
> +++ b/tests/shell/testcases/include/0013input_descriptors_included_files_0
> @@ -7,32 +7,32 @@
>  # instead of return value of nft.
>  
>  
> -tmpfile1=$(mktemp -p .)
> -if [ ! -w $tmpfile1 ] ; then
> +tmpfile1=$(mktemp)
> +if [ ! -w "$tmpfile1" ] ; then
>          echo "Failed to create tmp file" >&2
> -        exit 0
> +        exit 77

if patch is lazy, maybe just check for the first one to fail.

>  fi
>  
> -tmpfile2=$(mktemp -p .)
> -if [ ! -w $tmpfile2 ] ; then
> +trap "rm -rf $tmpfile1 $tmpfile2 $tmpfile3 $tmpfile4" EXIT # cleanup if aborted
> +
> +tmpfile2=$(mktemp)

this is good to remove -p . in mktemp.

I have destroyed 2 SSDs in 1.5 years running tests in a loop.

> +if [ ! -w "$tmpfile2" ] ; then
>          echo "Failed to create tmp file" >&2
> -        exit 0
> +        exit 77
>  fi
>  
> -tmpfile3=$(mktemp -p .)
> -if [ ! -w $tmpfile3 ] ; then
> +tmpfile3=$(mktemp)
> +if [ ! -w "$tmpfile3" ] ; then
>          echo "Failed to create tmp file" >&2
> -        exit 0
> +        exit 77
>  fi
>  
> -tmpfile4=$(mktemp -p .)
> -if [ ! -w $tmpfile4 ]; then
> +tmpfile4=$(mktemp)
> +if [ ! -w "$tmpfile4" ]; then
>          echo "Failed to create tmp file" >&2
> -        exit 0
> +        exit 77
>  fi
>  
> -trap "rm -rf $tmpfile1 $tmpfile2 $tmpfile3 $tmpfile4" EXIT # cleanup if aborted
> -
>  RULESET1="include \"$tmpfile2\""
>  RULESET2="include \"$tmpfile3\""
>  RULESET3="add rule x y anything everything"			# wrong nft syntax
> @@ -44,7 +44,7 @@ echo "$RULESET3" > $tmpfile2
>  
>  $NFT -f $tmpfile1 2> $tmpfile4
>  
> -var=$(awk -F: '$4==" Error"{print $1;exit;}' $tmpfile4)
> +var=$(awk -F: '$4==" Error"{print $1;exit;}' "$tmpfile4")
>  
>  if [ $var == "$tmpfile3" ]; then
>  	echo "E: Test failed" >&2
> diff --git a/tests/shell/testcases/include/0020include_chain_0 b/tests/shell/testcases/include/0020include_chain_0
> index 49b6f76c6a8d..a09511974e29 100755
> --- a/tests/shell/testcases/include/0020include_chain_0
> +++ b/tests/shell/testcases/include/0020include_chain_0
> @@ -1,13 +1,12 @@
>  #!/bin/bash
>  
> -set -e
> -
> -tmpfile1=$(mktemp -p .)
> -if [ ! -w $tmpfile1 ] ; then
> +tmpfile1=$(mktemp)
> +if [ ! -w "$tmpfile1" ] ; then
>  	echo "Failed to create tmp file" >&2
> -	exit 0
> +	exit 77
>  fi
>  
> +set -e
>  trap "rm -rf $tmpfile1" EXIT # cleanup if aborted
>  
>  RULESET="table inet filter { }
> -- 
> 2.45.2
> 
> 
