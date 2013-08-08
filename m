From: Phil Oester <kernel@linuxace.com>
Subject: Re: state match incompatibilty across versions
Date: Wed, 7 Aug 2013 21:32:30 -0700
Message-ID: <20130808043230.GA22843@linuxace.com>
References: <CA+0KVf2e_Ce33SFJyK21LzLBhUhWzWdgaMje4ShZF7i7evGuMw@mail.gmail.com>
 <CA+0KVf0RDy0ub_R0t9Fn5-dBN2dRhZqu2+eRy36Xur7nF8EHoA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: "Laurence J. Lane" <ljlane@debian.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:59722 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616Ab3HHEcd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Aug 2013 00:32:33 -0400
Received: by mail-pa0-f46.google.com with SMTP id fa1so2926440pad.19
        for <netfilter-devel@vger.kernel.org>; Wed, 07 Aug 2013 21:32:32 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CA+0KVf0RDy0ub_R0t9Fn5-dBN2dRhZqu2+eRy36Xur7nF8EHoA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 07, 2013 at 09:28:49PM -0400, Laurence J. Lane wrote:
> I think I failed to explain the problem clearly. I'll try again.
> 
> If I use iptables 1.1.14 or 1.4.15 to create a match state rule,
> iptables 1.4.16+ binaries do not display the state information that is
> in the kernel.

Issue understood.  I posted a patch in the past few hours.  Can you verify
this fixes the issue for you?

Phil

