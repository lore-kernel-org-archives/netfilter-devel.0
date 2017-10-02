From: Arturo Borrero Gonzalez <arturo@netfilter.org>
Subject: Re: [ulogd2 PATCH] ulogd2: add new config option: load_all_plugins
Date: Mon, 2 Oct 2017 13:31:31 +0200
Message-ID: <CAOkSjBiKJh4pMCUO4=iemCPZWi1SigNAFhe4Pe5RexV3Lcm3DQ@mail.gmail.com>
References: <150633836700.6370.2675458398740561976.stgit@nfdev2.cica.es>
 <20170929113949.GA28566@salvia> <CAOkSjBjjzDA8HVYAYuDutg_+Miz7s=5PExY6zsOj8h+kkGjNxA@mail.gmail.com>
 <CAOkSjBi1gUQjH5vGtCC4eRE36-PcWdN6r_NL7--PoNQv1VhK0g@mail.gmail.com>
 <20170930101203.GB2078@salvia> <CAOkSjBh0gU4r7mxLVnTRCzQdnSydebJsdg-+-Sym8seL8EXB+Q@mail.gmail.com>
 <20171002104429.GB2832@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:54334 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750788AbdJBLbx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Oct 2017 07:31:53 -0400
Received: by mail-wm0-f51.google.com with SMTP id i124so9919584wmf.3
        for <netfilter-devel@vger.kernel.org>; Mon, 02 Oct 2017 04:31:52 -0700 (PDT)
Received: from mail-wm0-f53.google.com (mail-wm0-f53.google.com. [74.125.82.53])
        by smtp.gmail.com with ESMTPSA id m8sm8124672edl.74.2017.10.02.04.31.51
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Oct 2017 04:31:51 -0700 (PDT)
Received: by mail-wm0-f53.google.com with SMTP id m72so7196093wmc.0
        for <netfilter-devel@vger.kernel.org>; Mon, 02 Oct 2017 04:31:51 -0700 (PDT)
In-Reply-To: <20171002104429.GB2832@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 2 October 2017 at 12:44, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Sat, Sep 30, 2017 at 12:43:36PM +0200, Arturo Borrero Gonzalez wrote:
>> On 30 September 2017 at 12:12, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> > On Sat, Sep 30, 2017 at 11:48:11AM +0200, Arturo Borrero Gonzalez wrote:
>> >> On 30 September 2017 at 11:43, Arturo Borrero Gonzalez
>> >> <arturo@netfilter.org> wrote:
>> >> >
>> >> > Ok, but how could we avoid putting there a complex, arch-dependant path?
>> >>
>> >> i.e, in Debian this means a path like:
>> >>
>> >> /usr/lib/mips64el-linux-gnuabi64/ulogd/ulogd_filter_IFINDEX.so
>> >>
>> >> so user should use /usr/lib/mips64el-linux-gnuabi64/ which is very ugly.
>> >> If the config file is copied to a machine with a different arch, amd64
>> >> for example, then path should be modified to:
>> >>
>> >> /usr/lib/x86_64-linux-gnu/ulogd/
>> >>
>> >> Complex and ugly. We should avoid that. I think we should offer a
>> >> default at build/configure time.
>> >
>> > I think @pkglibdir@ in ulogd.conf.in will set this to the
>> > corresponding arch-dependent folder at configure/build time, right?
>>
>> The point is to don't have the ugly string in the config file.
>> Transparent to the user. Simplify the config file.
>
> OK.
>
> What if we default to loading all plugins if user specifies no
> "plugin=" at all in the configuration file?
>
> No worries in terms of breaking backward compatibility, so far ulogd2
> just bails out if no plugin is available.
>
> That would simplify the configuration file as you're searching for.

Ok, will do that.
