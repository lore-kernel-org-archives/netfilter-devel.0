From: Max Kellermann <max@duempel.org>
Subject: [ANNOUNCEMENT] h323-conntrack-nat nfsim testsuite
Date: Wed, 11 May 2005 21:06:14 +0200
Message-ID: <20050511190614.GA13967@roonstrasse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

finally, I have released my test suite for the h323-conntrack-nat
module. You can download it on my home page:

 http://max.kellermann.name/projects/netfilter/h323.html
 http://max.kellermann.name/download/netfilter/h323/20050511/h323-conntrack-nat-testsuite-20050511.tar.bz2

The test suite succeeds only when you have applied all
h323-conntrack-nat patches which I have published since yesterday on
this mailing list (a big patch containing them all is on the
homepage). It also requires a patched nfsim, patches can be downloaded
here:

 http://max.kellermann.name/projects/netfilter/nfsim.html

I'd also like to discuss these nfsim patches again. I posted them
several months ago, but nobody seemed to care.

Max
