From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: Re: [PATCH] extensions: libxt_mark: Add translation to nft
Date: Sun, 6 Dec 2015 08:18:28 +0530
Message-ID: <CAKHNQQE5Vdp5cFKA3dLoScQWTJ5G-cRxeT2DF9VwArnMBJ88Bg@mail.gmail.com>
References: <1449321576-20705-1-git-send-email-shivanib134@gmail.com>
 <20151205191409.GA2830@salvia> <20151205231446.GA1148@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:33933 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380AbbLFCst (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Dec 2015 21:48:49 -0500
Received: by wmvv187 with SMTP id v187so122992965wmv.1
        for <netfilter-devel@vger.kernel.org>; Sat, 05 Dec 2015 18:48:48 -0800 (PST)
In-Reply-To: <20151205231446.GA1148@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Dec 6, 2015 at 4:44 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Sat, Dec 05, 2015 at 08:14:09PM +0100, Pablo Neira Ayuso wrote:
>> Hi Shivani,
>>
>> On Sat, Dec 05, 2015 at 06:49:36PM +0530, Shivani Bhardwaj wrote:
>> > Add translation of the metainformation mark to nft.
>> >
>> > Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
>> > ---
>> >  extensions/libxt_mark.c | 60 +++++++++++++++++++++++++++++++++++++++++++++++++
>> >  1 file changed, 60 insertions(+)
>> >
>> > diff --git a/extensions/libxt_mark.c b/extensions/libxt_mark.c
>> > index 7f8c995..5105bf9 100644
>> > --- a/extensions/libxt_mark.c
>> > +++ b/extensions/libxt_mark.c
>> > @@ -102,6 +102,64 @@ mark_save(const void *ip, const struct xt_entry_match *match)
>> >     print_mark(info->mark, info->mask);
>> >  }
>> >
>> > +static void
>> > +print_mark_xlate(struct xt_buf *buf,
>> > +            unsigned int mark, unsigned int mask)
>> > +{
>> > +        if (mask != 0xffffffffU)
>> > +                xt_buf_add(buf, " 0x%x/0x%x", mark, mask);
>>
>> In nftables this should be translated to &.
>
> I mean:
>         xt_buf_add(buf, " & x%x == x%x", mask, mark);

OK. I'm sending version 2. Please check it.

Thank you
