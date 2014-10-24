From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCHv3 1/1 lnf-ct] qa: build unshared nfct environment
Date: Fri, 24 Oct 2014 11:24:41 +0200
Message-ID: <20141024092441.GB5675@breakpoint.cc>
References: <20140930090222.GA8470@gmail.com>
 <20140930101656.GE11709@breakpoint.cc>
 <20141007043812.GA2507@gmail.com>
 <20141007044007.GB2507@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:51516 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750888AbaJXJYn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Oct 2014 05:24:43 -0400
Content-Disposition: inline
In-Reply-To: <20141007044007.GB2507@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ken-ichirou MATSUZAWA <chamaken@gmail.com> wrote:
> nssocket forks and change netns pre-establishd by ip(8), serves its
> socket descriptor to parent via nssocket().  Since this socket is
> isolated, it can be used to create regression tests for conntrack.
> 
> This also adds a conntrack event testcase as a first user.
> A ct_echo_event.sh script is provided to build and run this test
> automatically:
> 
>   # ./qa/ct_echo_event.sh
>   make: Entering directory...
>   ...debug output like:
>       [NEW] tcp      6 2 SYN_SENT src=10.255.255.249 dst=10.255.255.250 sport...
>    [UPDATE] tcp      6 2 SYN_RECV src=10.255.255.249 dst=10.255.255.250 sport...
>   ...
>   [DESTROY] icmp     1 src=10.255.255.249 dst=10.255.255.250 type=8 code=0...
>   # echo $?
>   0

Applied, thanks for your patience.
