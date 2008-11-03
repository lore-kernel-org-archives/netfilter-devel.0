From: Rick Jones <rick.jones2@hp.com>
Subject: Re: [Fwd: Re: Shortcuts to counting rules?]
Date: Mon, 03 Nov 2008 10:02:39 -0800
Message-ID: <490F3CBF.5090706@hp.com>
References: <490B46F0.4010100@hp.com>	<alpine.LNX.1.10.0810311906120.29079@fbirervta.pbzchgretzou.qr>	<490B544B.50903@hp.com> <alpine.LNX.1.10.0811010209040.23833@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:47215 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbYKCSCp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Nov 2008 13:02:45 -0500
In-Reply-To: <alpine.LNX.1.10.0811010209040.23833@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Friday 2008-10-31 19:54, Rick Jones wrote:
> 
>>>iptables-save | grep ^- | wc -l
>>
>>Here is where I cop to being a luddite who prefers straight C to calling
>>system() :)
> 
> 
> But there is no C library. And libiptc is so strongly internal that
> it does not fall under libraries-to-use.

I'm willing to code without a library, I just need to know how to parse 
the set of entries I suspect.

Someone in netfilter suggested the getsockopt() calls were part of the 
ABI, which implies what the getsockopt() calls return is reasonably 
"stable."  Is that actually the case, or can one not even ass-u-me the 
getsockopt() calls themselves are stable?

>>>And strace should not be taught that. We have seen at least one
>>>change of the interpretation of the binary stream.
>>
>>How about at least the option name(s) so it can present something other than
>>the 0x40/0x41 etc?
> 
> 
> I do not mind that. Turn to the strace maintainer about getting that
> implemented.

Will do.

rick jones
