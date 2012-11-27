From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipset 6.16 kernel panic on bitmap:hash,ip
Date: Tue, 27 Nov 2012 13:58:28 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1211271352350.14623@blackhole.kfki.hu>
References: <CADuigkVyCJVe5yKVvcKweZ=FmnTTWE1JQ55a35LrCLi2oWBHoQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Ricardo Klein <klein.rfk@gmail.com>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <CADuigkVyCJVe5yKVvcKweZ=FmnTTWE1JQ55a35LrCLi2oWBHoQ@mail.gmail.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, 27 Nov 2012, Ricardo Klein wrote:

> When I creta an ipset like this:
> ipset -N SET_MACS bitmap:ip,mac range 0.0.0.0/0
> 
> I got kernel panic when run:
> ipset list

That can't be ipset 6.16, neither in the kernel, nor the ipset binary.
The bug is fixed in ipset 6.15. You are running kernel modules and 
ipset binary from earlier releases.
 
> Anyway, we need some rules here based on mac address (no matter what
> ip address the machine have, because some of them are in DHCP).
> I know that a mac address can be easy cloned, but, still, we need that
> for some rules...
> 
> Can we have a set type "mac address" ? Only mac, with no ip?
> 
> O tried "ipset -N SET_MACS_ADM bitmap:ip,mac range 10.0.0.0/8" too but got:
> ipset v6.16: The range you specified exceeds the size limit of the set type
> 
> "ipset -N SET_MACS_ADM bitmap:ip,mac range 10.0.0.0/16" woked...
> 
> But again, this does not do the job because I need to set a rule based
> on mac address and dinamic ip addresses.

Holger Eitzenberger is working on a hash:mac type.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
