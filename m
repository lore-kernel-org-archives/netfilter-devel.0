From: Shyam Saini <mayhs11saini@gmail.com>
Subject: Re: [PATCH] tests: json: Add test cases for json format
Date: Tue, 22 Aug 2017 15:00:15 +0530
Message-ID: <CAOfkYf7B09Z+nHf8EMJ2qQ6W-1u2-j_UmiwzSXgF+Mdk7Gc5dQ@mail.gmail.com>
References: <1503348904-16654-1-git-send-email-mayhs11saini@gmail.com> <CAOkSjBgo0AWBMdmfh7hEvAcNZepS5m_p9pXK5jp-L+ZVn5UjRQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
To: Arturo Borrero Gonzalez <arturo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:35350 "EHLO
        mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932205AbdHVJaR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Aug 2017 05:30:17 -0400
Received: by mail-oi0-f42.google.com with SMTP id r200so44127061oie.2
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Aug 2017 02:30:17 -0700 (PDT)
In-Reply-To: <CAOkSjBgo0AWBMdmfh7hEvAcNZepS5m_p9pXK5jp-L+ZVn5UjRQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 22, 2017 at 2:43 PM, Arturo Borrero Gonzalez
<arturo@netfilter.org> wrote:
> On 21 August 2017 at 22:55, Shyam Saini <mayhs11saini@gmail.com> wrote:
>> These cases can be used to test upcoming "import json" command.
>>
>> Here is the short description of the files:
>> all_ruleset_list   ->    contains list of all the individual rules
>> rules_ipv4*        ->    ip  table
>> rules_ipv6*        ->    ip6 table
>> rules_arp*         ->    arp table
>> rules_bridge*      ->    bridge table
>>
>> At this point of time some tests may fails.
>> For example:
>>  dup to 172.20.0.2
>>  ether daddr 00:01:02:03:04:05 ether saddr set ff:fe:dc:ba:98:76 drop
>>
>
> Hi Shyam,

Hi Arturo,

> thanks for your work!
>
> A question: How are we supposed to run these tests? At least, any hint
> would be welcome in the commit message.
I missed that part.

Thanks for the correcting me.

Probably an small bash script looping over all the rules* files and running

"cat $i  | sudo nft import json"
   if [$? -ne 0]
          echo "[Failed]"  $i
   else
          echo "[OK]"  $i

Anything more that you would like to add in this script ?

Should I send the version 2 of this patch with this script?

Regards,
Shyam
