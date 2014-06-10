From: Guruswamy Basavaiah <guru2018@gmail.com>
Subject: Re: [nftables PATCH] fix nft -i command crashes when try to input
 multi line command
Date: Tue, 10 Jun 2014 16:35:09 +0530
Message-ID: <CAHSpA59UwPmKGqOV_qGAGnzX7D84akiNMc4XLYpioxCAp7XrEA@mail.gmail.com>
References: <CAHSpA5_tm8PJKSCYwo4RObrzm25tGNX+j_7=K8ySB5+NdK0N9g@mail.gmail.com>
	<20140610105552.GA9228@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f45.google.com ([209.85.160.45]:41958 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbaFJLFK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Jun 2014 07:05:10 -0400
Received: by mail-pb0-f45.google.com with SMTP id um1so6176589pbc.32
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Jun 2014 04:05:10 -0700 (PDT)
In-Reply-To: <20140610105552.GA9228@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,
 Steps to reproduce.
 [root@localhost ~]# nft -i
nft> add table filter
nft> list table \

readline: readline_callback_read_char() called with no handler!
Aborted (core dumped)
[root@localhost ~]#


Guru

On 10 June 2014 16:25, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Sun, Jun 08, 2014 at 12:44:16AM +0530, Guruswamy B wrote:
>> Hello,
>>  When try to input multiline command in "nft -i", it crashes.
>>
>>  Issue is, function "cli_append_multiline" return null in case of
>> multiline command,
>>  But in the calling function "cli_complete", cli_exit is getting
>> called, which in turn calls "rl_callback_handler_remove"  and the
>> handler is getting removed.
>
> Could you include an example on how to reproduce the crash that I can
> append to this patch description?
>
> Thanks.



-- 
Guruswamy Basavaiah
