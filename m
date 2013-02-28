From: Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: Extending class handle from 16bit to 32bit
Date: Thu, 28 Feb 2013 13:52:09 -0800
Message-ID: <20130228135209.1f82c7b3@nehalam.linuxnetplumber.net>
References: <CAN==1RrDHivRrzE1FKcDykRkgh2Obp+XC+5NEeuOE0NWJ=cn_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Karel Rericha <karel@maxtel.cz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-da0-f48.google.com ([209.85.210.48]:63263 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755450Ab3B1VwN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Feb 2013 16:52:13 -0500
Received: by mail-da0-f48.google.com with SMTP id w4so1045223dam.35
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Feb 2013 13:52:12 -0800 (PST)
In-Reply-To: <CAN==1RrDHivRrzE1FKcDykRkgh2Obp+XC+5NEeuOE0NWJ=cn_g@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 28 Feb 2013 14:49:28 +0100
Karel Rericha <karel@maxtel.cz> wrote:

> Hello,
> 
> we are about to hit the 16bit limit for number of qdisc classes (we
> have over 40k classes in one qdisc). Currently there is 32bit handle,
> which htb and hfsc interpret as 16bit qdisc and 16bit class. We would
> like to extend the 16bit class handle and considering two approaches:
> 
> a) low effort
> Fork hfsc and in forked hfsc interpret 32bit handle as 8bit qdisc and
> 24bit class.
> - not "clean" solution, no chance to accept to mainstream IMHO
> - requires just fork hfsc and add support for forked hfsc to iptables ???
> 
> b) extensive way
> Extend handle to 64bit, intepret as 32bit qdisc and 32bit class.
> - need to touch all qdisc to work with 64bit handle
> - same apply for iptables, make it work with 64bit handle
> - add some compatibility layer for software depending on 32bit ?
> - what about different architectures than x86 ?
> 
> Does anyone have any idea/experience how to solve this ?
> 
> We are open to offer bounty for actuall programming work as soon as
> the right way will be chosen.
> 
> Thanks for suggestions,
> 
> Karel Rericha
> ISP Alliance a.s.
> Czech Republic

The handle is baked into the kernel binary API, You can't change it without
a doing a whole new netlink API and have compatibility layer.
