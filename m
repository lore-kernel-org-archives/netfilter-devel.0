Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44E6BD5D
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Nov 2023 03:46:23 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
	(envelope-from <n0-1@orbyte.nwl.cc>)
	id 1r7wXl-0003Om-0g; Tue, 28 Nov 2023 12:46:21 +0100
Date: Tue, 28 Nov 2023 12:46:21 +0100
From: Phil Sutter <phil@nwl.cc>
To: Jan Engelhardt <jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] man: proper roff encoding for ~ and ^
Message-ID: <ZWXTDX1nuwSc1d0t@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Jan Engelhardt <jengelh@inai.de>, netfilter-devel@vger.kernel.org
References: <20231125161326.77308-1-jengelh@inai.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231125161326.77308-1-jengelh@inai.de>

On Sat, Nov 25, 2023 at 05:12:50PM +0100, Jan Engelhardt wrote:
> Fixes: v1.8.10-28-g4b0c168a
> Signed-off-by: Jan Engelhardt <jengelh@inai.de>
> ---
> I thought I had read the groff_char manual, but perhaps too hastily.

Indeed, and nobody apparently tested the results - at least on my
system, neither \~ nor \^ produce a visible character with either man or
html output (produced by mandoc). I can't test PDF right now for some
font problem.

BTW: HTML output seems identical for both the replacements in this patch
and the plain unquoted characters. Even though groff_char claims
otherwise.

Cheers, Phil
