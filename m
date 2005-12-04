From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] nfnetlink: Fix calculation of minimum message length
Date: Sun, 04 Dec 2005 16:28:36 +0100
Message-ID: <43930B24.6060206@trash.net>
References: <200512031652.jB3GqhbB021984@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080009000407060100080709"
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200512031652.jB3GqhbB021984@toshiba.co.jp>
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

This is a multi-part message in MIME format.
--------------080009000407060100080709
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Yasuyuki KOZAKAI wrote:
> Hi,
> 
> At least, valid nfnetlink message should have nlmsghdr and nfgenmsg.

Also applied, thanks. I've also changed the check in
nfnetlink_rcv_msg(), which was a self-built construct for NLMSG_SPACE.

--------------080009000407060100080709
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER] nfnetlink: Fix calculation of minimum message length

At least, valid nfnetlink message should have nlmsghdr and nfgenmsg.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 1ec1f9de65434db4bac6141e25c5b8a6b5110e4f
tree 0eaed90532d67c3ba3281628bfbd256f5cc1163d
parent e512e47b2238a9e367f05a36b4ac2ba53f5ad12e
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sun, 04 Dec 2005 16:26:36 +0100
committer Patrick McHardy <kaber@trash.net> Sun, 04 Dec 2005 16:26:36 +0100

 net/netfilter/nfnetlink.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index a60c59b..95fdf04 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -162,7 +162,7 @@ nfnetlink_check_attributes(struct nfnetl
 		return -EINVAL;
 	}
 
-	min_len = NLMSG_ALIGN(sizeof(struct nfgenmsg));
+	min_len = NLMSG_SPACE(sizeof(struct nfgenmsg));
 	if (unlikely(nlh->nlmsg_len < min_len))
 		return -EINVAL;
 
@@ -236,8 +236,7 @@ static inline int nfnetlink_rcv_msg(stru
 	}
 
 	/* All the messages must at least contain nfgenmsg */
-	if (nlh->nlmsg_len < 
-			NLMSG_LENGTH(NLMSG_ALIGN(sizeof(struct nfgenmsg)))) {
+	if (nlh->nlmsg_len < NLMSG_SPACE(sizeof(struct nfgenmsg))) {
 		DEBUGP("received message was too short\n");
 		return 0;
 	}

--------------080009000407060100080709--
