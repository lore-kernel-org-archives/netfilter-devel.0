From: Anders Nilsson Plymoth <lanilsson@gmail.com>
Subject: netfilter queue throughput slowdown
Date: Wed, 29 Jun 2011 11:17:13 +0200
Message-ID: <BANLkTinVcuMCoctfuZbUdd_6m8hpbtbwFA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:42235 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185Ab1F2JRe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 Jun 2011 05:17:34 -0400
Received: by ewy4 with SMTP id 4so352655ewy.19
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Jun 2011 02:17:33 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I am using libnetfilter-queue on a router running Ubuntu 10.10 with
2.6.35-28-generic. The problem I am having is that I am experiencing a
very significant throughput slowdown whenever my NFQUEUE program is
running. This happens even when I use bare bone libnetfilter-queue
program that immediately issues an ACCEPT verdict as soon as it
receives a packet. Whenever this program is running, my max throughput
is cut in half, and the reason it happens is because nf_queue
overflows (nf_queue: full at 1024 entries, dropping packets(s)), and I
notice my CPU utilization is 100%. However, when my program is not
running and I am not passing packets through NFQUEUE and the router
routes packets as normal, I get full throughput with only 0.1% CPU
utilization.

I find this a bit strange, can the netfilter queue processing take the
cpu from 0.1% to 100% and start dropping packets even with no other
processing than setting immediately setting the verdict? We have two
of these machines, with identical hardware and OS, and they experience
the same behavior.
I am also confused as we have been using these machines previously and
been able to obtain full throughput with our netfilter program.

Does anyone have a clue here, or suggest what I should look into in
order to speed things up.

Thanks,
Anders
