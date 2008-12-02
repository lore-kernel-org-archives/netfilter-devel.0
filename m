From: John Haxby <john.haxby@oracle.com>
Subject: Re: [PATCH] More secure SYSRQ for xtables-addons
Date: Tue, 02 Dec 2008 09:43:36 +0000
Message-ID: <49350348.1070008@oracle.com>
References: <492E926D.5020807@oracle.com> <493491D3.50708@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from acsinet11.oracle.com ([141.146.126.233]:39979 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbYLBJnw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Dec 2008 04:43:52 -0500
In-Reply-To: <493491D3.50708@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> John Haxby wrote:
>> Rationale:
>>
>> I want to be able to use SYSRQ to reboot, crash or partially diagnose 
>> machines that become unresponsive for one reason or another.   These 
>> machines, typically, are blades or rack mounted machines that do not 
>> have a PS/2 connection for a keyboard and the old method of wheeling 
>> round a "crash trolley" that has a monitor and a keyboard on it no 
>> longer works:  USB keyboards rarely, if ever, work because by the 
>> time the machine is responding only to a ping, udev is incapable of 
>> setting up a new keyboard.g/majordomo-info.html
>
> This module is starting to look kind of useful. Maybe its time for
> a resubmission for review and possibly merging once these patches
> are included.
>
That's nice to hear!

> If we were to merge it, it would also be good to get some feedback
> from the crypto guys about whether the chosen authentication scheme
> meets its claims.

I agree.   I've talked this through with some people, but it needs some 
proper thought.    The weaknesses that I've identified are these:

 * The password can be recovered with an off-line dictionary attack.  
This is mitigated by using a good salt: in my example in the man page I 
use a 96 bit salt (dd bs=12 count=1 if=/dev/urandom) which makes a 
pre-computed dictionary attack difficult without large resources.  
However, a normal exhaustive search using the common password cracking 
techniques will yield a poorly chosen password fairly quickly.

 * The sha-1 hash is thought to be weak under some circumstances which 
makes its use for new cryptographic applications inappropriate.   The 
weaknesses, however, seem to be that SHA-1 is not good for digital 
signatures, but it would seem good enough for this purpose.  On the 
other hand, making the hash algorithm a module parameter so that it can 
be swapped out should SHA-1 prove unsuitable is straightforward (and I 
should probably do that).

 * If two machines have the same password then the mechanism is subject 
to a simple replay attack.   An attacker simply needs to capture the 
packet and send it to each of the possible target machines and see which 
ones crash :-)

 * A replay attack is possible on a single machine if the clock goes 
backwards (for example, on a reboot if the hardware clock is not UTC and 
the system time is not correctly set on boot).

 * xt_SYSRQ spamming could cause a DoS attack: simply spewing an endless 
stream of requests could tie up enough CPU resources to cause trouble.


All these attacks can be mitigated by good practices: using good, random 
passwords; changing the password(s) after an usage episode; changing the 
password(s) frequently anyway and so on.   Of course, stopping access to 
port 9 (or whatever) at a boundary and limiting the frequency of 
xt_SYSRQ requests almost goes without saying.

jch
