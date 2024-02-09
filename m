Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D6ED69DE5
	for <netfilter-devel@vger.kernel.org>; Fri,  9 Feb 2024 15:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707492915; cv=none; b=bWRBuehpFUcGWex1T1TrHSkQxJiq+u0NSjX1S3N8vejnjdxMkKFwaMi8dGQ8EVE9YNDpTg6d/9t/k9uqbZQRzBuJ76PnINtoEfV3Z2tgrC5OnEgx+kqs9LRzHHVqO3fzdtDHfcCQ20BcJlFRBUYi+a77ggLXtVIRf3YbdAf8Cvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707492915; c=relaxed/simple;
	bh=1Uu6zJXN5fzTpNjGHGEYaqbDvO5qSutMbUG3h9Y+diY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K1qyNcAOtnk4sU/YI/KKnWbjIEbe+nhM4ARlTCcumHw5ffwt1GNA1+XkciW7vWOCulfeE2TpiVA+Go42cjO0494GNy+vrOrBG2RFIG9AQsPNN9RjnNR0QZJeVyzrSZ0a5haWqMSfYqsvZ5VMwFFUOseKdwKv3TurFVrb5U9lpFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=aNhtAS1K; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="aNhtAS1K"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=132t719Zq/ckgBEBBHwLnRzRsfdbQtVabjkBDxavbls=; b=aNhtAS1KiGFkqYo38fYX9YVxgE
	ZUWYUNS8uLLJQ9ZpA4H5sVDkCj71z8M6MSlLsxA21dIkrlw+U8Dv06MlLBajeYMnTDVMOdltGqGvF
	3Q7Gqy56BvEWa0LzOndRvt8BSan+PsTRZGd99XV9HyX3FkLo52wnEgYvx1mDEuXF6PM7AfLM+/JK0
	7SeHH6aKg8m+c0Xy/fClJPeMLqlptuCjw+B/AZyA1D27Wy6XsOTL6FCMb5nAp7IFyMhg/vppshLb0
	4uqOlAjey94F6doIvY0ACWsaqmHwAJwtlRaukstV+75e2ZSjf7Jir1iVUjpGxmzU5JLHT4rioRB/4
	I/9JdqyA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97)
	(envelope-from <phil@nwl.cc>)
	id 1rYSu8-000000000xs-16XP;
	Fri, 09 Feb 2024 16:35:04 +0100
Date: Fri, 9 Feb 2024 16:35:04 +0100
From: Phil Sutter <phil@nwl.cc>
To: Thomas Haller <thaller@redhat.com>
Cc: NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH 1/1] tests/shell: no longer support unprettified
 ".json-nft" files
Message-ID: <ZcZGKMRKgvWsIanx@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Thomas Haller <thaller@redhat.com>,
	NetFilter <netfilter-devel@vger.kernel.org>
References: <20240209121147.2294486-1-thaller@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240209121147.2294486-1-thaller@redhat.com>

On Fri, Feb 09, 2024 at 01:10:39PM +0100, Thomas Haller wrote:
> By now, all ".json-nft" files are prettified and will be generated in
> that form.
> 
> Drop the fallback code that accepts them in the previous form.
> 
> Signed-off-by: Thomas Haller <thaller@redhat.com>

Patch applied, thanks. Some comments though:

> @@ -211,16 +206,8 @@ if [ "$rc_test" -ne 77 -a "$dump_written" != y ] ; then
>  		fi
>  	fi
>  	if [ "$NFT_TEST_HAVE_json" != n -a -f "$JDUMPFILE" ] ; then
> -		JDUMPFILE2="$NFT_TEST_TESTTMPDIR/json-nft-pretty"
> -		json_pretty "$JDUMPFILE" > "$JDUMPFILE2"
> -		if cmp "$JDUMPFILE" "$JDUMPFILE2" &>/dev/null ; then
> -			# The .json-nft file is already prettified. We can use
> -			# it directly.
> -			rm -rf "$JDUMPFILE2"
> -			JDUMPFILE2="$JDUMPFILE"
> -		fi
> -		if ! $DIFF -u "$JDUMPFILE2" "$NFT_TEST_TESTTMPDIR/ruleset-after.json-pretty" &> "$NFT_TEST_TESTTMPDIR/ruleset-diff.json" ; then
> -			show_file "$NFT_TEST_TESTTMPDIR/ruleset-diff.json" "Failed \`$DIFF -u \"$JDUMPFILE2\" \"$NFT_TEST_TESTTMPDIR/ruleset-after.json-pretty\"\`" >> "$NFT_TEST_TESTTMPDIR/rc-failed-dump"
> +		if ! $DIFF -u "$JDUMPFILE" "$NFT_TEST_TESTTMPDIR/ruleset-after.json-pretty" &> "$NFT_TEST_TESTTMPDIR/ruleset-diff.json" ; then
> +			show_file "$NFT_TEST_TESTTMPDIR/ruleset-diff.json" "Failed \`$DIFF -u \"$JDUMPFILE\" \"$NFT_TEST_TESTTMPDIR/ruleset-after.json-pretty\"\`" >> "$NFT_TEST_TESTTMPDIR/rc-failed-dump"

When playing with with changes to avoid the ~200 column lines this patch
adds, I checked what show_file actually print in addition to the
contents of ruleset-diff.json. It is (from one random example on disk):

| Failed `/usr/bin/diff -u "/tmp/nft-test.20240208-164915.277.rXP2ui/test-testcases-sets-0049set_define_0.79/json-nft-pretty" "/tmp/nft-test.20240208-164915.277.rXP2ui/test-testcases-sets-0049set_define_0.79/ruleset-after.json-pretty"`

The only non-trivial data this contains is the temp dir name
(/tmp/nft-test.20240208-164915.277.rXP2ui) and the test name
(test-testcases-sets-0049set_define_0.79). Said line yet stems from
/tmp/nft-test.20240208-164915.277.rXP2ui/test-testcases-sets-0049set_define_0.79/rc-failed-dump
so all this info is present in the file's path already.

Moreover, the diff's header in that file states the full paths to the
diffed files again. This is too much redundant data or noise IMO. So
much, I'd axe the whole show_file() stuff.

Cheers, Phil
