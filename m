Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A73D16F0FE
	for <netfilter-devel@vger.kernel.org>; Sat, 21 Jun 2025 11:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750505863; cv=none; b=KshY5rYy4ooN54SpcrW3TZKqYztTMBr/Y6zfX6cAdYbLCAckiR7FFYjpwsx9liD71S3ViRyCkInhLAjwLzLQdNNi79JECWZfCHq+WLjisrXwx3r3zPbX8Mk6Cmf5QpylDURkLWgIRqrsIzt68Sgrr63L0q+OSQru5+RgOGLjpiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750505863; c=relaxed/simple;
	bh=PcnpaX7dBfynzwDPo3iyXuKx69gugmzmKoQRsM+9wgA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S4oF0t9dzxtK6s5bNw6d7qaXhnZgnP703qNGOt3pxD/+oFziaAxMcMwcSwzZKvnjDjuIsZBQiJl1Tp2I0rwqWmsXx8VKKrhW7lwGX4+Pk03lLbm27j+Vhi7/cQEfk2UzyOxy92Kf9pqCXpB0AZLdD1z1JMrNUsT7roW8JOMmqso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A6BB96123A; Sat, 21 Jun 2025 13:37:31 +0200 (CEST)
Date: Sat, 21 Jun 2025 13:37:29 +0200
From: Florian Westphal <fw@strlen.de>
To: Yi Chen <yiche@redhat.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2] tests: shell: Verify limit statement with new test
 case.
Message-ID: <aFaZeVki08veClUU@strlen.de>
References: <20250617104128.27188-1-yiche@redhat.com>
 <20250620164730.50041-1-yiche@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250620164730.50041-1-yiche@redhat.com>

Yi Chen <yiche@redhat.com> wrote:
> 1. Add rate_limit test case.
> 2. Consolidate frequently used functions in helper/lib.sh
> 3. Introduce NFT_TEST_LIBRARY_FILE variable to source helper/lib.sh in
>    tests.
> 4. Replace sleep with wait_local_port_listen().
> 5. Other fixes: nft->$NFT; add dumps/*.nodump files

This is hard to review, can you split this in multiple patches
to make it easier?  We prefer to have one logical patch per change.
For example:

Patch1: don't use system nft binary
You can also add the .nodump file in this patch.

Patch 2:
Consolidate frequently used functions in helper/lib.sh

This also adds the NFT_TEST_LIBRARY_FILE environment variable
and would switch nat_ftp and flowtables to use it.

Patch 3: add and use wait_local_port_listen

This would add the helper and convert sleeps after listener to use
the new helper.

Patch 4:
Adds the new rate_limit test case and a nodump file.

I mean, the changes look good to me but I think its too big
for one single change.
