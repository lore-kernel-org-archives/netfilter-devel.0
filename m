From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] xt_recent: use proc_create_data()
Date: Thu, 16 Oct 2008 16:08:32 +0200
Message-ID: <48F74AE0.4030105@trash.net>
References: <20081015041326.GB24058@x200.localdomain> <48F73DBE.5040808@trash.net> <20081016140320.GB17872@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35102 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852AbYJPOIg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Oct 2008 10:08:36 -0400
In-Reply-To: <20081016140320.GB17872@x200.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Alexey Dobriyan wrote:
> On Thu, Oct 16, 2008 at 03:12:30PM +0200, Patrick McHardy wrote:
>> Alexey Dobriyan wrote:
>>> It's tiny little bit safer because ->data always appears initialized.
>> These don't seem to actually fix anything,
> 
> It does ;-) Initializing ->data after proc_create() when proc entry
> becomes fully visible and accessible is no-no.

Thanks for the explanation, applied.
