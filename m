From: "Greg Steuck" <greg@nest.cx>
Subject: Re: include/linux/netfilter.h after make headers_install is incomplete
Date: Wed, 21 May 2008 13:56:32 -0700
Message-ID: <a27c0c970805211356h4b13d001r6fa44bc36e74c3fd@mail.gmail.com>
References: <a27c0c970805161521k332fba8cg808d52396b5cdce5@mail.gmail.com>
	 <a27c0c970805201139i38e12d15ue807fc0239b1c10e@mail.gmail.com>
	 <a27c0c970805201144j12189201g9567460d4d3d8361@mail.gmail.com>
	 <20080520.142121.15017166.davem@davemloft.net>
	 <48340064.4090805@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "David Miller" <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:22989 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053AbYEUU4j (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 May 2008 16:56:39 -0400
Received: by yw-out-2324.google.com with SMTP id 9so1767147ywe.1
        for <netfilter-devel@vger.kernel.org>; Wed, 21 May 2008 13:56:33 -0700 (PDT)
In-Reply-To: <48340064.4090805@trash.net>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, May 21, 2008 at 3:58 AM, Patrick McHardy <kaber@trash.net> wrote:
> Greg, does this fix the problem?
>
>
> commit 34d75b526704f4aa4d71f57a81cc15d8b18f5555

It sure does. Thank you very much for such an immediate fix!

Thanks
Greg
-- 
nest.cx is Gmail hosted, use PGP for anything private. Key:
http://tinyurl.com/ho8qg
Fingerprint: 5E2B 2D0E 1E03 2046 BEC3 4D50 0B15 42BD 8DF5 A1B0
