Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Wz2XUWAc"
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB151C3
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Dec 2023 08:25:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=/9cFyte5U22/lrZP2LlPio8owsezknpYoSNVGmaOT3k=; b=Wz2XUWAcbuDf+OPM9L+CJCrdc8
	8eF24gJVQCDhlg3J81Um+wwWFCCDokO/HNkWWa15v11oU5fTM5TXddfYW0Q4NjdcPi7dT/bW4MUWU
	RyFZZLn4pPcpChLXDSAFY6mVCrIqMw301J/yeum3eMY94PaotNGAw0Pdnf+d/HLzh0P7eksyqs5ph
	0EXX6HUmFnw9sPSlTQHrVHC8XM0tXCVfpAwMF8vpVrRLfcu1GSYt2WsNk6DoL0G6ZPrY+2/Xkvp6c
	NpoLxK7QKdmlIHXNh0GpOxqTzIWfUyhURzyVRrP5SegmaPHBO6gPQjxMZbTRzlaJVKfOtKuTf3OtO
	IjwtvCgA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1rAYEw-0003uQ-0o
	for netfilter-devel@vger.kernel.org; Tue, 05 Dec 2023 17:25:42 +0100
Date: Tue, 5 Dec 2023 17:25:41 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 00/13] ebtables: Use the shared commandline
 parser
Message-ID: <ZW9PBXkQBd0NDOMz@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org
References: <20231129132827.18166-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231129132827.18166-1-phil@nwl.cc>

On Wed, Nov 29, 2023 at 02:28:14PM +0100, Phil Sutter wrote:
> This series converts do_commandeb() and do_commandeb_xlate() to call
> do_parse() from xshared.c instead of iterating over argv themselves.
> 
> Patches 1-6 prepare the shared (parser) code for use by ebtables.
> Patches 7-11 prepare ebtables code for the following integration in
> patch 13. Patch 12 is a minor refactoring in xshared but fits fine right
> before the merge as the introduced helper function is called two more
> times by it.
> 
> Phil Sutter (13):
>   xshared: do_parse: Skip option checking for CMD_DELETE_NUM
>   xshared: Perform protocol value parsing in callback
>   xshared: Turn command_default() into a callback
>   xshared: Introduce print_help callback (again)
>   xshared: Support rule range deletion in do_parse()
>   xshared: Support for ebtables' --change-counters command
>   ebtables{,-translate}: Convert if-clause to switch()
>   ebtables: Change option values to avoid clashes
>   ebtables: Pass struct iptables_command_state to print_help()
>   ebtables: Make 'h' case just a call to print_help()
>   ebtables: Use struct xt_cmd_parse
>   xshared: Introduce option_test_and_reject()
>   ebtables: Use do_parse() from xshared

Series applied.
