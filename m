From: Florian Westphal <fw@strlen.de>
Subject: Re: [iptables PATCH] configure: disable connlabel for static builds
Date: Tue, 13 Jan 2015 20:32:52 +0100
Message-ID: <20150113193252.GH27216@breakpoint.cc>
References: <1421156780-30315-1-git-send-email-gustavo@zacarias.com.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Gustavo Zacarias <gustavo@zacarias.com.ar>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:55857 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751004AbbAMTcy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Jan 2015 14:32:54 -0500
Content-Disposition: inline
In-Reply-To: <1421156780-30315-1-git-send-email-gustavo@zacarias.com.ar>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Gustavo Zacarias <gustavo@zacarias.com.ar> wrote:
> Disable connlabel for purely static builds since it pulls in libdl which
> isn't available in such cases causing build breakage.

What do you mean by 'purely static builds'?
In any case, current iptables master

./configure --disable-shared --enable-static && make

fails to build with your patch applied since configure thinks
that neither libmnl nor libfntnl are present.

I also don't understand why connlabel should not be built with above
configure options, care to elaborate?

