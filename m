Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1326F3D8122
	for <netfilter-devel@vger.kernel.org>; Tue, 25 Aug 2026 10:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787654731; cv=none; b=Qit+VcyEWqQIBge5JEnWt5dFWjmQ8CFiucb3cARDQgljZe8OQwvAvU+FAdFw4oeIdrKpWwsoE9jsg5tZuqhB/tH/uJVpIB6VqWq3AqFrjKhg11xX0f5+nJKaQ5jlygDADeJBuLN/Im5Rfl6JwSxH7XjPglc+oTwfoQgL4Qb7NQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787654731; c=relaxed/simple;
	bh=wk9h9fdo9t7VTXW706CPc4Z4RLqQ5etxdCSE8oS/GgQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dkRg3ugXfX+FDcPEHw5ucG4oQcxTmPyZwiLZpnYjnQx7THaazQ1P/v/PuRjHcaufQOo4PAxint9FMBsxkQZPlaZzhXrDOSraUmke1Dd9oWUnUYvuYYfYalLMi3pVwIBEngpUlhIgJ9/tU6MdZgTyqHxQOlw4E2DCsQf0mqD+vJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 01C706027F; Tue, 25 Aug 2026 12:45:26 +0200 (CEST)
Date: Tue, 25 Aug 2026 12:45:26 +0200
From: Florian Westphal <fw@strlen.de>
To: Jiri Peska <jpeska@redhat.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] tests: shell: Add coverage for
 nf_connlabels_replace()
Message-ID: <ao1yRhyaA6_cfbsR@strlen.de>
References: <20260825102429.173237-1-jpeska@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260825102429.173237-1-jpeska@redhat.com>

Jiri Peska <jpeska@redhat.com> wrote:
> Signed-off-by: Jiri Peska <jpeska@redhat.com>
> ---
>  tests/shell/testcases/packetpath/ct_label_set |  27 ++++
>  .../packetpath/dumps/ct_label_set.json-nft    | 132 ++++++++++++++++++
>  .../packetpath/dumps/ct_label_set.nft         |  11 ++
>  3 files changed, 170 insertions(+)
>  create mode 100755 tests/shell/testcases/packetpath/ct_label_set
>  create mode 100644 tests/shell/testcases/packetpath/dumps/ct_label_set.json-nft
>  create mode 100644 tests/shell/testcases/packetpath/dumps/ct_label_set.nft

This fails for me in dump validation, diff is:

-               icmp type echo-request ip daddr 127.0.0.1 ct label set 1
-               icmp type echo-request ip daddr 127.0.0.1 ct label 1 counter name "labeled"
+               icmp type echo-request ip daddr 127.0.0.1 ct label set "bar"
+               icmp type echo-request ip daddr 127.0.0.1 ct label "bar" counter name "labeled"

This is caused by local configuration.  I'd remove the dump files here
before applying (and add a nodump file instead).

As the test explicitly checks counters in the script, it will still be
useful to assert match/nomatch.

What do you think?
