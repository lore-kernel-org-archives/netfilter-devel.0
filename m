From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: Re: [PATCH 2/2] extensions: libxt_comment: Add translation to nft
Date: Fri, 25 Dec 2015 23:23:36 +0530
Message-ID: <CAKHNQQG-DRNCewwgiYn1JPzxb8Xbr60i+W2bEPLEUcg1jz9d3Q@mail.gmail.com>
References: <cover.1450779140.git.shivanib134@gmail.com> <bfd658a271224fa7f3cbab52868300f3fbb1caa8.1450779140.git.shivanib134@gmail.com>
 <20151222170401.GA20918@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:33568 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358AbbLYRx5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Dec 2015 12:53:57 -0500
Received: by mail-wm0-f47.google.com with SMTP id p187so204360954wmp.0
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Dec 2015 09:53:57 -0800 (PST)
In-Reply-To: <20151222170401.GA20918@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Dec 22, 2015 at 10:34 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, Dec 22, 2015 at 03:48:34PM +0530, Shivani Bhardwaj wrote:
>> Add translation for comment module to nftables.
>>
>> Examples:
>>
>> $ sudo iptables-translate -A INPUT -m comment --comment "random comment"
>> nft add rule ip filter INPUT counter comment \"random comment\"
>>
>> $ sudo iptables-translate -A INPUT -i eth1 -m comment --comment "Local LAN"
>> nft add rule ip filter INPUT iifname eth1 counter comment \"Local LAN\"
>>
>> Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
>> ---
>>  extensions/libxt_comment.c | 17 +++++++++++++++--
>>  1 file changed, 15 insertions(+), 2 deletions(-)
>>
>> diff --git a/extensions/libxt_comment.c b/extensions/libxt_comment.c
>> index 6ed2ff9..bbbd6cb 100644
>> --- a/extensions/libxt_comment.c
>> +++ b/extensions/libxt_comment.c
>> @@ -48,6 +48,18 @@ comment_save(const void *ip, const struct xt_entry_match *match)
>>       xtables_save_string(commentinfo->comment);
>>  }
>>
>> +static int
>> +comment_xlate(const struct xt_entry_match *match,
>> +           struct xt_buf *buf, int numeric)
>> +{
>> +     struct xt_comment_info *commentinfo = (void *)match->data;
>> +
>> +     commentinfo->comment[XT_MAX_COMMENT_LEN-1] = '\0';
>> +     xt_buf_add(buf, "counter comment \\\"%s\\\" ", commentinfo->comment);
>                          ^^^^^^^
>
> We have to find a better way to fix this from the core infrastructure.

Is removing counter at all for this one going to be a good option?
