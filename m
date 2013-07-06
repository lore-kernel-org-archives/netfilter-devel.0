From: Phil Oester <kernel@linuxace.com>
Subject: Re: ip6tables-save LOG target output is different to iptables-save
Date: Fri, 5 Jul 2013 21:41:21 -0700
Message-ID: <20130706044121.GA15084@linuxace.com>
References: <CAC+BxFrOpO8UWdd4xa146AsZN52A2hSOmaTiyvOmQK-qktzVPg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Scott Baillie <scott.a.baillie@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:63235 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab3GFElY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 6 Jul 2013 00:41:24 -0400
Received: by mail-pd0-f176.google.com with SMTP id t12so2471840pdi.7
        for <netfilter-devel@vger.kernel.org>; Fri, 05 Jul 2013 21:41:23 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAC+BxFrOpO8UWdd4xa146AsZN52A2hSOmaTiyvOmQK-qktzVPg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jul 06, 2013 at 01:42:00PM +1000, Scott Baillie wrote:
> Hi All,
> 
> I am using  ip6tables-save  version  v1.4.14 and have noticed
> that the output of the LOG target is different to the output from
> iptables-save  version  v1.4.14.

Yes, quotes are not included if there is no whitespace, but it is
quoted if whitespace is present:

-A INPUT -s 1.2.3.4/32 -j LOG --log-prefix "foo doo"
-A INPUT -s 1.2.3.4/32 -j LOG --log-prefix foo

Is this an issue?

Phil
