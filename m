From: "Anton VG" <anton.vazir@gmail.com>
Subject: Re: iptables performance and alternatives
Date: Thu, 15 May 2008 17:46:49 +0500
Message-ID: <c4b050a10805150546k245f09dldff9aa00a549c023@mail.gmail.com>
References: <200805151421.23862.anton.vazir@gmail.com>
	 <200805151557.28368.anton.vazir@gmail.com>
	 <alpine.LNX.1.10.0805151318020.16151@fbirervta.pbzchgretzou.qr>
	 <200805151629.22785.anton.vazir@gmail.com>
	 <alpine.LNX.1.10.0805151400140.16151@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: "Jan Engelhardt" <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:63186 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638AbYEOMqu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 May 2008 08:46:50 -0400
Received: by fg-out-1718.google.com with SMTP id 19so329359fgg.17
        for <netfilter-devel@vger.kernel.org>; Thu, 15 May 2008 05:46:50 -0700 (PDT)
In-Reply-To: <alpine.LNX.1.10.0805151400140.16151@fbirervta.pbzchgretzou.qr>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2008/5/15 Jan Engelhardt <jengelh@medozas.de>:
>
> On Thursday 2008-05-15 13:29, Anton wrote:
>
> prio and realtime sound quite the same :p
>

:) yea, just realtime has a little more prio than prio is :-D
i filed that you will note it :)

>>queues per , with 3 to use with lending/borrowing (main,
>
> Write your own module that sets the mark according to your taste, it is not
> that hard. I have a semibook ("big pdf") on that entitled "Writing your own
> Netfilter modules" on http://jengelh.medozas.de/. You can easily use IPMARK
> as a base.
>

I've looked at it few days ago, just feel that I have to be more brave
to touch kernel from inside :) Will get there sometime.
You are right from one side, the module with exactly fits to a need is
the best way,
But for the universal approach, in the ideal case, some changes in the
iptables storage and matching scheme
makes sense too... but having lots of matching targets and so on makes
question not so simple I feel...
