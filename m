From: Anand Raj Manickam <anandrm@gmail.com>
Subject: Re: iptables-nftables mnl_nft_batch_talk:: Invalid argument
Date: Wed, 9 Oct 2013 15:17:29 +0530
Message-ID: <CAEyr1FRijatyd1jPq7r1gY-p7tA-4=kwYMnnu_0fHkoqhSxPEw@mail.gmail.com>
References: <CAEyr1FTqVgbM3zK-UAL0fHU4MRkYvf-xzNb7Cp7FQT3NQiMgXQ@mail.gmail.com>
	<5254E322.10308@linux.intel.com>
	<20131009090415.GA3766@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qe0-f48.google.com ([209.85.128.48]:33770 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab3JIJra (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Oct 2013 05:47:30 -0400
Received: by mail-qe0-f48.google.com with SMTP id d4so369355qej.35
        for <netfilter-devel@vger.kernel.org>; Wed, 09 Oct 2013 02:47:29 -0700 (PDT)
In-Reply-To: <20131009090415.GA3766@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Oct 9, 2013 at 2:34 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, Oct 09, 2013 at 08:01:22AM +0300, Tomasz Bursztyka wrote:
>> Hi Anand,
>>
>> You can increase the debug output via iptables/nft-shared.h: just
>> change #if 0 to #if 1.
>
> I think Anand is not running latest git HEAD kernel.

Thanks Pablo , I missed the latest pull on kernel.
It works now.
