From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: Re: First userspace, then module
Date: Thu, 16 Apr 2009 10:31:36 +0200
Message-ID: <17e3a8f80904160131t1a667f9dt1f9e5a4fc2c8a221@mail.gmail.com>
References: <49E6D7F8.6030507@gmail.com>
	 <alpine.LSU.2.00.0904160927340.2510@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:64796 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383AbZDPIbh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Apr 2009 04:31:37 -0400
Received: by fxm2 with SMTP id 2so273748fxm.37
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Apr 2009 01:31:36 -0700 (PDT)
In-Reply-To: <alpine.LSU.2.00.0904160927340.2510@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 16, 2009 at 9:28 AM, Jan Engelhardt <jengelh@medozas.de> wrote:
>
> On Thursday 2009-04-16 09:02, Kristian Evensen wrote:
>>
>> I am playing around with an idea for a module that will manipulate the packets
>> in userspace before passing them on to the xtables module. In other words,
>> there will be two rules in iptables (in the samle table) and after userspace is
>> done with the packet, it will be passed onto the next rule.
>
> Not possible. But you can have it reenter at the start using
> NF_REPEAT, I think.

Ok, thank you. I guess the best way then is to try and somehow mark
the packet, make it reenter and have the other rule higher up. This
rule will then also require a match on mark.

-Kristian
