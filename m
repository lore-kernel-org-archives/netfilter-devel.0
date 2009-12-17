From: Patrick McHardy <kaber@trash.net>
Subject: Re: [stable] [PATCH -stable 01/02]: ipv6: reassembly: use seperate
 reassembly queues for conntrack and local delivery
Date: Thu, 17 Dec 2009 17:18:06 +0100
Message-ID: <4B2A59BE.2020208@trash.net>
References: <4B2A4B84.9070802@trash.net> <20091217161421.GA31911@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: stable@kernel.org, Linux Netdev List <netdev@vger.kernel.org>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>
To: Greg KH <greg@kroah.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47048 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759428AbZLQQSP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Dec 2009 11:18:15 -0500
In-Reply-To: <20091217161421.GA31911@kroah.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Greg KH wrote:
> On Thu, Dec 17, 2009 at 04:17:24PM +0100, Patrick McHardy wrote:
>> The following two patches for -stable fix some defragmentation bugs
>> in netfilter which can cause the kernel to crash in the bridge
>> netfilter code.
>>
>> Please apply, thanks.
> 
> To which -stable tree?  .32, .31, and/or .27?

The patch is based on .32, but the bug affects all versions of the
kernel.
