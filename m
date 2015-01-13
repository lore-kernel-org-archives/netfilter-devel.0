From: Gustavo Zacarias <gustavo@zacarias.com.ar>
Subject: Re: [iptables PATCH] configure: disable connlabel for static builds
Date: Tue, 13 Jan 2015 16:40:54 -0300
Message-ID: <54B574C6.1040108@zacarias.com.ar>
References: <1421156780-30315-1-git-send-email-gustavo@zacarias.com.ar> <20150113193252.GH27216@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www.zacarias.com.ar ([62.210.192.172]:35664 "EHLO
	www.zacarias.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbbAMTlJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Jan 2015 14:41:09 -0500
In-Reply-To: <20150113193252.GH27216@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 01/13/2015 04:32 PM, Florian Westphal wrote:

> Gustavo Zacarias <gustavo@zacarias.com.ar> wrote:
>> Disable connlabel for purely static builds since it pulls in libdl which
>> isn't available in such cases causing build breakage.
> 
> What do you mean by 'purely static builds'?
> In any case, current iptables master
> 
> ./configure --disable-shared --enable-static && make
> 
> fails to build with your patch applied since configure thinks
> that neither libmnl nor libfntnl are present.
> 
> I also don't understand why connlabel should not be built with above
> configure options, care to elaborate?

See
http://autobuild.buildroot.net/results/b45/b45df862a5c7e0a45017d6be33a818c98489b663/
(build-end.log)

That's the precise build failure which is triggered when
libnetfilter_conntrack is around.
When it's not around (nfconntrack=0, from PKG_CHECK_MODULES) it won't
try to build it and the result is a proper purely-static build.
Hence i set it that way in the patch when the user explicitly says
--disable-shared.
Purely-static is a toolchain where there is no dlfcn.h and libdl, not
something you would see from (e)glibc but normal for uClibc.

I haven't tried on iptables master which adds nft functionality yet, but
this fixes it for 1.4.21.

Regards.
