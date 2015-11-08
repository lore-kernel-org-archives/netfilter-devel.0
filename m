From: Loganaden Velvindron <loganaden@gmail.com>
Subject: Re: [PATCH 1/1 net-next] net: bridge: netfilter: use vzalloc()
 instead of vmalloc() for counterstmp
Date: Sun, 8 Nov 2015 20:52:50 +0000
Message-ID: <CAOp4FwTa91=dHkWmSz7QzojwbTEo97P1HRXqt7EN=FAKgC1Eaw@mail.gmail.com>
References: <20151030123303.GA19481@mx.elandsys.com>
	<20151108204115.GA2629@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Loganaden Velvindron <logan@elandsys.com>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:34940 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbbKHUwv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 8 Nov 2015 15:52:51 -0500
Received: by pasz6 with SMTP id z6so181165558pas.2
        for <netfilter-devel@vger.kernel.org>; Sun, 08 Nov 2015 12:52:50 -0800 (PST)
In-Reply-To: <20151108204115.GA2629@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Nov 8, 2015 at 8:41 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Fri, Oct 30, 2015 at 05:33:03AM -0700, Loganaden Velvindron wrote:
>> counterstmp is not cleared before it is used in get_counters(). it might be
>> leaked partially when it is sent to userland later on.
>
> get_counters() is memcpy'ing the old counter to the counterstmp area
> and updating it.
>
> Where is there leak?
>

In this case, none, due to correct memcpy parameters in get_counters().

However, as this is exposed later on to userland through:

        if (copy_to_user(user, counterstmp,
           nentries * sizeof(struct ebt_counter)))

zero'ing counterstmp malloc'ed memory, looks like a good idea.
