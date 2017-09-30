From: Arturo Borrero Gonzalez <arturo@netfilter.org>
Subject: Re: [ulogd2 PATCH] ulogd2: add new config option: load_all_plugins
Date: Sat, 30 Sep 2017 11:43:46 +0200
Message-ID: <CAOkSjBjjzDA8HVYAYuDutg_+Miz7s=5PExY6zsOj8h+kkGjNxA@mail.gmail.com>
References: <150633836700.6370.2675458398740561976.stgit@nfdev2.cica.es> <20170929113949.GA28566@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:55879 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750933AbdI3JoJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Sep 2017 05:44:09 -0400
Received: by mail-wm0-f47.google.com with SMTP id u138so3031398wmu.4
        for <netfilter-devel@vger.kernel.org>; Sat, 30 Sep 2017 02:44:09 -0700 (PDT)
Received: from mail-wm0-f42.google.com (mail-wm0-f42.google.com. [74.125.82.42])
        by smtp.gmail.com with ESMTPSA id a2sm4806779edi.0.2017.09.30.02.44.07
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 30 Sep 2017 02:44:07 -0700 (PDT)
Received: by mail-wm0-f42.google.com with SMTP id q132so3043174wmd.2
        for <netfilter-devel@vger.kernel.org>; Sat, 30 Sep 2017 02:44:07 -0700 (PDT)
In-Reply-To: <20170929113949.GA28566@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 29 September 2017 at 13:39, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Hi Arturo,
>
> On Mon, Sep 25, 2017 at 01:19:27PM +0200, Arturo Borrero Gonzalez wrote:
>> diff --git a/ulogd.conf.in b/ulogd.conf.in
>> index a987d64..fe54420 100644
>> --- a/ulogd.conf.in
>> +++ b/ulogd.conf.in
>> @@ -24,6 +24,16 @@ logfile="/var/log/ulogd.log"
>>  # 2. options for each plugin in seperate section below
>>
>>
>> +# load all the plugins in one go. Then, there is no need to specify each
>> +# plugin individually. There are two ways of using this clause, by leaving it
>> +# blank (default) or by using a filesystem path. If blank a default directory
>> +# configured at build time will be used (--with-ulogd2libdir).
>> +#
>> +# Examples:
>> +#
>> +# load_all_plugins=
>> +# load_all_plugins=/usr/local/lib/ulogd/
>> +
>>  plugin="@pkglibdir@/ulogd_inppkt_NFLOG.so"
>>  #plugin="@pkglibdir@/ulogd_inppkt_ULOG.so"
>>  #plugin="@pkglibdir@/ulogd_inppkt_UNIXSOCK.so"
>
> Just an idea, probably better something like:
>
>         plugin="@pkglibdir@/"
>
> I mean, if you specify a directory, then this means "include every
> ulogd_*.so file there", it's easy to check via stat() if this is path
> represents a directory, so you can skip string handling tricks.

Ok, but how could we avoid putting there a complex, arch-dependant path?
My first idea was to have the new config directive to don't accept any
path and having the default set at build/configure time.
For the sake of flexibility I added in the last moment the option for
the user to give a path and override the one set at build/configure
time.
