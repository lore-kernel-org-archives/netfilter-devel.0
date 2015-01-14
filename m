From: Gustavo Zacarias <gustavo@zacarias.com.ar>
Subject: Re: [iptables PATCH] configure: disable connlabel for static builds
Date: Wed, 14 Jan 2015 06:48:25 -0300
Message-ID: <54B63B69.1090003@zacarias.com.ar>
References: <1421156780-30315-1-git-send-email-gustavo@zacarias.com.ar> <20150113193252.GH27216@breakpoint.cc> <54B574C6.1040108@zacarias.com.ar> <alpine.LSU.2.11.1501140128030.6591@nerf60.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www.zacarias.com.ar ([62.210.192.172]:44356 "EHLO
	www.zacarias.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379AbbANJsi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Jan 2015 04:48:38 -0500
In-Reply-To: <alpine.LSU.2.11.1501140128030.6591@nerf60.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 01/13/2015 09:32 PM, Jan Engelhardt wrote:

>> That's the precise build failure which is triggered when
>> libnetfilter_conntrack is around.
> 
> The -ldl which appears in the command line, it suggests that it stems
> from libxtables.la. (Unless there is one in your libnetfilter_conntrack.la.)

It's coming from libnetfilter_conntrack.la from src/Makefile.am (hardcoded).
Not only that, you've also got -ldl in Libs.private in xtables.pc.in in
an unconditional way (iptables) but that's not the culprit at this point.
I'll send a revised patch against libnetfilter_conntrack unless there's
a good reason for getting it hardcoded there (other than static building
since killing it makes iptables build fine).
Florian: regarding iptables master it won't build static with nft
support enabled, i'll look into it, but at least it's an option that can
be easily disabled for the build, so no quick patches required.
Regards.

