From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [iptables PATCH] configure: disable connlabel for static
 builds
Date: Wed, 14 Jan 2015 01:32:27 +0100 (CET)
Message-ID: <alpine.LSU.2.11.1501140128030.6591@nerf60.vanv.qr>
References: <1421156780-30315-1-git-send-email-gustavo@zacarias.com.ar> <20150113193252.GH27216@breakpoint.cc> <54B574C6.1040108@zacarias.com.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Gustavo Zacarias <gustavo@zacarias.com.ar>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares60.inai.de ([5.9.23.85]:33141 "EHLO ares60.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921AbbANAcb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Jan 2015 19:32:31 -0500
In-Reply-To: <54B574C6.1040108@zacarias.com.ar>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2015-01-13 20:40, Gustavo Zacarias wrote:
>> 
>> ./configure --disable-shared --enable-static && make
>> 
>See
>http://autobuild.buildroot.net/results/b45/b45df862a5c7e0a45017d6be33a818c98489b663/
>(build-end.log)
>
>That's the precise build failure which is triggered when
>libnetfilter_conntrack is around.

The -ldl which appears in the command line, it suggests that it stems
from libxtables.la. (Unless there is one in your libnetfilter_conntrack.la.)
