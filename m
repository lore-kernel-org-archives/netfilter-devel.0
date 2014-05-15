From: Tejun Heo <tj@kernel.org>
Subject: Re: question about default values for per-namespace settings
Date: Thu, 15 May 2014 13:48:50 -0400
Message-ID: <20140515174850.GB20738@mtj.dyndns.org>
References: <20140512140706.GA22082@macbook.localnet>
 <cover.1399909529.git.vvs@openvz.org>
 <5370F781.7010909@parallels.com>
 <53711B21.1060309@pandora.be>
 <53712B0A.7060007@parallels.com>
 <53727246.4050306@pandora.be>
 <53748280.60906@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: containers@lists.linux-foundation.org,
	Bart De Schuymer <bdschuym@pandora.be>,
	netfilter-devel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Vasily Averin <vvs@parallels.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qc0-f180.google.com ([209.85.216.180]:44188 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561AbaEORsx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 May 2014 13:48:53 -0400
Received: by mail-qc0-f180.google.com with SMTP id i17so2373497qcy.39
        for <netfilter-devel@vger.kernel.org>; Thu, 15 May 2014 10:48:53 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <53748280.60906@parallels.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

On Thu, May 15, 2014 at 01:01:52PM +0400, Vasily Averin wrote:
> how do you think, which defaults should be used for per-namespace settings in general case
> and for per-netns sysctls especially? Do we have some common position about this or
> perhaps we already have some setting that allows to select desired behavior?

Unfortunately, I don't have much idea on the subject.  Serge and
others on the containers list should know a lot better than me.

Thanks.

-- 
tejun
