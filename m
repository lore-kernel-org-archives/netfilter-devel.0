From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] ctnetlink: Fix dumping of helper name.
Date: Tue, 03 Jan 2006 13:48:33 +0100
Message-ID: <43BA72A1.2080108@trash.net>
References: <43B1434C.8000005@ingate.com> <43B145AD.4040108@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030502060306060509000409"
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org,
	Marcus Sundberg <marcus@ingate.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@eurodev.net>
In-Reply-To: <43B145AD.4040108@eurodev.net>
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
--------------030502060306060509000409
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Pablo Neira Ayuso wrote:
> Marcus Sundberg wrote:
> 
>>this patch fixes ctnetlink dumping of the helper name.

I changed it to dump the same way as nf_conntrack_netlink instead,
without the unneccessary length limitation. Not that it actually
matters with realistic helper names but I'd like both to be compatible.

> @Patrick: JFYI, this bug doesn't affect nf_conntrack_netlink, so we
> don't need a patch for it.

Thanks for the information.

--------------030502060306060509000409
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: ctnetlink: Fix dumping of helper name

Properly dump the helper name instead of internal kernel data.
Based on patch by Marcus Sundberg <marcus@ingate.com>.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 327321f46f976c5392990351e318ea17255d5abe
tree 1cddbb78a4a9c565d4ee23c8b95e5acff78ca853
parent a728f5f4607dde215e48f7415d9209e450f434f0
author Patrick McHardy <kaber@trash.net> Tue, 03 Jan 2006 13:45:53 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 03 Jan 2006 13:45:53 +0100

 include/linux/netfilter/nfnetlink_conntrack.h |    2 --
 net/ipv4/netfilter/ip_conntrack_netlink.c     |    2 +-
 2 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink_conntrack.h b/include/linux/netfilter/nfnetlink_conntrack.h
index b8e9a5b..668ec94 100644
--- a/include/linux/netfilter/nfnetlink_conntrack.h
+++ b/include/linux/netfilter/nfnetlink_conntrack.h
@@ -131,6 +131,4 @@ enum ctattr_help {
 };
 #define CTA_HELP_MAX (__CTA_HELP_MAX - 1)
 
-#define CTA_HELP_MAXNAMESIZE	32
-
 #endif /* _IPCONNTRACK_NETLINK_H */
diff --git a/net/ipv4/netfilter/ip_conntrack_netlink.c b/net/ipv4/netfilter/ip_conntrack_netlink.c
index 91fe8f2..b1c3eca 100644
--- a/net/ipv4/netfilter/ip_conntrack_netlink.c
+++ b/net/ipv4/netfilter/ip_conntrack_netlink.c
@@ -160,7 +160,7 @@ ctnetlink_dump_helpinfo(struct sk_buff *
 		return 0;
 		
 	nest_helper = NFA_NEST(skb, CTA_HELP);
-	NFA_PUT(skb, CTA_HELP_NAME, CTA_HELP_MAXNAMESIZE, &ct->helper->name);
+	NFA_PUT(skb, CTA_HELP_NAME, strlen(ct->helper->name), ct->helper->name);
 
 	if (ct->helper->to_nfattr)
 		ct->helper->to_nfattr(skb, ct);

--------------030502060306060509000409--
