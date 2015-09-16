From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] build: bump library versioning
Date: Wed, 16 Sep 2015 20:31:47 +0200 (CEST)
Message-ID: <alpine.LSU.2.20.1509162031310.13589@nerf40.vanv.qr>
References: <1442423567-12120-1-git-send-email-jengelh@inai.de> <20150916172836.GA29575@salvia> <20150916180048.GA4886@salvia> <20150916182251.GA3346@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:58526 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752565AbbIPSbs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Sep 2015 14:31:48 -0400
In-Reply-To: <20150916182251.GA3346@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2015-09-16 20:22, Pablo Neira Ayuso wrote:
>On Wed, Sep 16, 2015 at 08:00:48PM +0200, Pablo Neira Ayuso wrote:
>> On Wed, Sep 16, 2015 at 07:28:36PM +0200, Pablo Neira Ayuso wrote:
>[...]
>> Sorry, what you propose is fine actually. But this should be
>> LIBNFTNL_3 instead, I already bumped LIBVERSION from 2:0:2 to 3:0:3,
>> see 9e1e8052025fde.
>> 
>> If no concerns, I'll mangle your patch to make use LIBNFTNL_3 instead.
>
>I think your LIBNFTNL_4 is intentional, now we're at 3:0:3 after
>1.0.4, so to escape the current situation upcoming libnftnl-1.0.5
>should be 4:0:0, hence the LIBNFTNL_4 in the map file.

"Yes" again :)
