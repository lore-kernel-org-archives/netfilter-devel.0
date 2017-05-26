From: Oliver Ford <ojford@gmail.com>
Subject: Re: [PATCH 1/1] iptables: Add file output option to iptables-save
Date: Fri, 26 May 2017 15:43:12 +0100
Message-ID: <CAGMVOdu2qvL1p_=uOuTGyjuhqvnsCa7we-ZhXLeCP91v2cSYwg@mail.gmail.com>
References: <1495801516-14937-1-git-send-email-ojford@gmail.com> <20170526123147.GA28597@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f66.google.com ([209.85.213.66]:35350 "EHLO
        mail-vk0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030623AbdEZOnO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 May 2017 10:43:14 -0400
Received: by mail-vk0-f66.google.com with SMTP id x71so742729vkd.2
        for <netfilter-devel@vger.kernel.org>; Fri, 26 May 2017 07:43:13 -0700 (PDT)
In-Reply-To: <20170526123147.GA28597@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, May 26, 2017 at 1:31 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Fri, May 26, 2017 at 12:25:16PM +0000, Oliver Ford wrote:
>> Adds an option to output the results of iptables-save,
>> ip6tables-save, and xtables-save save to a file.
>> Updates the man page with this new option.
>>
>> Uses the dup2 call to replace stdout with the specified file.
>> Error output is unchanged.
>>
>> This is a feature requested by a Gentoo developer in
>> Bugzilla #905.
>
> Please, update manpage to include this new option and send v2.
>
> Thanks.

Hi, I updated the manpage in the file "iptables-save.8.in" which is
included in the patch. A "man iptables-save" on my box shows the new
option. Is there somewhere else I need to update it?
