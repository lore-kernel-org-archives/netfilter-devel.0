Received: from a3.inai.de (a3.inai.de [144.76.212.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 074A017A314
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Apr 2025 07:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.212.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745567506; cv=none; b=r+GAU/SuQnH04fNEnaGDLnBbhH/iwg+ofxsBwbCXCmdFlObW+/P72wYd1rP3c/RWMiVa355+QCnV/iOzdjzyM+BIBqrz6gCuMH+5Juos0cA+23K0+6MTXB/++TycEdl1OML5pWhfbYxjsNXsUNY8QxlH6GKUZkKEnfjkDoZVzN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745567506; c=relaxed/simple;
	bh=TiVu/BAIq1c4wLzbnXULkIN5nDftrdgOxds4DFJRLXQ=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=lX9dBnauByQ8AZD2rvlmWQkz63Kk8WDPZ1QLHNhAZdfsiVQaU93YL9Z1kFnuzsJkO6UX7l6OFP0R3npP6lBzwkbg0C4YC0ucFwH6MNDsAWKs7IvTOGWpIra/dSu9fIOUWw00d38DOPM2OXC4F61bdWBan5X3CUpnQ03rwhwmlYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de; spf=pass smtp.mailfrom=inai.de; arc=none smtp.client-ip=144.76.212.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inai.de
Received: by a3.inai.de (Postfix, from userid 25121)
	id 813401003DC54A; Fri, 25 Apr 2025 09:46:15 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id 80FB811009AC98;
	Fri, 25 Apr 2025 09:46:15 +0200 (CEST)
Date: Fri, 25 Apr 2025 09:46:15 +0200 (CEST)
From: Jan Engelhardt <ej@inai.de>
To: Florian Westphal <fw@strlen.de>
cc: Sunny73Cr <Sunny73Cr@protonmail.com>, 
    "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>, 
    oss-security@lists.openwall.com
Subject: Re: Trailing dot in Cygwin filenames [was: failed to clone
 iptables,ipset,nftables]
In-Reply-To: <20250425062231.GA7332@breakpoint.cc>
Message-ID: <sqo7nqpr-151q-4sr4-1o40-r95r62179s29@vanv.qr>
References: <1EYtBL_6T4QRNdyaUOoY2OO_FLzCtCfv4Q7gBf28RHR_k_LB-t0IN5R7v12bgaOOSKputo826H9PZ-2EmksldVLnGVoXyMQVemTy3tMra10=@protonmail.com> <20250425062231.GA7332@breakpoint.cc>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Friday 2025-04-25 08:22, Florian Westphal wrote:

>Sunny73Cr <Sunny73Cr@protonmail.com> wrote:
>> error: invalid path 'src/json.'
>
>There is indeed a bogus file of that name, no idea
>why its there or why cygwin git chokes on it.

There is some prior record -
https://github.com/libgit2/libgit2/issues/6968

"foo" and "foo." are equivalent in DOS, and there is a normalization
phase from "foo." to "foo". This carried forward into contemporary
Windows cmd.exe, explorer.exe (File Explorer), the usual file access
APIs.

	echo abc >x
	echo def >y.

creates "y" not "y." in cmd.

But Cygwin does something unusual, it *actually* creates a file with
the 2-char sequence "y.", through whatever means. Explorer *shows* it
with the dot, but practially no application other than Cygwin can
open it, because all normal APIs and fs lookup mechanisms are
rummaging for "y" as per the earlier equivalance, and either

1. there is no file "y", so some programs can/may/will throw an error
2. or, come to think of it, there is an evil file (hi oss-security)

  [in cgwin]
  echo good >y
  echo evil >y.

If you now try to open "y." with notepad.exe from Explorer, you always 
get the "good" variant. Only inside Cygwin, e.g. with cat.exe, can "y" 
be distinguished from "y.".
