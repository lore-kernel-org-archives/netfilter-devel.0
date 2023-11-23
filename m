Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CA62D46
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Nov 2023 08:55:50 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
	(envelope-from <n0-1@orbyte.nwl.cc>)
	id 1r6CzV-0003eV-0I
	for netfilter-devel@vger.kernel.org; Thu, 23 Nov 2023 17:55:49 +0100
Date: Thu, 23 Nov 2023 17:55:49 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 0/6] Extend guided option parser for use by
 arptables
Message-ID: <ZV+EFba8u1Qp7KJq@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org
References: <20231122215301.15725-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231122215301.15725-1-phil@nwl.cc>

On Wed, Nov 22, 2023 at 10:52:55PM +0100, Phil Sutter wrote:
> Patch 1 is unrelated to the remaining ones, but fits into a series about
> libxtables option parser.
> 
> Patch 2 fixes for parsing of IP addresses with arptables, patches 3 and
> 4 enable users to parse integers in a fixed base.
> 
> Patches 5 and 6 then migrate more extensions over to using the guided
> option parser.
> 
> Phil Sutter (6):
>   libxtables: Combine the two extension option mergers
>   libxtables: Fix guided option parser for use with arptables
>   libxtables: Introduce xtables_strtoul_base()
>   libxtables: Introduce struct xt_option_entry::base
>   extensions: libarpt_mangle: Use guided option parser
>   extensions: MARK: arptables: Use guided option parser

Series applied.
