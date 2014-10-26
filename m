From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [Kernel Bug 86261] Ipset add/restore slowed to a crawl in kernel
 3.17 (and 3.17.1)
Date: Sun, 26 Oct 2014 18:12:35 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1410261755280.528@blackhole.kfki.hu>
References: <5446AB11.1000807@redhat.com> <544C01B6.3050603@norring.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Kim N <spam1@norring.dk>, Daniel Borkmann <dborkman@redhat.com>,
	netfilter-devel@vger.kernel.org
To: Thomas Graf <tgraf@suug.ch>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:56361 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751157AbaJZRMA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 26 Oct 2014 13:12:00 -0400
In-Reply-To: <544C01B6.3050603@norring.dk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Thomas,

According to my tests the slowdown in ipset (netlink) is caused by the 
patch:

commit e341694e3eb57fcda9f1adc7bfea42fe080d8d7a
Author: Thomas Graf <tgraf@suug.ch>
Date:   Sat Aug 2 11:47:45 2014 +0200

    netlink: Convert netlink_lookup() to use RCU protected hash table
    
Running the test provided in the report below in a KVM guest, the times 
spent in adding ~430 entries, saving, then restoring those

before the patch are

real    0m1.903s
user    0m0.256s
sys     0m0.536s
                            
real    0m0.009s
user    0m0.000s
sys     0m0.004s

real    0m0.009s
user    0m0.004s
sys     0m0.004s

while after applying the patch:

real    0m9.357s
user    0m1.364s
sys     0m2.824s

real    0m0.029s
user    0m0.008s
sys     0m0.004s

real    0m0.024s
user    0m0.004s
sys     0m0.008s

Could you have a look why (nf)netlink gets slower after your patch?

Best regards,
Jozsef

On Sat, 25 Oct 2014, Kim N wrote:

> Daniel Borkmann (dborkman@redhat.com) requested that I report this issue here:
> 
> ------
> The speed of adding and restoring IPs in ipset has changed drastically from
> kernel version 3.16.5 to 3.17.0.
> 
> 3.16.5 adds and restores attached list of IP ranges (~430 records) in 0-1
> seconds.
> 3.17.0 adds in 30s and restores in 14s.
> 
> Some of the other files I use with country IP ranges contains more than 50.000
> records taking hours to add/restore in kernel 3.17.
> 
> I used a clean VirtualBox Debian installation for this test.
> The kernels were build using default settings.
> -----
> 
> Test-script/data and details can be found here:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=86261
> 
> Kind regards
> 
> Kim N?rring
> 
> -------- Forwarded Message --------
> Subject: 	Re: Fwd: [Bug 86261] New: Ipset add/restore slowed to a crawl
> Date: 	Tue, 21 Oct 2014 20:50:57 +0200
> From: 	Daniel Borkmann <dborkman@redhat.com>
> To: 	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> CC: 	spam1@norring.dk
> 
> 
> 
> [ Cc'ing reporter ]
> 
> On 10/21/2014 08:48 PM, Jozsef Kadlecsik wrote:
> > Hi,
> > 
> > On Mon, 20 Oct 2014, Daniel Borkmann wrote:
> > 
> > > -------- Original Message --------
> > > Subject: [Bug 86261] New: Ipset add/restore slowed to a crawl
> > > Date: Tue, 14 Oct 2014 18:58:57 +0000
> > > From:bugzilla-daemon@bugzilla.kernel.org
> > > To:dborkman@redhat.com
> > > 
> > > https://bugzilla.kernel.org/show_bug.cgi?id=86261
> > > 
> > >              Bug ID: 86261
> > >             Summary: Ipset add/restore slowed to a crawl
> > >             Product: Networking
> > >             Version: 2.5
> > >      Kernel Version: Linux debian2 3.17.0
> > >            Hardware: i386
> > >                  OS: Linux
> > >                Tree: Mainline
> > >              Status: NEW
> > >            Severity: high
> > >            Priority: P1
> > >           Component: Netfilter/Iptables
> > >            Assignee:networking_netfilter-iptables@kernel-bugs.osdl.org
> > >            Reporter:spam1@norring.dk
> > >          Regression: No
> > > 
> > > Created attachment 153751
> > >    -->https://bugzilla.kernel.org/attachment.cgi?id=153751&action=edit
> > > IP range for Afghanistan in CIDR format
> > > 
> > > The speed of adding and restoring IPs in ipset has changed drastically
> > > from
> > > kernel version 3.16.5 to 3.17.0.
> > > 
> > > 3.16.5 adds and restores attached list of IP ranges (~430 records) in 0-1
> > > seconds.
> > > 3.17.0 adds in 30s and restores in 14s.
> > > 
> > > Some of the other files I use with country IP ranges contains more than
> > > 50.000
> > > records taking hours to add/restore in kernel 3.17.
> > > 
> > > I used a clean VirtualBox Debian installation for this test.
> > > The kernels were build using default settings.
> > > 
> > > 
> > > Script:
> > > **********************
> > > #!/bin/bash
> > > IPSET=/usr/sbin/ipset
> > > IPSET_NAME=mytest
> > > 
> > > function addThem {
> > >      for IP in $(cat ./AF); do
> > >          $IPSET add $IPSET_NAME $IP
> > >      done
> > > }
> > > 
> > > ipset x
> > > 
> > > $IPSET create $IPSET_NAME hash:net
> > > 
> > > time addThem
> > > 
> > > time $IPSET save > ./saved
> > > 
> > > ipset x
> > > 
> > > time $IPSET restore < ./saved
> > > 
> > > *****************
> > 
> > I went through the ipset relates patches between 3.16 and 3.17 and see
> > nothing which could result such a performance drop. The patches either
> > fix static checker or other warnings or contain new features (skbinfo
> > extension and hash:mac set type) which looks totally independet from this.
> > (Netlink itself changed radically between the two kernel releases.)
> > 
> > So I'm going to setup an environment to check it myself.
> > 
> > Best regards,
> > Jozsef
> > -
> > E-mail  :kadlec@blackhole.kfki.hu,kadlecsik.jozsef@wigner.mta.hu
> > PGP key :http://www.kfki.hu/~kadlec/pgp_public_key.txt
> > Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
> >            H-1525 Budapest 114, POB. 49, Hungary
> > 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
