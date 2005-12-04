From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC] [PATCH] nf_conntrack_netlink port take#2
Date: Sun, 04 Dec 2005 17:22:52 +0100
Message-ID: <439317DC.7090609@trash.net>
References: <43836FFE.3020504@eurodev.net>	<200511250500.jAP50YL2008800@toshiba.co.jp>
	<200511270708.jAR78snC018182@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080303020201020305080500"
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org,
	pablo@eurodev.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200511270708.jAR78snC018182@toshiba.co.jp>
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
--------------080303020201020305080500
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Yasuyuki KOZAKAI wrote:
>>@@ -1383,6 +1550,18 @@ void nf_conntrack_cleanup(void)
>> 		schedule();
>> 		goto i_see_dead_people;
>> 	}
>>+	/* wait until all references to ip_conntrack_untracked are dropped */
>>+	while (atomic_read(&nf_conntrack_untracked.ct_general.use) > 1)
>>+		schedule();
>>+}
> 
> 
> [nfct] nice catch! I think this would better to be applied to mainline ASAP.

Agreed. I've added this patch to my tree.


--------------080303020201020305080500
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: Wait for untracked references in nf_conntrack module unload

Noticed by Pablo Neira <pablo@eurodev.net>.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 96c75906027f008ed3a4058a606938901e9c6d99
tree 87b8bb22d35f61383fbb5f4ee6164a16cc256bb3
parent aea6c7fa24378c7f38026177c0b524719789b4be
author Patrick McHardy <kaber@trash.net> Sun, 04 Dec 2005 17:22:02 +0100
committer Patrick McHardy <kaber@trash.net> Sun, 04 Dec 2005 17:22:02 +0100

 net/netfilter/nf_conntrack_core.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 1da6783..a99285d 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1383,6 +1383,9 @@ void nf_conntrack_cleanup(void)
 		schedule();
 		goto i_see_dead_people;
 	}
+	/* wait until all references to nf_conntrack_untracked are dropped */
+	while (atomic_read(&nf_conntrack_untracked.ct_general.use) > 1)
+		break;
 
 	for (i = 0; i < NF_CT_F_NUM; i++) {
 		if (nf_ct_cache[i].use == 0)

--------------080303020201020305080500--
