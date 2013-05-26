From: Alex Maltinsky <maltalex@gmail.com>
Subject: Re: Negative value in /proc/net/netfilter/nfnetlink_queue
Date: Sun, 26 May 2013 16:43:08 +0300
Message-ID: <CAAitQhkZoQs4nKrO3QxBo8xzR5HFhwpwhOAEy0kOuvE+842J-A@mail.gmail.com>
References: <CAAitQh=ZUM8+8TqO8EFNrT7GL8VThvDje_Vfc4P0e3T60QVpSA@mail.gmail.com>
 <CAAitQhkvPWzjvWE7G80OxrwpKbemxbm9N6bchfygiOdwjDUgjA@mail.gmail.com>
 <20130526104226.GA6578@breakpoint.cc> <CAAitQh=1nMc-YPw3xF-+8OV8bjXTumRfZdLjdwC0LrQtJYWdAw@mail.gmail.com>
 <20130526134205.GB6578@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oa0-f44.google.com ([209.85.219.44]:39659 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539Ab3EZNnj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 26 May 2013 09:43:39 -0400
Received: by mail-oa0-f44.google.com with SMTP id n12so7953541oag.3
        for <netfilter-devel@vger.kernel.org>; Sun, 26 May 2013 06:43:38 -0700 (PDT)
In-Reply-To: <20130526134205.GB6578@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ok, thanks a lot.

On Sun, May 26, 2013 at 4:42 PM, Florian Westphal <fw@strlen.de> wrote:
> Alex Maltinsky <maltalex@gmail.com> wrote:
>> The system I'm dealing often has traffic spikes that cause NFQ packet
>> drops. So I can't put a counter in userspace because it would miss
>> dropped packets. Counting dropped packets (as a percentage of the
>> total number of packets) is the main reason why I'm trying to get the
>> correct number of packets sent to the NFQ in the first place...
>
> As i said, there is no kernel counter that increments per-packet
> delivery, except the queue packet id, which is only 32bit (and this
> cannot be changed).
>
> You could use the iptables rule count of your 'NFQUEUE' rules,
> though since these will increment for every packet (and they're 64bit).
