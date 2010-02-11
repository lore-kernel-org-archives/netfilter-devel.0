From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: fix mangle tables back
Date: Thu, 11 Feb 2010 18:42:32 +0100
Message-ID: <4B744188.1080902@trash.net>
References: <20100211161235.GA4099@x200> <alpine.LSU.2.01.1002111724250.11348@obet.zrqbmnf.qr> <4B743196.6020005@trash.net> <20100211171553.GB4099@x200> <4B743D60.1070407@trash.net> <20100211172715.GC4099@x200>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46883 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755882Ab0BKRmg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Feb 2010 12:42:36 -0500
In-Reply-To: <20100211172715.GC4099@x200>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Alexey Dobriyan wrote:
> On Thu, Feb 11, 2010 at 06:24:48PM +0100, Patrick McHardy wrote:
>> It looks correct to me. Will try to reproduce the crash
>> just to make sure.
> 
> Just CONFIG_NET_NS=y and it will crash.

Indeed. Patch applied, thanks Alexey.
