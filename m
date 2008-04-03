From: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 12/24] [NETFILTER]: xt_recent: IPv6 support
Date: Thu, 3 Apr 2008 08:56:18 -0700
Message-ID: <20080403155618.GA10574@suse.de>
References: <1207134726-28689-1-git-send-email-jengelh@computergmbh.de> <2719780f6463107cf0a6097799f042d5d4062d59.1207134547.git.jengelh@computergmbh.de> <47F4DA91.2080108@trash.net> <alpine.LNX.1.10.0804031541320.1301@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51656 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752AbYDCP42 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Apr 2008 11:56:28 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0804031541320.1301@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 03, 2008 at 03:43:19PM +0200, Jan Engelhardt wrote:
>
> On Thursday 2008-04-03 15:24, Patrick McHardy wrote:
>> Jan Engelhardt wrote:
>>>  This updates xt_recent to support IPv6 handling. It is sort of a flag
>>>  day, as the new control directory is /proc/net/xt_recent with a new,
>>>  more strict protocol (the string you ought to write into
>>>  /proc/net/xt_recent/LIST). But on the other hand, I kept the binary
>>>  interface towards iptables (which is quite memory consuming I must
>>>  say) to keep the patch small.
>>
>> No flag days please, either keep ipt_recent as compat interface
>> (in case you want to share lists) or do something like hashlimit
>> and add one file per family, but no xt_recent file.
>
> I actually thought of using sysfs instead????? do you know if I can
> tie a sysfs file to a seq_file?

No you can not, as that would defeat the "one value per file" rule for
sysfs files.

thanks,

greg k-h
