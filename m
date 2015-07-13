From: Alan Bartlett <ajb@elrepo.org>
Subject: Re: Linux 4.2 build error in net/netfilter/ipset/ip_set_hash_netnet.c
Date: Mon, 13 Jul 2015 19:29:09 +0100
Message-ID: <CA+_WhHwOzJN2mDZTuc44mFooJyYXGQNtGvRuLAo3PaSDi-8DpQ@mail.gmail.com>
References: <CAHTgTXUmreHAqPfgGEd+GJNb_OEzaCuytqBTjZsE2GDqiy3TCw@mail.gmail.com>
	<20150705153520.GA23589@roeck-us.net>
	<mo0o3b$g5d$1@ger.gmane.org>
	<20150713164122.GA26283@salvia>
	<CABA31DorMPXf2tbzfF5XksMD7hbL77r5WVEDRWYbAmWDQfCE7w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org, Akemi Yagi <toracat@elrepo.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ie0-f172.google.com ([209.85.223.172]:36356 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748AbbGMS3K (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 13 Jul 2015 14:29:10 -0400
Received: by ieik3 with SMTP id k3so28299992iei.3
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Jul 2015 11:29:09 -0700 (PDT)
In-Reply-To: <CABA31DorMPXf2tbzfF5XksMD7hbL77r5WVEDRWYbAmWDQfCE7w@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 13 July 2015 at 17:46, Akemi Yagi <amyagi@gmail.com> wrote:
> On Mon, Jul 13, 2015 at 9:41 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
>> Could you please test this patch? Thank you.
>
> Thanks for the patch. We will test this and report back to you.
>
> Akemi

Hello Pablo,

My colleague Akemi Yagi has forwarded the patch to me for testing. I
now have both some good and bad news to report.

The patch (0001-netfilter-ipset-fix-build-error-with-old-gcc-version.patch)
does indeed fix the reported bug and allows the build to continue.

Unfortunately another problem is then disclosed. It is fundamentally
the same type of bug as above.

net/netfilter/ipset/ip_set_hash_netportnet.c: In function
'hash_netportnet4_uadt':
net/netfilter/ipset/ip_set_hash_netportnet.c:178: error: unknown field
'cidr' specified in initializer
net/netfilter/ipset/ip_set_hash_netportnet.c:178: warning: missing
braces around initializer
net/netfilter/ipset/ip_set_hash_netportnet.c:178: warning: (near
initialization for 'e.<anonymous>.ip')
net/netfilter/ipset/ip_set_hash_netportnet.c: In function
'hash_netportnet6_uadt':
net/netfilter/ipset/ip_set_hash_netportnet.c:448: error: unknown field
'cidr' specified in initializer
net/netfilter/ipset/ip_set_hash_netportnet.c:448: warning: missing
braces around initializer
net/netfilter/ipset/ip_set_hash_netportnet.c:448: warning: (near
initialization for 'e.ip[0]')
make[3]: *** [net/netfilter/ipset/ip_set_hash_netportnet.o] Error 1
make[2]: *** [net/netfilter/ipset] Error 2
make[1]: *** [net/netfilter] Error 2
make: *** [net] Error 2

If you could create another patch, please, I will be willing to test it.

Alan.
