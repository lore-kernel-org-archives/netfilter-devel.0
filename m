From: Ed W <lists@wildgooses.com>
Subject: Re: Performance issue due to constant "modprobes"
Date: Fri, 08 Apr 2011 18:11:09 +0100
Message-ID: <4D9F41AD.5000503@wildgooses.com>
References: <4D9E45C2.7030805@wildgooses.com> <alpine.LNX.2.01.1104080212310.8883@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail1.nippynetworks.com ([91.220.24.129]:57958 "EHLO
	mail1.nippynetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739Ab1DHRLL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 Apr 2011 13:11:11 -0400
Received: from localhost (mail1.nippynetworks.com [127.0.0.1])
	by mail1.nippynetworks.com (Postfix) with ESMTP id 9FEC034032B
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Apr 2011 18:11:10 +0100 (BST)
Received: from mail1.nippynetworks.com ([127.0.0.1])
	by localhost (mail1.nippynetworks.com [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id 1inky5UmQuUS for <netfilter-devel@vger.kernel.org>;
	Fri,  8 Apr 2011 18:11:10 +0100 (BST)
Received: from Ed-Wildgooses-MacBook-Pro.local (office.nippynetworks.com [212.69.49.94])
	(Authenticated sender: edward@wildgooses.com)
	by mail1.nippynetworks.com (Postfix) with ESMTPSA id 41BB7340325
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Apr 2011 18:11:10 +0100 (BST)
In-Reply-To: <alpine.LNX.2.01.1104080212310.8883@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 08/04/2011 01:18, Jan Engelhardt wrote:

>> I have my kernel compiled without modules.  My modprobe takes a little
>> under 1ms to execute.  "iptables" appears to try and modprobe some 21
>> match/target modules.
> 
> This is your kernel calling modprobe through

I think not, or that you mean in a more roundabout fashion than I do?


>> I have dug through the code a bit and the first thing I notice is that
>> there is no --modprobe option actually parsed for, and the undocumented
>> "-M" option doesn't appear to pass through to xtables.c? (I thought
>> about simply lying about the modprobe binary name)
> 
> ip6tables.c:do_command6, near case 'M'.

I see the code, but "iptables -M /dev/null -h" still runs /sbin/modprobe
(lots)



>> The final thought is whether it's possible to notice that a module is
>> already loaded and skip the modprobe call altogether? (/proc/modules is
>> not enough because the module could be built into the kernel)
> 
> If ip_tables.ko is already loaded, iptc_init will not fail (per the 
> command above xtables_load_ko(xtables_modprobe_program, false), and 
> thus, modprobe will not be called - at least not by iptables.

Sure, but everything derived from xtables.c calls modprobe?

I'm sorry if I'm misunderstanding "who" calls modprobe, but the point is
that you can do a simple strace on "iptables -h" and without Maciej'
patch you will see a boatload of modprobe's...

Even with his patch then I still seem to get a load of modprobe's where
extra xtable matches are needed, and in my case (500Mhz processor),
modprobe is slow and also unnecessary because (nearly) everything is
compiled into the kernel

Avoiding modprobe would be very desirable in my case.  Any ideas?  (For
the moment I have just patched out the xtables.c insmod function, but
it's not very neat)

Thanks all

Ed W
