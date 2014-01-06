From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: Re: [PATCH netfilter: nft] add connmark module
Date: Mon, 6 Jan 2014 17:05:12 +0100
Message-ID: <CAKfDRXjPFpnw14ZAdNLNdPTnC8N7qRf1FYiBU3ocGwP_VPR57w@mail.gmail.com>
References: <1389011352-11449-1-git-send-email-kristian.evensen@gmail.com>
	<20140106124227.GA7743@localhost>
	<CAKfDRXisUL5yBbU3bZfo52GxU96BamC75vPWsFvOYg7u8Jhs1w@mail.gmail.com>
	<20140106124944.GA7830@localhost>
	<CAKfDRXiAoruPm8H9moqyfZ4KDdvVJaHCeC_N7UAq+PFETsQmkg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:36348 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733AbaAFQFN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jan 2014 11:05:13 -0500
Received: by mail-pa0-f53.google.com with SMTP id hz1so18672288pad.40
        for <netfilter-devel@vger.kernel.org>; Mon, 06 Jan 2014 08:05:13 -0800 (PST)
In-Reply-To: <CAKfDRXiAoruPm8H9moqyfZ4KDdvVJaHCeC_N7UAq+PFETsQmkg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello again,

On Mon, Jan 6, 2014 at 4:19 PM, Kristian Evensen
<kristian.evensen@gmail.com> wrote:
> Hello again,
>
> On Mon, Jan 6, 2014 at 1:49 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>>
>> I think one single NFT_META_CONNMARK with the get/set variants should
>> be enough to implement the save, restore and set operations that
>> xt_connmark provides.
>>
>> * restore:
>>         reg1 = get(NFT_META_CONNMARK)
>>         set(NFT_META_MARK, reg1)
>>
>> * save:
>>         reg1 = get(NFT_META_MARK)
>>         set(NFT_META_CONNMARK, reg1)
>>
>> * set:
>>         reg1 = immediate(value)
>>         set(NFT_META_CONNMARK, reg1)

Please ignore my previous email. As often happens, the answer popped
up right after I clicked on send. I did not think properly through how
variables work and are used in nftables, and see now that the
functionality of restore/save can be implemented using only the
get/set operations.

Thank you very much for the help, the patch is coming soon.

-Kristian
