From: Matt Walters <mattw@parasun.com>
Subject: libipq scaling
Date: Wed, 04 Aug 2004 15:30:43 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1091658643.32021.91.camel@marx.mindlink.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hey all-

	We're considering using netfilter to do some packet filtering/tagging
based on external information, and it seems like libipq is the best way
to do it.  I'm wondering if there are any issues with using this tool in
an environment where sustained 30Mbit/s throughput is to be expected. 
The target platform is a dual Xeon 2.8 with gobs of memory, 2.6.7
kernel.

	Has anyone experimented with it?  If not, when we do some performance
testing, is anyone interested in the results?

	Thanks,

-Matt
