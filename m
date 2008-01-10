From: Patrick McHardy <kaber@trash.net>
Subject: Re: kernel-source required?
Date: Thu, 10 Jan 2008 16:50:46 +0100
Message-ID: <47863ED6.2000206@trash.net>
References: <Pine.LNX.4.64.0801091826410.29244@fbirervta.pbzchgretzou.qr> <200801100922.m0A9MW2Z011677@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: jengelh@computergmbh.de, netfilter-devel@vger.kernel.org
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57732 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129AbYAJPzL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Jan 2008 10:55:11 -0500
In-Reply-To: <200801100922.m0A9MW2Z011677@toshiba.co.jp>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Yasuyuki KOZAKAI wrote:
> From: Jan Engelhardt <jengelh@computergmbh.de>
> Date: Wed, 9 Jan 2008 18:30:36 +0100 (CET)
> 
>> just now as an IRC user posted about a compilation error, the only 
>> situation that I could think of to load to this error was a missing 
>> kernel source tree.
>> Since many Xtables header files are copied to the iptables source tree, 
>> yet `make KERNEL_DIR=somethinginvalid` gives a compiler error because it 
>> cannot find <linux/compiler.h> (required by ip_tables.h).
> 
> I wonder why recent (at least, Fedora Core 7) distributed kernel header
> package for user programs does not include /usr/include/linux/compiler.h .

Debian doesn't have it either.

>> So I wonder, do we actually support building iptables without a 
>> kernel source tree?
> 
> I prefer to keep people easy to try newer iptables as possible.
> We can add include/linux/compiler.h to iptables or remove __user, etc. from
> headers of iptables.

Or simply define the missing annotations in xtables.h.

