From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [xtables-addons] geoip in Debian 7 working fine (--> please
 update the distro matrix)
Date: Thu, 18 Oct 2012 19:57:26 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1210181956080.16834@nerf07.vanv.qr>
References: <k5gtj2$ou2$1@ger.gmane.org> <alpine.LNX.2.01.1210181915570.16412@nerf07.vanv.qr> <508040F0.4050006@mutluit.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: "U.Mutlu" <for-gmane@mutluit.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:53281 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932125Ab2JRR51 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Oct 2012 13:57:27 -0400
In-Reply-To: <508040F0.4050006@mutluit.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2012-10-18 19:48, U.Mutlu wrote:

> Jan Engelhardt wrote, On 10/18/2012 07:18 PM:
>> On Monday 2012-10-15 13:55, U.Mutlu wrote:
>>
>>> Hello,
>>> please update the matrix at
>>> http://xtables-addons.sourceforge.net/distro-support.php?p=kernel%7Ciptables%7Cxtables-addons%7Cxtables-geoip&d=.*
>>> for Debian 7 (wheezy), as geoip is working well in that distribution
>>> (the pkg "xtables-addons-common" from the debian repo must be installed).
>>
>> Debian does not provide a xtables-geoip package.
>
> As said, I've it working fine here, I used the following steps:

I believe you that you did get it to work. However, the table is 
expressly about distro-package availability (it even says so in big 
letters), and Debian simply does not have anything premade such that you 
could `apt-get install xtables-geoip` to retrieve a (more-or-less) 
recent version of the geoip db ready for use.
