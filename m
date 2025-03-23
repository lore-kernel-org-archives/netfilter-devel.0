Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3749415E90
	for <netfilter-devel@vger.kernel.org>; Sun, 23 Mar 2025 10:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742724155; cv=none; b=kuiFhPuV/P8hNUnpsPT9JmHcLoTPIV71U23FZIS/OvGNpi2TbGSsZc/AJwwOBOyYNnCIvi0xlz4PKi+5HIcufNKnacljvzKJxh95bsA+mF+0+wy2XSuEpwDH7dYvit5+IWDB/EuQV0JHE71poiTOOAe7TAxrF7E/0hig41BTz3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742724155; c=relaxed/simple;
	bh=0uMTfHLjyeiqpyElYNVxZi5rMqdS9X8e21Js+o5oCCs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fGAUENLyH4G0uqVoM4sWVdsmLrK0TwbLt1TsXA++eaQBSMJUCRUpWgcA3XCTeBtG8Z4JgSaVbllfd41cIn4aRcQJxdPklU1Lt13vtLEYu3eXbFBp1YoxBzVTh3/WhLzZ4ASA9yFQ8QJROnR215hSMpPU+g4FtHuJagDfGg9DT/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=V6FQ7M7f; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Uv4bYHe3; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="V6FQ7M7f";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Uv4bYHe3"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 5969760385; Sun, 23 Mar 2025 11:02:30 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742724150;
	bh=cwGAKpMpqzBoa9Xv46vDknr8vkprFyHgBGCd2fmsFoY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V6FQ7M7fzuGqFd1gW1GtObGnM9EY/ZgSBKTUtZn/rSBEUH2zihKX9JEO/pTcu9nvX
	 2JjsU16TQKqnex/2KRzURJ1acdnZUwpsjaKFngkOBWasUAo6srWSijL5aV97dZBD1P
	 omd8hrAhdEgQMBAFdmpsC1LL2x5Zb0VRbYkNNbXQXw7F3++graE8NkptLkiDMAd76I
	 mIEYCyQU6CRzYxOQeL2TWVWH/+tJes+1pqUqNG8Fguzo784p7W+3LRekMAlWHx5hfl
	 SksDVUscV3gabjpaEL6O/ZM99nIEFITgY4m3I1r95/0/h2ZhgwMOHKHuQQjHegtiI4
	 tBdIlio/GFzgQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 6C8A16037B;
	Sun, 23 Mar 2025 11:02:29 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742724149;
	bh=cwGAKpMpqzBoa9Xv46vDknr8vkprFyHgBGCd2fmsFoY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Uv4bYHe3Y0j7v8n3GmR6K5s7n6H7MruRHQX0NtKZiUh7SLUXubXblcxD+/pXatR+5
	 jRax//Rp+yYxXm8UOTRJ/YdLM99qmIhMsm6rm6TRU4MUeOK351xEGzYod3cjMiAUam
	 jLJvfQxdj9z5IO8j5CFqkCQ+Z9eNACbsA5ACm7XMaoA/eUwVEbZWP1iiGaDuKEDeCe
	 M8kUveG3gduGgseXioN542zF3n+APmboH2s5B8fQknZRF0GrRF8pR1ERYCnwCb40wg
	 mCrHU3a2YIwGYwmMmjtjgnJUWNHKGvwx61MsA7cceaO8WNo8mei2MhjLe9Q20U8rGG
	 piJaJIe7nafnQ==
Date: Sun, 23 Mar 2025 11:02:26 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Antonio Ojea <aojea@google.com>
Cc: Florian Westphal <fw@strlen.de>, Eric Dumazet <edumazet@google.com>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v4] selftests: netfilter: conntrack respect reject rules
Message-ID: <Z9_cDLTSaGeXcG5X@calendula>
References: <20250318094138.3328627-1-aojea@google.com>
 <20250318163529.3585425-1-aojea@google.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250318163529.3585425-1-aojea@google.com>

Hi Antonio,

On Tue, Mar 18, 2025 at 04:35:29PM +0000, Antonio Ojea wrote:
> This test ensures that conntrack correctly applies reject rules to
> established connections after DNAT, even when those connections are
> persistent.
> 
> The test sets up three network namespaces: ns1, ns2, and nsrouter.
> nsrouter acts as a router with DNAT, exposing a service running in ns2
> via a virtual IP.
> 
> The test validates that is possible to filter and reject new and
> established connections to the DNATed IP in the prerouting and forward
> filters.

I am testing with different stable kernels to uncover timing issues.

With nf and nf-next kernels with instrumentions, **this works just fine**.

But I triggered a weird issue with Debian's 6.1.0-31-amd64:

# ./nft_conntrack_reject_established.sh
...
ERROR: backend filter-ip6: fail to connect to [dead:2::99]:8080
ERROR: backend filter-ip6: fail to connect over the established connection to [dead:4::a]:8080
ERROR: backend filter-ip6: fail to connect to [dead:4::a]:8080
ERROR: backend filter-ip6: fail to connect over the established connection to [dead:4::a]:8080
ERROR: backend filter-ip6: fail to connect to [dead:2::99]:8080

interestingly if I reversed the order, ie. I run ipv6 before ipv4
test, then ipv4 fails:

for testname in "${!testcases[@]}"; do
-      test_conntrack_reject_established "ip" "$testname" "${testcases[$testname]}"
       test_conntrack_reject_established "ip6" "$testname" "${testcases[$testname]}"
+      test_conntrack_reject_established "ip" "$testname" "${testcases[$testname]}"
done

also, running standalone ipv4 test, ie.:

for testname in "${!testcases[@]}"; do
      test_conntrack_reject_established "ip" "$testname" "${testcases[$testname]}"
done

or ipv6 test, ie.:

for testname in "${!testcases[@]}"; do
      test_conntrack_reject_established "ip6" "$testname" "${testcases[$testname]}"
done

works perfectly fine.

Hm, where is the issue? I have to double check, maybe -stable 6.1 is
missing a backport fix.

Thanks.
