From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipset: bad timeout assignments
Date: Fri, 10 Oct 2014 18:58:50 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1410101856580.21928@blackhole.kfki.hu>
References: <20141010085621.GA9211@pc11.op.pod.cz> <alpine.DEB.2.10.1410101256230.18124@blackhole.kfki.hu> <20141010111404.GA15011@pc11.op.pod.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Vitezslav Samel <vitezslav@samel.cz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:59964 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751594AbaJJQ6X (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Oct 2014 12:58:23 -0400
In-Reply-To: <20141010111404.GA15011@pc11.op.pod.cz>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 10 Oct 2014, Vitezslav Samel wrote:

> On Fri, Oct 10, 2014 at 01:04:03PM +0200, Jozsef Kadlecsik wrote:
> > On Fri, 10 Oct 2014, Vitezslav Samel wrote:
> > 
> > >   I'm using ipset's hash:ip with timeout to ban bad behaving clients.
> > > When using very long timeout ( > 2147483 ) the ipset's timeout gets
> > > weird:
> > > 
> > > -- TEST 1 ----------------
> > > + uname -r
> > > 3.15.6
> > > + ipset --version
> > > ipset v6.23, protocol version: 6
> > > + ipset create test hash:ip timeout 1111111
> > > + ipset add test 10.0.0.1
> > > + ipset add test 10.0.0.2 timeout 2000000
> > > + ipset add test 10.0.0.3 timeout 3000000
> > > + ipset list test
> > > Name: test
> > > Type: hash:ip
> > > Revision: 3
> > > Header: family inet hashsize 1024 maxelem 65536 timeout 1111111
> > > Size in memory: 16720
> > > References: 0
> > > Members:
> > > 10.0.0.1 timeout 1111111
> > > 10.0.0.2 timeout 2000000
> > > 10.0.0.3 timeout 4294967
> > > + ipset destroy test
> > > --------------------------
> > > 
> > > The 10.0.0.3 gets 4294967 timeout although I wanted timeout 3000000.
> > > 
> > > With hash:ip default timeout being >2147483 the test looks like this:
> > > 
> > > -- TEST 2 ----------------
> > > + ipset create test2 hash:ip timeout 3333333
> > > + ipset add test2 10.0.0.1
> > > + ipset add test2 10.0.0.2 timeout 2000000
> > > + ipset add test2 10.0.0.3 timeout 3000000
> > > + ipset list test2
> > > Name: test2
> > > Type: hash:ip
> > > Revision: 3
> > > Header: family inet hashsize 1024 maxelem 65536 timeout 3333333
> > > Size in memory: 16720
> > > References: 0
> > > Members:
> > > 10.0.0.1 timeout 4294967
> > > 10.0.0.2 timeout 2000000
> > > 10.0.0.3 timeout 4294967
> > > + ipset destroy test2
> > > --------------------------
> > > 
> > > Now 10.0.0.1 gets wrong timeout and 10.0.0.3 also.
> > > The magic number 2147483 is (UINT_MAX/1000)/2 which makes me think this
> > > is some signed/unsigned int problem somewhere.
> > > 
> > > The above tests were run on x86_64 machine; the same problem is on i686,
> > > but wrongly assigned timeout is 2147483 instead of 4294967.
> > > 
> > > I also tried 3.16.2 kernel, but the bug is here too.
> > 
> > Too large jiffies are converted automatically to MAX_JIFFY_OFFSET (i.e. 
> > ((LONG_MAX >> 1)-1)). That's a limitation in the kernel which cannot be 
> > worked around. The only thing I could do is not to accept too large 
> > timeout values.
> 
>   Even on machines with 64-bit long? That is weird.

You are right, I'll look into it. Part of the problem comes from a bad 
protocol decision, because ipset passes timeout values as an u32 value 
between userspace and kernel.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
