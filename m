Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B06DB47F73
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Mar 2024 16:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710347168; cv=none; b=aZIcS8FnreVX2/XLe8GF3xN1NUi7s0+T/8pDigIBKhg7Hso+clc/axBFEoddZyFdFEUmA7sPYgw/QnFPc23A5QBrgy2AQHPwg2lnzkWePLlTklMiW2vsNUCa4P1hb89RHGOPZ4ezqk0WW7yA01UvSIsiPZad0SCIAiJygQtURrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710347168; c=relaxed/simple;
	bh=TCMWoR0gOOX2eSZwjPZgLHDwoYxxQTL11BK/g412A80=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WdLxXDgkoVFY3d0nPINHshfSUBR/IB3BFVuTnxrAAQkaDjD6DZWQzrdR8oSJ58mQVy1WAtiz8YwCocvsDBnRRHSfrIEAIthyXvt2nVNwYbSyJDNZLJG9gGW/GCx/Vo7kGtqJ1vp40FyxnyJi/4ipn1ixpAt+HiE+B7BySmITs14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Wed, 13 Mar 2024 17:26:02 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] tests/py: remove flow table json test cases
Message-ID: <ZfHTmiJZ1JHn9XiJ@calendula>
References: <20240313141325.12547-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240313141325.12547-1-fw@strlen.de>

On Wed, Mar 13, 2024 at 03:13:22PM +0100, Florian Westphal wrote:
> ip(6)/flowtable.t tests fail both for normal and json mode.
> 
> WARNING: line 3: 'add rule ip test-ip input meter xyz size 8192 { ip saddr timeout 30s counter}': 'ip test-ip input' mismatches '[ payload load 4b @ network header + 12 => reg 1 ]'
> ip/lowtable.t.payload.got: WARNING: line 2: Wrote payload for rule meter xyz size 8192 { ip saddr timeout 30s counter}
> ip/flowtable.t: WARNING: line 5: 'add rule ip test-ip input meter xyz size 8192 { ip saddr timeout 30s counter}': 'meter xyz size 8192 { ip saddr timeout 30s counter}' mismatches 'update @xyz { ip saddr timeout 30s counter}'
> WARNING: line 3: 'add rule ip6 test-ip6 input meter acct_out size 4096 { meta iif . ip6 saddr timeout 600s counter }': 'ip6 test-ip6 input' mismatches '[ meta load iif => reg 1 ]'
> ip6/flowtable.t.payload.got: WARNING: line 2: Wrote payload for rule meter acct_out size 4096 { meta iif . ip6 saddr timeout 600s counter }
> ip6/flowtable.t: WARNING: line 5: 'add rule ip6 test-ip6 input meter acct_out size 4096 { meta iif . ip6 saddr timeout 600s counter }': 'meter acct_out size 4096 { iif . ip6 saddr timeout 10m counter }' mismatches 'update @acct_out { iif . ip6 saddr timeout 10m counter}'
> ip6/flowtable.t: ERROR: line 6: add rule ip6 test-ip6 input meter acct_out size 12345 { ip6 saddr . meta iif timeout 600s counter }: This rule should not have failed.
> ip6/flowtable.t: 2 unit tests, 2 error, 1 warning
> 
> Fix at least the non-json mode, I do not know how to fix up -j
> or wheter the failure is actually correct.

For the record:

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20240313162317.192314-1-pablo@netfilter.org/

I can change patch subject if you like instead to:

  tests: py: move meter tests to tests/shell

this transformation is hard to deal with from tests/py.
