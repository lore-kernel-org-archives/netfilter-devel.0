From: Vitezslav Samel <vitezslav@samel.cz>
Subject: ipset: bad timeout assignments
Date: Fri, 10 Oct 2014 10:56:21 +0200
Message-ID: <20141010085621.GA9211@pc11.op.pod.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.pod.cz ([213.155.227.146]:54777 "EHLO mail.pod.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744AbaJJJGN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Oct 2014 05:06:13 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

	Hi!

  I'm using ipset's hash:ip with timeout to ban bad behaving clients.
When using very long timeout ( > 2147483 ) the ipset's timeout gets
weird:

-- TEST 1 ----------------
+ uname -r
3.15.6
+ ipset --version
ipset v6.23, protocol version: 6
+ ipset create test hash:ip timeout 1111111
+ ipset add test 10.0.0.1
+ ipset add test 10.0.0.2 timeout 2000000
+ ipset add test 10.0.0.3 timeout 3000000
+ ipset list test
Name: test
Type: hash:ip
Revision: 3
Header: family inet hashsize 1024 maxelem 65536 timeout 1111111
Size in memory: 16720
References: 0
Members:
10.0.0.1 timeout 1111111
10.0.0.2 timeout 2000000
10.0.0.3 timeout 4294967
+ ipset destroy test
--------------------------

The 10.0.0.3 gets 4294967 timeout although I wanted timeout 3000000.

With hash:ip default timeout being >2147483 the test looks like this:

-- TEST 2 ----------------
+ ipset create test2 hash:ip timeout 3333333
+ ipset add test2 10.0.0.1
+ ipset add test2 10.0.0.2 timeout 2000000
+ ipset add test2 10.0.0.3 timeout 3000000
+ ipset list test2
Name: test2
Type: hash:ip
Revision: 3
Header: family inet hashsize 1024 maxelem 65536 timeout 3333333
Size in memory: 16720
References: 0
Members:
10.0.0.1 timeout 4294967
10.0.0.2 timeout 2000000
10.0.0.3 timeout 4294967
+ ipset destroy test2
--------------------------

Now 10.0.0.1 gets wrong timeout and 10.0.0.3 also.
The magic number 2147483 is (UINT_MAX/1000)/2 which makes me think this
is some signed/unsigned int problem somewhere.

The above tests were run on x86_64 machine; the same problem is on i686,
but wrongly assigned timeout is 2147483 instead of 4294967.

I also tried 3.16.2 kernel, but the bug is here too.

  Could you, please, have a look at this problem?

	Thanks,

		Vita
