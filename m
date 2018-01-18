From: Shyam Saini <mayhs11saini@gmail.com>
Subject: Re: [RFC PATCH nft V6 1/2] src: Add import command for low level json
Date: Thu, 18 Jan 2018 07:18:12 +0530
Message-ID: <CAOfkYf6kQ1Y3z09JzBSFxZYZRRieffDsQR4oXBPUqgTcczZsFA@mail.gmail.com>
References: <1512482855-29426-1-git-send-email-mayhs11saini@gmail.com> <20180117173916.cicujrwbparvgxfa@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ot0-f172.google.com ([74.125.82.172]:39624 "EHLO
        mail-ot0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752368AbeARBsN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Jan 2018 20:48:13 -0500
Received: by mail-ot0-f172.google.com with SMTP id 37so18651216otv.6
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Jan 2018 17:48:13 -0800 (PST)
In-Reply-To: <20180117173916.cicujrwbparvgxfa@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> Hi Shyam,

Hi Pablo,

> On Tue, Dec 05, 2017 at 07:37:34PM +0530, Shyam Saini wrote:
>> This new operation allows to import low level virtual machine ruleset in
>> json to make incremental changes using the parse functions of libnftnl.
>>
>> A basic way to test this new functionality is:
>>
>>  $ cat file.json | nft import vm json
>>
>> where the file.json is a ruleset exported in low level json format.
>>
>> To export json rules in low level virtual machine format
>> we need to specify "vm" token before json. See below
>>         $ nft export vm json
>>
>> and
>>         $ nft export/import json
>>
>> will do no operations.
>> Same goes with  "$nft monitor"
>
> I'm going to place this in the nftables.git repository. Please, let's
> keep an eye on bug reports to come on this ;-).

Sure

Thanks a lot :)
