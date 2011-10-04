From: Julien Lafaye <jlafaye@gmail.com>
Subject: Re: Packet statistics accounting module: request for comments
Date: Tue, 4 Oct 2011 21:03:21 +0200
Message-ID: <CAFAca_CH4QD-7XngGE=H_pTKo+gN3F_nf2RTf+1S8kbvPXkj-g@mail.gmail.com>
References: <CAFAca_CyLYGH+FyzyONsM7CiA6K3=BNdwY6PvTd+d1HEFKX6XQ@mail.gmail.com>
	<alpine.LNX.2.01.1110041256500.22180@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:59819 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932820Ab1JDTDW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Oct 2011 15:03:22 -0400
Received: by vcbfk10 with SMTP id fk10so677333vcb.19
        for <netfilter-devel@vger.kernel.org>; Tue, 04 Oct 2011 12:03:21 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1110041256500.22180@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Oct 4, 2011 at 1:02 PM, Jan Engelhardt <jengelh@medozas.de> wrote:
> On Tuesday 2011-10-04 06:50, Julien Lafaye wrote:
>>
>>I created a small packet statistics accounting module based on the
>>xtables framework. It is based on a FIFO that is filled in netfilter
>>hooks and emptied by a user program reading statistics through /proc
>>callbacks. The goal of the module is to be able to get maximum traffic
>>rate with an improved resolution compared to basic techniques. Typical
>>expected resolution is 100ms.
>
> I am thinking of how xt_quota2 (in grow mode) could have been enhanced
> to simply reset the counter when the procfs file is read. How would that
> have compared to your module?

My objective was to count incoming packets & bytes received during
short time frames, i.e. 100ms even 10ms. I first thought of having a
user program polling statistics but I would have to rely on accurate
scheduling of the polling process by the OS. I wanted to be able to
deploy the accounting module on Centos 5 kernels (2.6.18) which does
not have the dynticks features and no guarantee that the polling
process will be awakened when I wanted it to be. So, I chose to build
time buckets directly in the softirq handler and export them with
/proc. I agree that polling the xt_quota2 counter and resetting at
each poll will achieve the same functionality but I would run tests to
check that polling is actually scheduled at regular enough intervals.

>>The code is currently stored in github:
>>https://github.com/jlafaye/xt_pktstat
>>
>>I would like the code to be considered for inclusion in the
>>xtables-addons framework. Nevertheless, the code might not be mature
>>enough as this is the first time I do kernel programming. Although
>>advised by knowledgeable persons, there are probably many issues in it.
>
> The .c files need a little license-mentioning header at the least, and
> should in principle also use tab indents like LKCS.-See files from Xt-a
> for examples.

OK
