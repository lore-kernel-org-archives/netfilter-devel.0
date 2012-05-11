From: Neutron Soutmun <neo.neutron@gmail.com>
Subject: Re: [ANNOUNCE] ipset 6.12 released
Date: Fri, 11 May 2012 16:00:42 +0700
Message-ID: <CAMQP0skxm5GVYjDjwd7AwcHbNg6w2fZJQOTMKdAz_ZmbtP4FSA@mail.gmail.com>
References: <alpine.DEB.2.00.1205101211080.18562@blackhole.kfki.hu>
	<alpine.LNX.2.01.1205101238020.20012@frira.vanv.qr>
	<alpine.DEB.2.00.1205101316470.18862@blackhole.kfki.hu>
	<alpine.LNX.2.01.1205101327310.12733@frira.vanv.qr>
	<alpine.DEB.2.00.1205101337160.19028@blackhole.kfki.hu>
	<CAMQP0sn=2jKYzoiUVu+oTRYj-niL84Lg2Z1UoO0UnFXJjV8Ggw@mail.gmail.com>
	<CAMQP0s=uSzOn-o7jwKLyhTaZud4d04hMN=JXrCQLrFD+6Zinkw@mail.gmail.com>
	<alpine.DEB.2.00.1205101724370.19418@blackhole.kfki.hu>
	<CAMQP0sm+_8FytQxQHCgk44DVesxMycYQbMW9z+XR0-09NniT9Q@mail.gmail.com>
	<CAMQP0snnXgGCJqN1iuN+y9_rgpa7HMrRuM0akhCa-NtxmBz_QA@mail.gmail.com>
	<CAMQP0s=DvvYL9SKURz2nm9WuWHQEXBQv9UEQ487GQMwhqa_rgg@mail.gmail.com>
	<4FAC3A87.3010500@googlemail.com>
	<alpine.DEB.2.00.1205111034100.20558@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Mr Dash Four <mr.dash.four@googlemail.com>,
	netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34134 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748Ab2EKJAn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 May 2012 05:00:43 -0400
Received: by pbbrp8 with SMTP id rp8so3040934pbb.19
        for <netfilter-devel@vger.kernel.org>; Fri, 11 May 2012 02:00:43 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.00.1205111034100.20558@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, May 11, 2012 at 3:40 PM, Jozsef Kadlecsik
<kadlec@blackhole.kfki.hu> wrote:
> On Thu, 10 May 2012, Mr Dash Four wrote:
>
>> > the point of this feature is providing the easy way that the
>> > third-party or the experimental modules
>> > plug into the existing ipset userspace binary without recompile.
>> >
>> > You could build the experimental ipset "FOO" kernel module and build
>> > the shared-lib of "FOO" userspace tool module and
>> > plug into the system without recompile the ipset userspace tool at
>> > all. It's inspired by iptables (kernel/userspace module).
>> >
>> Is there a documentation on how to do that? For example, if I wish to
>> add my own ipset type/matching (as a separate module), where do I start
>> looking?
>
> As documentation, there's nothing yet.
>
> The userspace part of a set type is quite simple: just the
> parsing, printing, dimension, supported families have to be definied.
> The kernel part is, well, another matter. Of course all the existing
> types can be used as examples.

I definitely agree with you, all the existing types can be used as examples.

/me:
$ git clone <ipset>
$ git branch experimental/some_ipset_type
$ git checkout experimental/some_ipset_type
....
$ make
[... test ...]
