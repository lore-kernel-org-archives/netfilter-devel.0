From: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Subject: Re: Conntrack Events Performance - Multipart Messages?
Date: Fri, 25 Jul 2008 09:44:55 +0100
Message-ID: <48899287.50402@gmx.ch>
References: <487E24FC.60700@gmx.ch> <487F18DA.7030208@netfilter.org> <487FFBEE.90409@trash.net> <4884B068.4050306@gmx.ch> <4884B270.5010104@trash.net> <4884CC17.3020905@gmx.ch> <488740E7.3040005@gmx.ch> <48874272.1020503@trash.net> <48875887.8040209@gmx.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:59768 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755470AbYGYIo6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Jul 2008 04:44:58 -0400
In-Reply-To: <48875887.8040209@gmx.ch>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fabian Hugelshofer wrote:
> Patrick McHardy wrote:
>> The first thing to try would be to use sane allocation sizes
>> for the event messages. This patch doesn't implement it properly
>> (uses probing), but should be enough to test whether it helps.
> 
> Thanks a lot. This patch already decreased the CPU usage for ctevtest 
> from 85% to 44%. Sweet...

I just rerun the test. The 85% CPU usage was with 1700pps and 44% with 
1500pps. The wireless channel does not provide the same performance all 
the time and I did not pay attention to the packet rate.

Without the allocation patch and 1500pps the CPU usage is 56%. But 10% 
less is still quite nice.
