Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BAF0CDB482
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Oct 2023 09:34:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbjJRJeg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Oct 2023 05:34:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230263AbjJRJeW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Oct 2023 05:34:22 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F8E1115
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Oct 2023 02:33:56 -0700 (PDT)
Received: from [78.30.34.192] (port=41796 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qt2w4-00C2Hm-7o; Wed, 18 Oct 2023 11:33:54 +0200
Date:   Wed, 18 Oct 2023 11:33:51 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 1/1] tests/shell: add NFT_TEST_FAIL_ON_SKIP_EXCEPT
 for allow-list of skipped tests (XFAIL)
Message-ID: <ZS+mfyhHzEld2gJ6@calendula>
References: <20231017223450.2613981-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231017223450.2613981-1-thaller@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Oct 18, 2023 at 12:33:29AM +0200, Thomas Haller wrote:
> Some tests cannot pass, for example due to missing kernel features or
> kernel bugs. The tests make an educated guess (feature detection),
> whether the failure is due to that, and marks the test as SKIP (exit
> 77). The problem is, the test might guess wrong and hide a real issue.
> 
> Add support for a NFT_TEST_FAIL_ON_SKIP_EXCEPT= regex to help with this.
> Together with NFT_TEST_FAIL_ON_SKIP=y is enabled, test names that match
> the regex are allowed to be skipped. Unexpected skips are treated as
> fatal. This allows to maintain a list of tests that are known to be
> skipped.
> 
> You can think of this as some sort of XFAIL/XPASS mechanism. The
> difference is that usually XFAIL is part of the test. Here the failure
> happens due to external conditions, as such you need to configure
> NFT_TEST_FAIL_ON_SKIP_EXCEPT= per kernel. Also, usually XFAIL is about
> failing tests, while this is about tests that are marked to be skipped.
> But we mark them as skipped due to a heuristic, and those we want to
> manually keep track off.
> 
> Why is NFT_TEST_FAIL_ON_SKIP_EXCEPT= useful and why doesn't it just work
> automatically? It does work automatically (see use case 1 below).  Trust
> the automatism to the right thing, and don't bother. This is when you
> don't trust the automatism and you curate a list of tests that are known
> to be be skipped, but no others (see use case 3 below). In particular,
> it's for running CI on a downstream kernel, where we expect a static
> list of skipped tests and where we want to find any changes.
> 
> Consider this: there are three use case for running the tests.
> 
>   1) The contributor, who wants to run the test suite. The tests make a
>   best effort to pass and when the test detects that the failure is
>   likely due to the kernel, then it will skip the test. This is the
>   default.

This is not a good default, it is us that are running this tests
infrastructure, we are the target users.

This contributor should be running latest kernel either from nf.git
and nf-next.git

>   2) The maintainer, who runs latest kernel and expects that all tests are
>   passing. Any SKIP is likely a bug. This is achieved by setting
>   NFT_TEST_FAIL_ON_SKIP=y.

I don't want to remember to set this on, I am running this in my
test machines all the time.

>   3) The downstream maintainer, who test a distro kernel that is known to
>   lack certain features. They know that a selected few tests should be
>   skipped, but most tests should pass. By setting NFT_TEST_FAIL_ON_SKIP=y
>   and NFT_TEST_FAIL_ON_SKIP_EXCEPT= they can specify which are expected to
>   be skipped. The regex is kernel/environment specific, and must be
>   actively curated.

Such downstream maintainer should be really concerned about the test
failure and track the issue to make sure the fix gets to their
downstream kernel.

