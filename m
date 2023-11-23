Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E9E1101
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Nov 2023 08:55:38 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
	(envelope-from <n0-1@orbyte.nwl.cc>)
	id 1r6CzI-0003e0-6t
	for netfilter-devel@vger.kernel.org; Thu, 23 Nov 2023 17:55:36 +0100
Date: Thu, 23 Nov 2023 17:55:36 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 00/12] Misc fixes (more or less)
Message-ID: <ZV+ECCVXCWcxwAx4@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org
References: <20231122130222.29453-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231122130222.29453-1-phil@nwl.cc>

On Wed, Nov 22, 2023 at 02:02:10PM +0100, Phil Sutter wrote:
> This is early fallout from working on a merge of ebtables commandline
> parsers with the shared one. It is a mix of actual bug fixes, small
> improvements and an implementaion of --change-counters command for
> ebtables-nft.
> 
> Phil Sutter (12):
>   Makefile: Install arptables-translate link and man page
>   nft-bridge: nft_bridge_add() uses wrong flags
>   xshared: struct xt_cmd_parse::xlate is unused
>   xshared: All variants support -v, update OPTSTRING_COMMON
>   xshared: Drop needless assignment in --help case
>   xshared: Drop pointless CMD_REPLACE check
>   tests: xlate: Print failing command line
>   ebtables: Drop append_entry() wrapper
>   ebtables: Make ebt_load_match_extensions() static
>   ebtables: Align line number formatting with legacy
>   xshared: do_parse: Ignore '-j CONTINUE'
>   ebtables: Implement --change-counters command

Series applied.
