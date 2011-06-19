From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: ebtables-2.0.9-2 libebetc PHONY
Date: Sun, 19 Jun 2011 13:36:04 +0200
Message-ID: <4DFDDF24.4090508@pandora.be>
References: <20110609231131.GA6508@lemonhead.scabb>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Bertrand Jacquin <beber@meleeweb.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from brigitte.telenet-ops.be ([195.130.137.66]:44091 "EHLO
	brigitte.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464Ab1FSLgH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 19 Jun 2011 07:36:07 -0400
In-Reply-To: <20110609231131.GA6508@lemonhead.scabb>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 10-06-11 01:11, Bertrand Jacquin wrote:
> Hi,
>
> ebtables-v2.0.9-2 declare libebetc.so as PHONY. I'm wondering why. In my
> case I'm cross-compiling it and define CC only for compilation. So when
> running "make install" libebtc.so is one more time builded without CC
> defined, so it failed :
>
> Attached a patch to not PHONY libebtc.so
>
I've applied an altered version of your patch: I've changed the libebtc 
target to libebtc.so

Thanks,
Bart


-- 
Bart De Schuymer
www.artinalgorithms.be

