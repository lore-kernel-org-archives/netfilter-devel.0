From: Akemi Yagi <amyagi@gmail.com>
Subject: Re: Linux 4.2 build error in net/netfilter/ipset/ip_set_hash_netnet.c
Date: Tue, 11 Aug 2015 08:50:28 -0700
Message-ID: <CABA31DpRS5NXQm0_tP3eMxE4E9TdtGmrZbr+ZE8JUiNs3qHbMg@mail.gmail.com>
References: <CAHTgTXUmreHAqPfgGEd+GJNb_OEzaCuytqBTjZsE2GDqiy3TCw@mail.gmail.com>
 <20150705153520.GA23589@roeck-us.net> <mo0o3b$g5d$1@ger.gmane.org>
 <20150713164122.GA26283@salvia> <alpine.DEB.2.10.1507141910280.28425@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Alan Bartlett <ajb@elrepo.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yk0-f176.google.com ([209.85.160.176]:33342 "EHLO
	mail-yk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965175AbbHKPut (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Aug 2015 11:50:49 -0400
Received: by ykaz130 with SMTP id z130so62947034yka.0
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Aug 2015 08:50:48 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.10.1507141910280.28425@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jul 14, 2015 at 10:12 AM, Jozsef Kadlecsik
<kadlec@blackhole.kfki.hu> wrote:
> Hi,
>
> On Mon, 13 Jul 2015, Pablo Neira Ayuso wrote:
>
>> On Mon, Jul 13, 2015 at 04:13:31PM +0000, Akemi Yagi wrote:
>> > On Sun, 05 Jul 2015 08:35:20 -0700, Guenter Roeck wrote:
>> >
>> > > On Sat, Jul 04, 2015 at 12:44:36AM -0700, Vinson Lee wrote:
>> > >> Hi.
>> > >>
>> > >> With the latest Linux 4.2-rc1, I am hitting this build error with GCC
>> > >> 4.4.7 on CentOS 6.
>> > >>
>> > >>   CC      net/netfilter/ipset/ip_set_hash_netnet.o
>> > >> net/netfilter/ipset/ip_set_hash_netnet.c: In function
>> > >> ?hash_netnet4_uadt?:
(snip)
>> > >>
>> > > Previously fixed with commit 1a869205c75cb ("netfilter: ipset: The
>> > > unnamed union initialization may lead to compilation error"),
>> > > reintroduced with commit aff227581ed1a ("netfilter: ipset: Check CIDR
>> > > value only when attribute is given").
>> > >
>> > > Guenter
>> >
>> > I wonder what can be done to get this issue fixed. This problem was seen
>> > in 4.2-rc1 and now in 4.2-rc2 on RHEL-6.6.
>> >
>> > $ gcc --version
>> > gcc (GCC) 4.4.7 20120313 (Red Hat 4.4.7-11)
>>
>> Could you please test this patch? Thank you.
>
> As I mentioned at the workshop, the patch
> net-netfilter-ipset-work-around-gcc-444-initializer-bug.patch has been
> added to the -mm tree at Jun 17. My impression was that that way the bug
> was fixed and everything was all right.
>
> Best regards,
> Jozsef

The referenced patch does indeed fix the issue but it is still not in
Linus' tree as of kernel 4.2.0-0.rc6. Does anyone know how to push
forward this so the official 4.2 kernel would have the fix?

Thanks,

Akemi