>   BONUS) actually, cases 2) and 3) optimally run automated CI tests.
>   Then the test environment is defined with a particular kernel variant
>   and changes slowly over time. NFT_TEST_FAIL_ON_SKIP_EXCEPT= allows
>   to pick up any unexpected changes of the skipped/pass behavior of
>   tests.
> 
> If a test matches the regex but passes, this is also flagged as a
> failure ([XPASS]). The user is required to maintain an accurate list of
> XFAIL tests.
> 
> Example:
> 
>   $ NFT_TEST_FAIL_ON_SKIP=y \
>     NFT_TEST_FAIL_ON_SKIP_EXCEPT='^(tests/shell/testcases/nft-f/0017ct_timeout_obj_0|tests/shell/testcases/listing/0020flowtable_0)$' \
>     ./tests/shell/run-tests.sh \
>           tests/shell/testcases/nft-f/0017ct_timeout_obj_0 \
>           tests/shell/testcases/cache/0006_cache_table_flush \
>           tests/shell/testcases/listing/0013objects_0 \
>           tests/shell/testcases/listing/0020flowtable_0
>   ...
>   I: [SKIPPED]     1/4 tests/shell/testcases/nft-f/0017ct_timeout_obj_0
>   I: [OK]          2/4 tests/shell/testcases/cache/0006_cache_table_flush
>   W: [FAIL-SKIP]   3/4 tests/shell/testcases/listing/0013objects_0
>   W: [XPASS]       4/4 tests/shell/testcases/listing/0020flowtable_0
> 
> This list of XFAIL tests is maintainable, because on a particular
> downstream kernel, the number of tests known to be skipped is small and
> relatively static. Also, you can generate the list easily (followed by
> manual verification!) via
> 
>   $ NFT_TEST_FAIL_ON_SKIP=n ./tests/shell/run-tests.sh -k
>   $ export NFT_TEST_FAIL_ON_SKIP_EXCEPT="$(cat /tmp/nft-test.latest.*/skip-if-fail-except)"
>   $ NFT_TEST_FAIL_ON_SKIP=y ./tests/shell/run-tests.sh
> 
> Signed-off-by: Thomas Haller <thaller@redhat.com>
> ---
> Sorry for the overly long commit message. I hope it can be useful and
> speak in favor of the patch (and not against it).
> 
> This is related to the "eval-exit-code" patch, as it's about how to
> handle tests that are SKIPed. But it's relevant for any skipped test,
> and not tied to that work.
> 
>  tests/shell/helpers/test-wrapper.sh | 41 +++++++++++++++++++++
>  tests/shell/run-tests.sh            | 55 ++++++++++++++++++++++-------
>  2 files changed, 83 insertions(+), 13 deletions(-)
> 
> diff --git a/tests/shell/helpers/test-wrapper.sh b/tests/shell/helpers/test-wrapper.sh
> index 13b918f8b8e1..e8edb7332d24 100755
> --- a/tests/shell/helpers/test-wrapper.sh
> +++ b/tests/shell/helpers/test-wrapper.sh
> @@ -176,10 +176,49 @@ if [ "$tainted_before" != "$tainted_after" ] ; then
>  	rc_tainted=1
>  fi
>  
> +rc_fail_on_skip=0
> +rc_fail_on_skip_xpass=0
> +if [ "$NFT_TEST_FAIL_ON_SKIP" = y ] ; then
> +	if [ -n "${NFT_TEST_FAIL_ON_SKIP_EXCEPT+x}" ] ; then
> +
> +		OLD_IFS="$IFS"
> +		IFS=$'\n'
> +		REGEXES=( $NFT_TEST_FAIL_ON_SKIP_EXCEPT )
> +		IFS="$OLD_IFST"
> +
> +		re_match=0
> +		for re in "${REGEXES[@]}" ; do
> +			if [[ "$TEST" =~ $re ]] ; then
> +				re_match=1
> +				break;
> +			fi
> +		done
> +
> +		if [ "$re_match" -eq 1 ] ; then
> +			if [ "$rc_test" -eq 0 ] ; then
> +				echo "test passed although expected to be skipped (XPASS) by regex NFT_TEST_FAIL_ON_SKIP_EXCEPT /$NFT_TEST_FAIL_ON_SKIP_EXCEPT/" > "$NFT_TEST_TESTTMPDIR/rc-failed-skip"
> +				rc_fail_on_skip_xpass=1
> +			fi
> +		else
> +			if [ "$rc_test" -eq 77 ] ; then
> +				echo "upgrade skip to failure due to NFT_TEST_FAIL_ON_SKIP. Regex NFT_TEST_FAIL_ON_SKIP_EXCEPT /$NFT_TEST_FAIL_ON_SKIP_EXCEPT/ does not match" > "$NFT_TEST_TESTTMPDIR/rc-failed-skip"
> +				rc_fail_on_skip=1
> +			fi
> +		fi
> +	else
> +		if [ "$rc_test" -eq 77 ] ; then
> +			echo "upgrade skip to failure due to NFT_TEST_FAIL_ON_SKIP" > "$NFT_TEST_TESTTMPDIR/rc-failed-skip"
> +			rc_fail_on_skip=1
> +		fi
> +	fi
> +fi
> +
>  if [ "$rc_valgrind" -ne 0 ] ; then
>  	rc_exit=122
>  elif [ "$rc_tainted" -ne 0 ] ; then
>  	rc_exit=123
> +elif [ "$rc_fail_on_skip" -ne 0 ] ; then
> +	rc_exit=120
>  elif [ "$rc_test" -ge 118 -a "$rc_test" -le 124 ] ; then
>  	# Special exit codes are reserved. Coerce them.
>  	rc_exit=125
> @@ -189,6 +228,8 @@ elif [ "$rc_dump" -ne 0 ] ; then
>  	rc_exit=124
>  elif [ "$rc_chkdump" -ne 0 ] ; then
>  	rc_exit=121
> +elif [ "$rc_fail_on_skip_xpass" -ne 0 ] ; then
> +	rc_exit=119
>  else
>  	rc_exit=0
>  fi
> diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
> index 22105c2e90e2..8fceb2795113 100755
> --- a/tests/shell/run-tests.sh
> +++ b/tests/shell/run-tests.sh
> @@ -221,6 +221,10 @@ usage() {
>  	echo "                 kernel modules)."
>  	echo "                 Parallel jobs requires unshare and are disabled with NFT_TEST_UNSHARE_CMD=\"\"."
>  	echo " NFT_TEST_FAIL_ON_SKIP=*|y: if any jobs are skipped, exit with error."
> +	echo " NFT_TEST_FAIL_ON_SKIP_EXCEPT=<regex>: only honored with NFT_TEST_FAIL_ON_SKIP=y. This is a regex for"
> +	echo "                 tests for which a skip is expected and not fatal (XFAIL). Multiple regex can be separated by"
> +	echo "                 newline. This allows that skip a selected set of known tests, while all other tests must pass."
> +	echo "                 If a test passes but matches the regex, it is treated as failure too (XPASS)."
>  	echo " NFT_TEST_RANDOM_SEED=<SEED>: The test runner will export the environment variable NFT_TEST_RANDOM_SEED"
>  	echo "                 set to a random number. This can be used as a stable seed for tests to randomize behavior."
>  	echo "                 Set this to a fixed value to get reproducible behavior."
> @@ -305,6 +309,8 @@ export NFT_TEST_RANDOM_SEED
>  
>  TESTS=()
>  
> +TESTS_SKIP_EXCEPT=()
> +
>  SETUP_HOST=
>  SETUP_HOST_OTHER=
>  
> @@ -639,6 +645,11 @@ msg_info "conf: NFT_TEST_HAS_UNSHARED_MOUNT=$(printf '%q' "$NFT_TEST_HAS_UNSHARE
>  msg_info "conf: NFT_TEST_KEEP_LOGS=$(printf '%q' "$NFT_TEST_KEEP_LOGS")"
>  msg_info "conf: NFT_TEST_JOBS=$NFT_TEST_JOBS"
>  msg_info "conf: NFT_TEST_FAIL_ON_SKIP=$NFT_TEST_FAIL_ON_SKIP"
> +if [ -z "${NFT_TEST_FAIL_ON_SKIP_EXCEPT+x}" ] ; then
> +	msg_info "conf: # NFT_TEST_FAIL_ON_SKIP_EXCEPT unset"
> +else
> +	msg_info "conf: NFT_TEST_FAIL_ON_SKIP_EXCEPT=$(printf '%q' "$NFT_TEST_FAIL_ON_SKIP_EXCEPT")"
> +fi
>  msg_info "conf: NFT_TEST_RANDOM_SEED=$NFT_TEST_RANDOM_SEED"
>  msg_info "conf: NFT_TEST_SHUFFLE_TESTS=$NFT_TEST_SHUFFLE_TESTS"
>  msg_info "conf: TMPDIR=$(printf '%q' "$_TMPDIR")"
> @@ -707,6 +718,7 @@ kernel_cleanup() {
>  echo ""
>  ok=0
>  skipped=0
> +skipped_as_fail=0
>  failed=0
>  
>  kmem_runs=0
> @@ -767,7 +779,7 @@ print_test_header() {
>  	align_text text right "${#s_idx}" "$testidx_completed"
>  	s_idx="$text/${#TESTS[@]}"
>  
> -	align_text text left 12 "[$status]"
> +	align_text text left 13 "[$status]"
>  	_msg "$msglevel" "$text $s_idx $testfile"
>  }
>  
> @@ -786,10 +798,19 @@ print_test_result() {
>  	elif [ "$rc_got" -eq 77 ] ; then
>  		((skipped++))
>  		result_msg_status="${YELLOW}SKIPPED$RESET"
> +		TESTS_SKIP_EXCEPT+=( "^$testfile$" )
>  	else
>  		((failed++))
>  		result_msg_level="W"
> -		if [ "$rc_got" -eq 121 ] ; then
> +		if [ "$rc_got" -eq 119 ] ; then
> +			# This means, the test passed, but it was matched by NFT_TEST_FAIL_ON_SKIP_EXCEPT regex.
> +			# The regex is expected to match *exactly* the tests that are skipped. An unexpected PASS
> +			# is also treated as a failure. Inspect NFT_TEST_FAIL_ON_SKIP_EXCEPT regex.
> +			result_msg_status="XPASS"
> +		elif [ "$rc_got" -eq 120 ] ; then
> +			((skipped_as_fail++))
> +			result_msg_status="FAIL-SKIP"
> +		elif [ "$rc_got" -eq 121 ] ; then
>  			result_msg_status="CHK DUMP"
>  		elif [ "$rc_got" -eq 122 ] ; then
>  			result_msg_status="VALGRIND"
> @@ -831,8 +852,14 @@ job_start() {
>  		print_test_header I "$testfile" "$testidx" "EXECUTING"
>  	fi
>  
> +	# NFT_TEST_FAIL_ON_SKIP_EXCEPT is already exported, if it happens to be set.
>  	NFT_TEST_TESTTMPDIR="${JOBS_TEMPDIR["$testfile"]}" \
> -	NFT="$NFT" NFT_REAL="$NFT_REAL" DIFF="$DIFF" DUMPGEN="$DUMPGEN" $NFT_TEST_UNSHARE_CMD "$NFT_TEST_BASEDIR/helpers/test-wrapper.sh" "$testfile"
> +	NFT="$NFT" \
> +	NFT_REAL="$NFT_REAL" \
> +	DIFF="$DIFF" \
> +	DUMPGEN="$DUMPGEN" \
> +	NFT_TEST_FAIL_ON_SKIP="$NFT_TEST_FAIL_ON_SKIP" \
> +	$NFT_TEST_UNSHARE_CMD "$NFT_TEST_BASEDIR/helpers/test-wrapper.sh" "$testfile"
>  	local rc_got=$?
>  
>  	if [ "$NFT_TEST_JOBS" -le 1 ] ; then
> @@ -896,12 +923,7 @@ echo ""
>  kmemleak_found=0
>  check_kmemleak_force
>  
> -failed_total="$failed"
> -if [ "$NFT_TEST_FAIL_ON_SKIP" = y ] ; then
> -	failed_total="$((failed_total + skipped))"
> -fi
> -
> -if [ "$failed_total" -gt 0 ] ; then
> +if [ "$failed" -gt 0 ] ; then
>  	RR="$RED"
>  elif [ "$skipped" -gt 0 ] ; then
>  	RR="$YELLOW"
> @@ -926,17 +948,24 @@ END_TIME="$(cut -d ' ' -f1 /proc/uptime)"
>  WALL_TIME="$(awk -v start="$START_TIME" -v end="$END_TIME" "BEGIN { print(end - start) }")"
>  printf "%s\n" "$WALL_TIME" "$START_TIME" "$END_TIME" > "$NFT_TEST_TMPDIR/times"
>  
> -if [ "$failed_total" -gt 0 -o "$NFT_TEST_KEEP_LOGS" = y ] ; then
> +if [ "${#TESTS_SKIP_EXCEPT[@]}" -gt 0 ] ; then
> +	printf '%s\n' "${TESTS_SKIP_EXCEPT[@]}" | sort
> +fi > "$NFT_TEST_TMPDIR/skip-if-fail-except"
> +
> +if [ "$failed" -gt 0 -o "$NFT_TEST_KEEP_LOGS" = y ] ; then
>  	msg_info "check the temp directory \"$NFT_TEST_TMPDIR\" (\"$NFT_TEST_LATEST\")"
>  	msg_info "   ls -lad \"$NFT_TEST_LATEST\"/*/*"
>  	msg_info "   grep -R ^ \"$NFT_TEST_LATEST\"/"
> +	if [ "${#TESTS_SKIP_EXCEPT[@]}" -gt 0 ] ; then
> +		msg_info "   generate XFAIL with NFT_TEST_FAIL_ON_SKIP_EXCEPT=\"\$(cat $NFT_TEST_LATEST/skip-if-fail-except)\""
> +	fi
>  	NFT_TEST_TMPDIR=
>  fi
>  
> -if [ "$failed" -gt 0 ] ; then
> +if [ "$failed" -gt 0 -a "$skipped_as_fail" -eq "$failed" ] ; then
> +	msg_info "Tests were skipped, but failed due to NFT_TEST_FAIL_ON_SKIP=y"
>  	exit 1
> -elif [ "$NFT_TEST_FAIL_ON_SKIP" = y -a "$skipped" -gt 0 ] ; then
> -	msg_info "some tests were skipped. Fail due to NFT_TEST_FAIL_ON_SKIP=y"
> +elif [ "$failed" -gt 0 ] ; then
>  	exit 1
>  elif [ "$ok" -eq 0 -a "$skipped" -gt 0 ] ; then
>  	exit 77
> -- 
> 2.41.0
> 
