From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipset 6.16 kernel panic on bitmap:hash,ip
Date: Tue, 27 Nov 2012 14:11:05 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1211271403550.14623@blackhole.kfki.hu>
References: <CADuigkVyCJVe5yKVvcKweZ=FmnTTWE1JQ55a35LrCLi2oWBHoQ@mail.gmail.com> <alpine.DEB.2.00.1211271352350.14623@blackhole.kfki.hu> <CADuigkX8Q0AJ_-PHyzn+1orKuXfqgrdPPC3yZ1aORBJrdcxBLg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Ricardo Klein <klein.rfk@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:50264 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735Ab2K0NLH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Nov 2012 08:11:07 -0500
In-Reply-To: <CADuigkX8Q0AJ_-PHyzn+1orKuXfqgrdPPC3yZ1aORBJrdcxBLg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 27 Nov 2012, Ricardo Klein wrote:

> I know, I have 6.15 tested, but the problem came back in 6.16

Can't be, I have verified before replying to you.

Kernel, running 6.16 modules:

# ipset -N SET_MACS bitmap:ip,mac range 0.0.0.0/0
ipset v6.16: The range you specified exceeds the size limit of the set 
type
# ipset-6.14 -N SET_MACS bitmap:ip,mac range 0.0.0.0/0
ipset v6.14: The range you specified exceeds the size limit of the set 
type

Best regards,
Jozsef

> On Tue, Nov 27, 2012 at 10:58 AM, Jozsef Kadlecsik
> <kadlec@blackhole.kfki.hu> wrote:
> > On Tue, 27 Nov 2012, Ricardo Klein wrote:
> >
> >> When I creta an ipset like this:
> >> ipset -N SET_MACS bitmap:ip,mac range 0.0.0.0/0
> >>
> >> I got kernel panic when run:
> >> ipset list
> >
> > That can't be ipset 6.16, neither in the kernel, nor the ipset binary.
> > The bug is fixed in ipset 6.15. You are running kernel modules and
> > ipset binary from earlier releases.
> >
> >> Anyway, we need some rules here based on mac address (no matter what
> >> ip address the machine have, because some of them are in DHCP).
> >> I know that a mac address can be easy cloned, but, still, we need that
> >> for some rules...
> >>
> >> Can we have a set type "mac address" ? Only mac, with no ip?
> >>
> >> O tried "ipset -N SET_MACS_ADM bitmap:ip,mac range 10.0.0.0/8" too but got:
> >> ipset v6.16: The range you specified exceeds the size limit of the set type
> >>
> >> "ipset -N SET_MACS_ADM bitmap:ip,mac range 10.0.0.0/16" woked...
> >>
> >> But again, this does not do the job because I need to set a rule based
> >> on mac address and dinamic ip addresses.
> >
> > Holger Eitzenberger is working on a hash:mac type.
> >
> > Best regards,
> > Jozsef
> > -
> > E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
> > PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
> > Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
> >           H-1525 Budapest 114, POB. 49, Hungary
> 

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
