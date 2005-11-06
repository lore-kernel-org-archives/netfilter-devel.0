From: KOVACS Krisztian <hidden@balabit.hu>
Subject: [PATCH] nf_conntrack: re-add missing bits to the TCP conntrack
	module
Date: Sun, 6 Nov 2005 22:16:50 +0100
Message-ID: <200511062216.53619.hidden@balabit.hu>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_FLnbDsfUsYEpuTA"
Cc: Harald Welte <laforge@netfilter.org>,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
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

--Boundary-00=_FLnbDsfUsYEpuTA
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


  Hi,

  I've spent some time playing with nfsim again. With some modifications 
of the testsuite I've been finally able to run almost all of the 
conntrack tests through nf_conntrack. (I've skipped the FTP tests 
because that needs some more work to compile in nfsim.)

  The results: with the attached patch applied all tests succeeded! :)
Unfortunately I was unable to get coverage information due to gcov's 
lack of support for .so files...

  Please review the attached patch and apply if you find it appropriate.

-- 
 Regards,
  Krisztian Kovacs

--Boundary-00=_FLnbDsfUsYEpuTA
Content-Type: text/x-diff; charset="us-ascii";
	name="04-nf_conntrack-add_missing_bits_to_tcp_module.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="04-nf_conntrack-add_missing_bits_to_tcp_module.patch"

[NETFILTER] Add missing code to TCP conntrack module

Looks like the nf_conntrack TCP code was slightly mismerged: it does
not contain an else branch present in the IPv4 version. Let's add that
code and make the testsuite happy.

Signed-off-by: KOVACS Krisztian <hidden@balabit.hu>

---
commit a1499bbf50e4c2807f155a5caa4efd3dadce03a8
tree 803a32e5a682fdaae7ace66685f995189f39d79e
parent 2e4a1678c0318035c131ca36a701f0fd0c9d0cc9
author KOVACS Krisztian <hidden@balabit.hu> Sun, 06 Nov 2005 21:06:47 +0100
committer KOVACS Krisztian <hidden@balabit.hu> Sun, 06 Nov 2005 21:06:47 +0100

 net/netfilter/nf_conntrack_proto_tcp.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index b5ba5d9..c440845 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -977,6 +977,12 @@ static int tcp_packet(struct nf_conn *co
 		    		conntrack->timeout.function((unsigned long)
 		    					    conntrack);
 		    	return -NF_REPEAT;
+		} else {
+			write_unlock_bh(&tcp_lock);
+			if (LOG_INVALID(IPPROTO_TCP))
+				nf_log_packet(pf, 0, skb, NULL, NULL,
+					      NULL, "nf_ct_tcp: invalid SYN");
+			return -NF_ACCEPT;
 		}
 	case TCP_CONNTRACK_CLOSE:
 		if (index == TCP_RST_SET

--Boundary-00=_FLnbDsfUsYEpuTA--
