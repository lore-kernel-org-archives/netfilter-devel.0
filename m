From: KOVACS Krisztian <hidden@balabit.hu>
Subject: ct_sync documentation and complete patch set in CVS
Date: Mon, 12 Jul 2004 17:20:37 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1089645637.4088.105.camel@nienna.balabit>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter-failover list <netfilter-failover@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


  Hi,

  As of today, an (almost) complete distribution of ct_sync is available
from the Netfilter CVS. With todays commits, I think everything needed
for testing is available from the CVS module 'netfilter-ha'.

  A few smaller changes were done to the code itself, but the more
important addons are my complete patch set needed by ct_sync, and the
update of the README to include instructions on patching and setting up
your kernel tree.

  Unfortunately, there are still quite a few bugs in the code, but I
think ct_sync is in a state in which more wide-scale testing and would
do good for the project. So, everyone interested in the current stateful
failover code for Netfilter should take a look at netfilter-ha module of
the Netfilter CVS repository. (http://cvs.netfilter.org/netfilter-ha/)

  WARNING: this code is still far from being complete, and contains
known bugs and weaknesses. It is not ready for production use, and the
code is under active development. However, to speed up the progress,
some help would be needed. So, anyone feeling brave enough to try
ct_sync and submit bug reports is welcome.

-- 
 Regards,
   Krisztian KOVACS
