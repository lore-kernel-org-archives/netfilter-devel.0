From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: Re: [PATCH] extensions: libxt_pkttype: Add translation to nft
Date: Fri, 25 Dec 2015 20:03:30 +0530
Message-ID: <CAKHNQQFUbi6WgqR4S7srff7OtTjeUsA6q_fTkNrscb9XdJJLUA@mail.gmail.com>
References: <20151223173024.GA2450@gmail.com> <20151225121510.GC4822@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:37478 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673AbbLYOdv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Dec 2015 09:33:51 -0500
Received: by mail-wm0-f47.google.com with SMTP id p187so207101458wmp.0
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Dec 2015 06:33:50 -0800 (PST)
In-Reply-To: <20151225121510.GC4822@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 25, 2015 at 5:45 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, Dec 23, 2015 at 11:00:25PM +0530, Shivani Bhardwaj wrote:
>> +static const struct pkttypes supported_types_xlate[] = {
>> +     {"unicast", PACKET_HOST, 1, "to us"},
>> +     {"broadcast", PACKET_BROADCAST, 1, "to all"},
>> +     {"multicast", PACKET_MULTICAST, 1, "to group"},
>                                         ^^^^^^^^^^^^^
>
> Do we need these fields?

Not really. Sending v2.
