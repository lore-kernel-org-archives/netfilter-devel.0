From: Arturo Borrero Gonzalez <arturo@netfilter.org>
Subject: Re: [ulogd2 PATCH] ulogd2: add new config option: load_all_plugins
Date: Sat, 30 Sep 2017 12:43:36 +0200
Message-ID: <CAOkSjBh0gU4r7mxLVnTRCzQdnSydebJsdg-+-Sym8seL8EXB+Q@mail.gmail.com>
References: <150633836700.6370.2675458398740561976.stgit@nfdev2.cica.es>
 <20170929113949.GA28566@salvia> <CAOkSjBjjzDA8HVYAYuDutg_+Miz7s=5PExY6zsOj8h+kkGjNxA@mail.gmail.com>
 <CAOkSjBi1gUQjH5vGtCC4eRE36-PcWdN6r_NL7--PoNQv1VhK0g@mail.gmail.com> <20170930101203.GB2078@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35376 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750933AbdI3Kn6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Sep 2017 06:43:58 -0400
Received: by mail-wm0-f65.google.com with SMTP id b189so992040wmd.2
        for <netfilter-devel@vger.kernel.org>; Sat, 30 Sep 2017 03:43:58 -0700 (PDT)
Received: from mail-wm0-f47.google.com (mail-wm0-f47.google.com. [74.125.82.47])
        by smtp.gmail.com with ESMTPSA id w51sm5757180edd.60.2017.09.30.03.43.57
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 30 Sep 2017 03:43:57 -0700 (PDT)
Received: by mail-wm0-f47.google.com with SMTP id r74so3222394wme.4
        for <netfilter-devel@vger.kernel.org>; Sat, 30 Sep 2017 03:43:57 -0700 (PDT)
In-Reply-To: <20170930101203.GB2078@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 30 September 2017 at 12:12, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Sat, Sep 30, 2017 at 11:48:11AM +0200, Arturo Borrero Gonzalez wrote:
>> On 30 September 2017 at 11:43, Arturo Borrero Gonzalez
>> <arturo@netfilter.org> wrote:
>> >
>> > Ok, but how could we avoid putting there a complex, arch-dependant path?
>>
>> i.e, in Debian this means a path like:
>>
>> /usr/lib/mips64el-linux-gnuabi64/ulogd/ulogd_filter_IFINDEX.so
>>
>> so user should use /usr/lib/mips64el-linux-gnuabi64/ which is very ugly.
>> If the config file is copied to a machine with a different arch, amd64
>> for example, then path should be modified to:
>>
>> /usr/lib/x86_64-linux-gnu/ulogd/
>>
>> Complex and ugly. We should avoid that. I think we should offer a
>> default at build/configure time.
>
> I think @pkglibdir@ in ulogd.conf.in will set this to the
> corresponding arch-dependent folder at configure/build time, right?

The point is to don't have the ugly string in the config file.
Transparent to the user. Simplify the config file.
