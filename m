Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43FB731E0FD
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Sep 2025 14:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756824246; cv=none; b=Sme1liwGs/DyN0SHerR8xkDk8F5+rDsOabR+u5Sl62sExrPrJJ+ucU92CPMCdz5rTH2uObFnkFSlr5RYcpxrbI9VCjTn69WM25/RM1ZhLhcZWtkOlabrsYnmb9y9d6mi5mQkFk+s1LGaNLUoLA90LLYknT9/N0fRPTSDiTb6IV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756824246; c=relaxed/simple;
	bh=1Ut/CMAUvDoycdiRZ5/HI3s1ndU0S1BcwxQphjSjS+g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SRzKDEqOk3s3M5r7yVTItMp593jRlrGfSbyYxmkeSwQopugOY5jL/yz/fPwx9mPAPWJ9AsiHIehC+KlL7rUIQkycKNeTfwO87LFZLlspnlsUtirifl7fJzHF3pBhf7/536oeA00odzd7OY3haAOKQ/I6M5m7K/Nz58q8dEd2qp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=LynAU+/I; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=LynAU+/I; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="LynAU+/I";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="LynAU+/I"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id A2F23606FE; Tue,  2 Sep 2025 16:44:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756824242;
	bh=Wzkdh8b9ZUCw6ttQ4ojcVLbBNWxkYX23/Gd6sOcK5F0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LynAU+/IvnAIbMqHvaCBbvuKuX/VFCWfqLpvXIzC7y9TRpDs60Ra0Z70tLPTw9amQ
	 sd2T49Gx82j6YqK5HfMOMPc49MrHElHigmLl+sK+p+UPEXRejpqRuuvxAPutPbeK6q
	 nraj27zm3l/l7SuMyVa6MQO8jdOYjoJ/+Mge5feTnj/nFca6SGk3Sb35wKHfGONcF9
	 Ukeb5cIrl1g7UnRHD+WUAtaFezho4HCCwOvVgS1svAplS31D+zuHmIHBCOoF+dchrB
	 hB3EoowYPE3qk7W/MYFOwORJLraxAW/JCENFztyHNnXKxfSIYkhlC06IFLyr6+jF78
	 nCmKHuwRRxO7Q==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D9A55606FE;
	Tue,  2 Sep 2025 16:44:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756824242;
	bh=Wzkdh8b9ZUCw6ttQ4ojcVLbBNWxkYX23/Gd6sOcK5F0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LynAU+/IvnAIbMqHvaCBbvuKuX/VFCWfqLpvXIzC7y9TRpDs60Ra0Z70tLPTw9amQ
	 sd2T49Gx82j6YqK5HfMOMPc49MrHElHigmLl+sK+p+UPEXRejpqRuuvxAPutPbeK6q
	 nraj27zm3l/l7SuMyVa6MQO8jdOYjoJ/+Mge5feTnj/nFca6SGk3Sb35wKHfGONcF9
	 Ukeb5cIrl1g7UnRHD+WUAtaFezho4HCCwOvVgS1svAplS31D+zuHmIHBCOoF+dchrB
	 hB3EoowYPE3qk7W/MYFOwORJLraxAW/JCENFztyHNnXKxfSIYkhlC06IFLyr6+jF78
	 nCmKHuwRRxO7Q==
Date: Tue, 2 Sep 2025 16:43:59 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v2 2/7] tests: monitor: Support running all tests in
 one go
Message-ID: <aLcCr2YxUkRFH6UH@calendula>
References: <20250829155203.29000-1-phil@nwl.cc>
 <20250829155203.29000-3-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250829155203.29000-3-phil@nwl.cc>

On Fri, Aug 29, 2025 at 05:51:58PM +0200, Phil Sutter wrote:
> Detect RUN_FULL_TESTSUITE env variable set by automake and do an
> "unattended" full testrun.

This test is so small that I think it is better to enable both modes:
w/json and w/o json by default.

> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  tests/monitor/run-tests.sh | 23 ++++++++++++++++-------
>  1 file changed, 16 insertions(+), 7 deletions(-)
> 
> diff --git a/tests/monitor/run-tests.sh b/tests/monitor/run-tests.sh
> index 969afe249201b..b8589344a9732 100755
> --- a/tests/monitor/run-tests.sh
> +++ b/tests/monitor/run-tests.sh
> @@ -58,7 +58,7 @@ json_output_filter() { # (filename)
>  monitor_run_test() {
>  	monitor_output=$(mktemp -p $testdir)
>  	monitor_args=""
> -	$test_json && monitor_args="vm json"
> +	$json_mode && monitor_args="vm json"
>  	local rc=0
>  
>  	$nft -nn monitor $monitor_args >$monitor_output &
> @@ -77,7 +77,7 @@ monitor_run_test() {
>  	sleep 0.5
>  	kill $monitor_pid
>  	wait >/dev/null 2>&1
> -	$test_json && json_output_filter $monitor_output
> +	$json_mode && json_output_filter $monitor_output
>  	mydiff -q $monitor_output $output_file >/dev/null 2>&1
>  	if [[ $rc == 0 && $? != 0 ]]; then
>  		err "monitor output differs!"
> @@ -156,20 +156,29 @@ while [ -n "$1" ]; do
>  	esac
>  done
>  
> -if $test_json; then
> -	variants="monitor"
> +if [[ $RUN_FULL_TESTSUITE == 1 ]]; then
> +	variants="monitor_json monitor echo"
> +elif $test_json; then
> +	variants="monitor_json"
>  else
>  	variants="monitor echo"
>  fi
>  
>  rc=0
>  for variant in $variants; do
> +	orig_variant=$variant
> +	if [[ $variant =~ .*_json ]]; then
> +		variant=${variant%_json}
> +		json_mode=true
> +	else
> +		json_mode=false
> +	fi
>  	run_test=${variant}_run_test
>  	output_append=${variant}_output_append
>  
>  	for testcase in ${testcases:-testcases/*.t}; do
>  		filename=$(basename $testcase)
> -		echo "$variant: running tests from file $filename"
> +		echo "$orig_variant: running tests from file $filename"
>  		rc_start=$rc
>  
>  		# files are like this:
> @@ -194,11 +203,11 @@ for variant in $variants; do
>  				;;
>  			O)
>  				input_complete=true
> -				$test_json || $output_append "$line"
> +				$json_mode || $output_append "$line"
>  				;;
>  			J)
>  				input_complete=true
> -				$test_json && $output_append "$line"
> +				$json_mode && $output_append "$line"
>  				;;
>  			'#'|'')
>  				# ignore comments and empty lines
> -- 
> 2.51.0
> 
