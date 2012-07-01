From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [ANNOUNCE] ipset 6.13 released
Date: Sun, 01 Jul 2012 13:44:55 +0100
Message-ID: <4FF04647.7060807@googlemail.com>
References: <alpine.DEB.2.00.1206292201340.29738@blackhole.kfki.hu> <4FF02A93.8080603@googlemail.com> <alpine.DEB.2.00.1207011405160.2289@blackhole.kfki.hu> <4FF04038.4080306@googlemail.com> <alpine.DEB.2.00.1207011434010.2486@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:53920 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510Ab2GAMpG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 Jul 2012 08:45:06 -0400
In-Reply-To: <alpine.DEB.2.00.1207011434010.2486@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> Call it a bug, whatever. I won't change the meaning of src/dst for 
> hash:net,iface which then will break someone's working firewall after an 
> upgrade.
>   
In other words, you are not only intent on keeping this bug in the 
netfilter/kernel code, but willing to document it in a man page simply 
because of the remote possibility that someone somewhere may have been 
using hash:net,iface and decided to upgrade while not willing to change 
its configuration to put right something which was wrong in the first place?
