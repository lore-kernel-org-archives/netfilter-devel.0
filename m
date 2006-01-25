From: Samir Bellabes <sbellabes@mandriva.com>
Subject: [NETFILTER] nf_conntrack: fix memset() size.
Date: Wed, 25 Jan 2006 04:30:20 +0100
Message-ID: <m2hd7tass3.fsf@cerbere.dyndns.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org,
	Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
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

This patch fix a bad size in memset().
The memory handle by 'struct nf_conntrack_helper ftp[MAX_PORTS][2]' is
only set for ftp[*][0], but not for ftp[*][1].

please apply, thanks
sam


[NETFILTER] nf_conntrack: fix memset() size.

memset() don't set memory of the 'struct nf_conntrack_helper' at ftp[*][1]

Signed-off-by: Samir Bellabes <sbellabes@mandriva.com>

---
 
 net/netfilter/nf_conntrack_ftp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

applies-to: 84cf4e20ce5038cb701373c6d9f97195dfd23dfc
34b60542dcfb5fbc2f37de6157cc31d35c6b66df
diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index ab0c920..e2c9f36 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -657,7 +657,7 @@ static int __init init(void)
        /* FIXME should be configurable whether IPv4 and IPv6 FTP connections
                 are tracked or not - YK */
        for (i = 0; i < ports_c; i++) {
-               memset(&ftp[i], 0, sizeof(struct nf_conntrack_helper));
+               memset(&ftp[i], 0, 2*sizeof(struct nf_conntrack_helper));
                
                ftp[i][0].tuple.src.l3num = PF_INET;
                ftp[i][1].tuple.src.l3num = PF_INET6;
