From: Patrick McHardy <kaber@trash.net>
Subject: Re: Automatically load modules in iptables-save
Date: Thu, 19 Mar 2009 14:05:54 +0100
Message-ID: <49C24332.2020107@trash.net>
References: <20090316171014.GG31952@ralph.linux2go.dk> <20090319125532.GC20472@ralph.linux2go.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Soren Hansen <soren@ubuntu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34998 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbZCSNF5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Mar 2009 09:05:57 -0400
In-Reply-To: <20090319125532.GC20472@ralph.linux2go.dk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Soren Hansen wrote:
> On Mon, Mar 16, 2009 at 06:10:14PM +0100, Soren Hansen wrote:
>> Resubmitting as per
>> http://marc.info/?l=netfilter-devel&m=123722008913373&w=2
>>
>> If the iptables modules are not loaded when iptables-save is run,
>> iptables-save will fail, because it can't open the relevant files in
>> /proc.  This patch makes iptables-save attempt to load the modules, and
>> then retries.
> 
> Is this the correct list for this?

It is. The patch seems rather pointless though, if the module isn't
loaded, there's obviously nothing to save.

> If the iptables modules are not loaded when iptables-save is run,
> iptables-save will fail

What does "fail" mean in this context?
