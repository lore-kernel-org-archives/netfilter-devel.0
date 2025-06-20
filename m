Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E01A7218AAB
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Jun 2025 09:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750411889; cv=none; b=S3VQ6GHlqlNZrhJce8KbeDhfpH89t0G0oKRWTfycuDn6J0KiW6h0SbfzZIBjGgKMSKRGGGU/dCCh5lGewLF54EUgFtpOOh43wtRJiniFDPlVEwUgS51NawSp/op6sWNJVXoHTZYY1pevEFbuODkYRd8dMcHR2BQRYA5fGGTUZ+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750411889; c=relaxed/simple;
	bh=HHbXH6F5zBNqVQj8WrMPsX6sxPjXyQdYDkAurelqgEo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uWI23zxEZ85LXE5dkTqHDpZ49IKsP2TNH+OyO4J4bXBeLairv4NGTU9yHI8nbnuDQgd00X1LWFiHRkEZSZUctGLrd/AjCkD3lsHnb9dTW/ETXXdSOTDcatAj0ZTqZIAzQI2nuzQGbaYBCRl7DMVc6r5oJAxysu0wRskBSmM9ABQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id DAE8D60B33; Fri, 20 Jun 2025 11:31:17 +0200 (CEST)
Date: Fri, 20 Jun 2025 11:31:17 +0200
From: Florian Westphal <fw@strlen.de>
To: Yi Chen <yiche@redhat.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] tests: shell: Add a test case to verify the limit
 statement.
Message-ID: <aFUqWOr8nxp1eHLl@strlen.de>
References: <20250617104128.27188-1-yiche@redhat.com>
 <aFNBzJOssxBN-ck4@strlen.de>
 <CAJsUoE0etJbdwHsHFHDnY1CkdmAXLJy7PunwQg9Me4n-AMPWmQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJsUoE0etJbdwHsHFHDnY1CkdmAXLJy7PunwQg9Me4n-AMPWmQ@mail.gmail.com>

Yi Chen <yiche@redhat.com> wrote:
> > export NFT_TEST_LIBRARY_FILE="$NFT_TEST_BASEDIR/helpers/lib.sh"
> > or whatever.  Then tests can do
> > . $NFT_TEST_LIBRARY_FILE
> 
> I prefer a single test script that can be executed independently.

Why?  Its possible to execute only one test via
tests/shell/run-tests.sh $filename

There is one exeception in the tree:
  tests/shell/testcases/transactions/30s-stress

... because that script can be passed a run-time, when
executed as part of the tests it runs for 30s but one
can do "tests/shell/testcases/transactions/30s-stress 600" etc.

Thats also why it does this:
  if [ x = x"$NFT" ] ; then
        NFT=nft
  fi

I missed this earlier when reviewing nft_nat test:

+       ip netns exec $R nft -f - <<-EOF

*ALL* "nft" should be replaced by "$NFT", so when the tests are executed
the locally built nft version, i.e. src/nft, is used, not the system binary.

Also:
tools/check-tree.sh |grep ftp
ERR:  "tests/shell/testcases/packetpath/nat_ftp" has no "tests/shell/testcases/packetpath/dumps/nat_ftp.{nft,nodump}" file

In this case it makes sense to add

  tests/shell/testcases/packetpath/dumps/nat_ftp.nodump

Can you send a followup patch?
Thanks, and sorry for missing this earlier.

> So, Would you accept something like:
> . $NFT_TEST_LIBRARY_FILE || . ${PWD%%/testcases*}/helpers/lib.sh?

Yes, but only if there is a compelling reason for the stand-alone
requirement.
