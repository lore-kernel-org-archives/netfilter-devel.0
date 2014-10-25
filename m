From: Kim N <spam1@norring.dk>
Subject: [Kernel Bug 86261] Ipset add/restore slowed to a crawl in kernel
 3.17 (and 3.17.1)
Date: Sat, 25 Oct 2014 22:01:58 +0200
Message-ID: <544C01B6.3050603@norring.dk>
References: <5446AB11.1000807@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail1-hoer.fullrate.dk ([90.185.2.131]:41475 "EHLO
	mail1-hoer.fullrate.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261AbaJYT74 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 25 Oct 2014 15:59:56 -0400
Received: from turing.norring.dk (2304ds5-soeb.0.fullrate.dk [90.184.204.242])
	by mail1-hoer.fullrate.dk (Postfix) with ESMTP id 71E2DBFB50
	for <netfilter-devel@vger.kernel.org>; Sat, 25 Oct 2014 21:59:50 +0200 (CEST)
Received: from mail.norring.dk (mail.norring.dk [10.0.10.252])
	by turing.norring.dk (Postfix) with ESMTPS id C762B1AA2F6C
	for <netfilter-devel@vger.kernel.org>; Sat, 25 Oct 2014 21:59:49 +0200 (CEST)
In-Reply-To: <5446AB11.1000807@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Daniel Borkmann (dborkman@redhat.com) requested that I report this issu=
e=20
here:

------
The speed of adding and restoring IPs in ipset has changed drastically=20
from kernel version 3.16.5 to 3.17.0.

3.16.5 adds and restores attached list of IP ranges (~430 records) in=20
0-1 seconds.
3.17.0 adds in 30s and restores in 14s.

Some of the other files I use with country IP ranges contains more than=
=20
50.000 records taking hours to add/restore in kernel 3.17.

I used a clean VirtualBox Debian installation for this test.
The kernels were build using default settings.
-----

Test-script/data and details can be found here:

https://bugzilla.kernel.org/show_bug.cgi?id=3D86261

Kind regards

Kim N=F8rring

-------- Forwarded Message --------
Subject: 	Re: Fwd: [Bug 86261] New: Ipset add/restore slowed to a crawl
Date: 	Tue, 21 Oct 2014 20:50:57 +0200
=46rom: 	Daniel Borkmann <dborkman@redhat.com>
To: 	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
CC: 	spam1@norring.dk



[ Cc'ing reporter ]

On 10/21/2014 08:48 PM, Jozsef Kadlecsik wrote:
> Hi,
>
> On Mon, 20 Oct 2014, Daniel Borkmann wrote:
>
>> -------- Original Message --------
>> Subject: [Bug 86261] New: Ipset add/restore slowed to a crawl
>> Date: Tue, 14 Oct 2014 18:58:57 +0000
>> From:bugzilla-daemon@bugzilla.kernel.org
>> To:dborkman@redhat.com
>>
>>https://bugzilla.kernel.org/show_bug.cgi?id=3D86261
>>
>>              Bug ID: 86261
>>             Summary: Ipset add/restore slowed to a crawl
>>             Product: Networking
>>             Version: 2.5
>>      Kernel Version: Linux debian2 3.17.0
>>            Hardware: i386
>>                  OS: Linux
>>                Tree: Mainline
>>              Status: NEW
>>            Severity: high
>>            Priority: P1
>>           Component: Netfilter/Iptables
>>            Assignee:networking_netfilter-iptables@kernel-bugs.osdl.o=
rg
>>            Reporter:spam1@norring.dk
>>          Regression: No
>>
>> Created attachment 153751
>>    -->https://bugzilla.kernel.org/attachment.cgi?id=3D153751&action=3D=
edit
>> IP range for Afghanistan in CIDR format
>>
>> The speed of adding and restoring IPs in ipset has changed drastical=
ly from
>> kernel version 3.16.5 to 3.17.0.
>>
>> 3.16.5 adds and restores attached list of IP ranges (~430 records) i=
n 0-1
>> seconds.
>> 3.17.0 adds in 30s and restores in 14s.
>>
>> Some of the other files I use with country IP ranges contains more t=
han 50.000
>> records taking hours to add/restore in kernel 3.17.
>>
>> I used a clean VirtualBox Debian installation for this test.
>> The kernels were build using default settings.
>>
>>
>> Script:
>> **********************
>> #!/bin/bash
>> IPSET=3D/usr/sbin/ipset
>> IPSET_NAME=3Dmytest
>>
>> function addThem {
>>      for IP in $(cat ./AF); do
>>          $IPSET add $IPSET_NAME $IP
>>      done
>> }
>>
>> ipset x
>>
>> $IPSET create $IPSET_NAME hash:net
>>
>> time addThem
>>
>> time $IPSET save > ./saved
>>
>> ipset x
>>
>> time $IPSET restore < ./saved
>>
>> *****************
>
> I went through the ipset relates patches between 3.16 and 3.17 and se=
e
> nothing which could result such a performance drop. The patches eithe=
r
> fix static checker or other warnings or contain new features (skbinfo
> extension and hash:mac set type) which looks totally independet from =
this.
> (Netlink itself changed radically between the two kernel releases.)
>
> So I'm going to setup an environment to check it myself.
>
> Best regards,
> Jozsef
> -
> E-mail  :kadlec@blackhole.kfki.hu,kadlecsik.jozsef@wigner.mta.hu
> PGP key :http://www.kfki.hu/~kadlec/pgp_public_key.txt
> Address : Wigner Research Centre for Physics, Hungarian Academy of Sc=
iences
>            H-1525 Budapest 114, POB. 49, Hungary
>



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
