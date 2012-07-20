From: John Tran <njhtran@gmail.com>
Subject: Re: Problem with iptables accounting in Ubuntu Precise 12.04 LTS
Date: Fri, 20 Jul 2012 15:50:11 -0700
Message-ID: <CAHHzA4WPdhRanibDKtyevyNRLvkM6-0+NpcFg5Y6kswm+aLx4Q@mail.gmail.com>
References: <CAHHzA4XF-f9LMTAmFpC65u0ikFd-9Sd76A0q+Qr5E9Xbr5eVEQ@mail.gmail.com>
	<alpine.LNX.2.01.1207210014250.2166@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:65466 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab2GTWuN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Jul 2012 18:50:13 -0400
Received: by lbbgm6 with SMTP id gm6so5667076lbb.19
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Jul 2012 15:50:11 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1207210014250.2166@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I searched my entire hard drive, apparently xt_ACCOUNT.ko is not one
of the files that comes with Precise Pangolin.  Is there a known
Ubuntu distribution that does have it working properly?

On Fri, Jul 20, 2012 at 3:18 PM, Jan Engelhardt <jengelh@inai.de> wrote:
> On Friday 2012-07-20 19:44, John Tran wrote:
>
>>I'm trying to get iptables accounting working on Ubuntu 12.04 LTS
>>amd64 yet not having much luck.  Here is what I'm getting and I hope
>>someone can provide some insight to my problems:
>
>>root@ubuntu-mbp:~# iptaccount -a
>>
>>libxt_ACCOUNT_cl userspace accounting tool v1.3
>>
>>get_table_names failed: Can't get table names from kernel. Out of
>>memory, MINBUFISZE too small?
>
> iptaccount requires that xt_ACCOUNT.ko be loaded, but the original
> authors did not add any autoloading facility.
