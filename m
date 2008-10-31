From: Rick Jones <rick.jones2@hp.com>
Subject: Re: [Fwd: Re: Shortcuts to counting rules?]
Date: Fri, 31 Oct 2008 11:54:03 -0700
Message-ID: <490B544B.50903@hp.com>
References: <490B46F0.4010100@hp.com> <alpine.LNX.1.10.0810311906120.29079@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from g4t0014.houston.hp.com ([15.201.24.17]:2528 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbYJaSyJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 31 Oct 2008 14:54:09 -0400
In-Reply-To: <alpine.LNX.1.10.0810311906120.29079@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Friday 2008-10-31 18:57, Rick Jones wrote:
> 
> 
>>The end goal here is to teach netperf how to get a count of
>>iptables rules in place in the kernel.  There was also a drifting
>>question of whether or not strace should be taught about the
>>getsockopt() options.
> 
> 
> iptables-save | grep ^- | wc -l

Here is where I cop to being a luddite who prefers straight C to calling 
system() :)

> And strace should not be taught that. We have seen at least one
> change of the interpretation of the binary stream.

How about at least the option name(s) so it can present something other 
than the 0x40/0x41 etc?

rick jones
