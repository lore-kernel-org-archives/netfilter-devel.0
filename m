From: KOVACS Krisztian <hidden@balabit.hu>
Subject: [PATCH 0/3] CLUSTERIP: Multiple CLUSTERIP patches
Date: Tue, 30 Aug 2005 14:15:36 +0200
Message-ID: <20050830121535.985929000@nienna.balabit>
Cc: Harald Welte <laforge@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

  I've created three patches for CLUSTERIP. The first two are bug fixes,
while the third one tries to make CLUSTERIP more efficient by changing the
internal representation of the nodes we're responsible for.

  I'd be especially thankful for comments on the second and third patches.
The second patch changes the management of config entries significantly
and it's a very error prone area anyway. The third patch probably needs
more discussion, I seems to work, but some of this seq_file thing is still
a mistery for me... :)

--
 Regards,
  Krisztian Kovacs
