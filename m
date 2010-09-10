From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: VLAN ebtables target
Date: Fri, 10 Sep 2010 10:33:12 +0800
Message-ID: <AANLkTinpMZyZgA5QZ8PezZv7r2iW1c6xPN7QcpxSzaqw@mail.gmail.com>
References: <1284026558.2111.8.camel@nbmichele>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org
To: michele.de_candia@alcatel-lucent.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41644 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083Ab0IJCde (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Sep 2010 22:33:34 -0400
Received: by wwb34 with SMTP id 34so297804wwb.1
        for <netfilter-devel@vger.kernel.org>; Thu, 09 Sep 2010 19:33:33 -0700 (PDT)
In-Reply-To: <1284026558.2111.8.camel@nbmichele>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 9, 2010 at 6:02 PM, Michele Jr De Candia
<michele.de_candia@alcatel-lucent.com> wrote:
> Hi all,
> I read on ebtable-devel mailing list that somebody has tried to do a new
> target module to add or remove the VLAN tag with ebtables.
>
> There were some patches or references about previous developments?
>

What is the requirement which needs this VLAN target? Most of
requirement can be satisfied  with ebtables and vlan network devices.

-- 
Regards,
Changli Gao(xiaosuo@gmail.com)
