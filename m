From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: Re: [PATCH 0/2] Add support for ttl translation
Date: Mon, 4 Jan 2016 23:12:55 +0530
Message-ID: <CAKHNQQG5oxf2cZ-36ohksHC+rSxGJzFGo2a-Ov_gjbCGh8_WvQ@mail.gmail.com>
References: <cover.1451927507.git.shivanib134@gmail.com> <20160104174024.GA3706@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:37129 "EHLO
	mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbcADRnQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Jan 2016 12:43:16 -0500
Received: by mail-wm0-f54.google.com with SMTP id f206so224609706wmf.0
        for <netfilter-devel@vger.kernel.org>; Mon, 04 Jan 2016 09:43:15 -0800 (PST)
In-Reply-To: <20160104174024.GA3706@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 4, 2016 at 11:10 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Mon, Jan 04, 2016 at 10:49:10PM +0530, Shivani Bhardwaj wrote:
>> This patchset adds ttl translation to nftables by adding ip ttl to
>> the buffer everytime a ttl match is hit as it is necessary to mention
>> the protocol version with ttl, that is,
>> $ sudo nft .. ttl 3 ..             won't work but
>> $ sudo nft .. ip ttl 3 ..          would work.
>
> This above is the right syntax.
>
>> Also, since adding ip to the buffer in the code for ttl won't look
>> suitable, some amendments have been done in the nft-ipv4 code.
>>
>> Shivani Bhardwaj (2):
>>   iptables: nft-ipv4: Add ip ttl to the buffer
>
> I don't think you need this change for nft-ipv4.

Hi Pablo,

Should I be doing xt_buf_add("ip ttl") in the code for ttl?
