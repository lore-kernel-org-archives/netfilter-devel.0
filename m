From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipset-6.2 testsuite failure
Date: Thu, 7 Apr 2011 21:10:11 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1104072059250.22730@blackhole.kfki.hu>
References: <alpine.LNX.2.01.1104071453410.19048@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:50365 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756677Ab1DGTKN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Apr 2011 15:10:13 -0400
In-Reply-To: <alpine.LNX.2.01.1104071453410.19048@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 7 Apr 2011, Jan Engelhardt wrote:

> Using 2.6.39-rc1+ (kaber/nf-next) with ipset-6.2 (plain, nfnetlink):
> 
> jng-0:/home/jengelh/code/ipset/tests # ./runtest.sh 
> which: no sendip in 
> (/root/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:/usr/X11R6/bin:/opt/hxtools/bin)
> sendip utility is missig: skipping inet match and target tests
> which: no sendip in 
> (/root/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:/usr/X11R6/bin:/opt/hxtools/bin)
> sendip utility is missig: skipping inet6 match and target tests
> init: Load in the ip_set kernel module: passed
> init: List our test set: the testsuite fails if it exists: passed
> init: Delete our test set: the testsuite fails if it exists: passed
> init: Check mandatory create arguments: passed
> ipmap: Range: Check syntax error: missing range/from-to: passed
> ipmap: Range: Check syntax error: missing --from: passed
> ipmap: Range: Check syntax error: missing --to: passed
> ipmap: Range: Catch invalid IPv4 address: passed
> ipmap: Range: Try to create from an invalid range: passed
> ipmap: Range: Create a set from a valid range: passed
> ipmap: Range: Add lower boundary: passed
> ipmap: Range: Add upper boundary: passed
> ipmap: Range: Test lower boundary: passed
> ipmap: Range: Test upper boundary: passed
> ipmap: Range: Test element not added to the set: passed
> ipmap: Range: Test element before lower boundary: passed
> ipmap: Range: Test element after upper boundary: passed
> ipmap: Range: Try to add element before lower boundary: passed
> ipmap: Range: Try to add element after upper boundary: passed
> ipmap: Range: Delete element not added to the set: passed
> ipmap: Range: Add element in the middle: passed
> ipmap: Range: Delete the same element: passed
> ipmap: Range: Add a range of elements: passed
> ipmap: Range: Save set: passed
> ipmap: Range: Destroy set: passed
> ipmap: Range: Restore set and catch error: passed
> ipmap: Range: Check returned error line number: passed
> ipmap: Range: Destroy set: passed
> ipmap: Range: Restore set: passed
> ipmap: Range: List set: passed
> ipmap: Range: Check listing: passed
> ipmap: Range: Delete a range of elements: passed
> ipmap: Range: List set: passed
> ipmap: Range: Check listing: passed
> ipmap: Range: Flush test set: passed
> ipmap: Range: Delete test set: passed
> ipmap: Network: Try to create a set from an invalid network: passed
> ipmap: Network: Create a set from a valid network: passed
> ipmap: Network: Add lower boundary: passed
> ipmap: Network: Add upper boundary: passed
> ipmap: Network: Test lower boundary: passed
> ipmap: Network: Test upper boundary: passed
> ipmap: Network: Test element not added to the set: passed
> ipmap: Network: Test element before lower boundary: passed
> ipmap: Network: Test element after upper boundary: passed
> ipmap: Network: Try to add element before lower boundary: passed
> ipmap: Network: Try to add element after upper boundary: passed
> ipmap: Network: Delete element not added to the set: passed
> ipmap: Network: Add element in the middle: passed
> ipmap: Network: Delete the same element: passed
> ipmap: Network: List set: passed
> ipmap: Network: Check listing: passed
> ipmap: Network: Flush test set: passed
> ipmap: Network: Delete test set: passed
> ipmap: Subnets: Create a set to store networks: passed
> ipmap: Subnets: Add lower boundary: passed
> ipmap: Subnets: Add upper boundary: passed
> ipmap: Subnets: Test lower boundary: passed
> ipmap: Subnets: Test upper boundary: passed
> ipmap: Subnets: Test element not added to the set: passed
> ipmap: Subnets: Test element before lower boundary: passed
> ipmap: Subnets: Test element after upper boundary: passed
> ipmap: Subnets: Try to add element before lower boundary: passed
> ipmap: Subnets: Try to add element after upper boundary: passed
> ipmap: Subnets: Try to delete element not added to the set: passed
> ipmap: Subnets: Add element to the set: passed
> ipmap: Subnets: Delete the same element from the set: passed
> ipmap: Subnets: Add a subnet of subnets: passed
> ipmap: Subnets: List set: passed
> ipmap: Subnets: Check listing: passed
> ipmap: Subnets: FLush test set: passed
> ipmap: Subnets: Delete test set: passed
> ipmap: Full: Create full IPv4 space with /16 networks: passed
> ipmap: Full: Add lower boundary: passed
> ipmap: Full: Add upper boundary: passed
> ipmap: Full: Test lower boundary: passed
> ipmap: Full: Test upper boundary: passed
> ipmap: Full: Test element not added to the set: passed
> ipmap: Full: Delete element not added to the set: passed
> ipmap: Full: Add element to the set: passed
> hash:ip6: IP: Flush test set: passed
> hash:ip6: IP: Try to add multiple elements in one step: passed
> hash:ip6: IP: Delete test set: passed
> hash:ip6: Network: Create a set with timeout: passed
> hash:ip6: Network: Add zero valued element: passed
> hash:ip6: Network: Test zero valued element: passed
> hash:ip6: Network: Delete zero valued element: passed
> hash:ip6: Network: Add first random network: passed
> hash:ip6: Network: Add second random network: passed
> hash:ip6: Network: Test first random value: passed
> hash:ip6: Network: Test second random value: passed
> hash:ip6: Network: Test value not added to the set: passed
> hash:ip6: Network: Add third element: passed
> hash:ip6: Network: Add third random network: passed
> hash:ip6: Network: Delete the same network: passed
> hash:ip6: Network: Test the deleted network: passed
> hash:ip6: Network: List set: passed
> hash:ip6: Network: Check listing: passed
> hash:ip6: Sleep 5s so that elements can time out: passed
> hash:ip6: Network: List set: passed
> hash:ip6: Network: Check listing: 6a7
> > 200:100:10:: timeout 0
> FAILED
> Failed test: diff -I 'Size in memory.*' .foo hash:ip6.t.list1 && rm .foo
> jng-0:/home/jengelh/code/ipset/tests # 

I was unable to reproduce this with the kernel from Patrick's tree and 
with ipset-6.2.

However, in the testsuite of ipset-6.2 the hash:ip6 tests are not executed 
just after the ipmap tests: there are missing tests in the listing above.

Also, the testsuite in ipset-6.2 contains the tests against the kernel in 
the package itself: the patches I have submitted today are missing from 
2.6.39-rc1+ but the testsuite checks the functionality of the patches, and 
therefore it'd fail with 2.6.39-rc1+ (but at other tests, not at the one 
above).

If you feel I missed something, just let me know.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
