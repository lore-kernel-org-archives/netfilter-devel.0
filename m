From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/03]: SIP conntrack: fix skipping over user info in
	SIP headers
Date: Tue, 30 Jan 2007 19:16:30 +0100 (MET)
Message-ID: <20070130181628.25041.95732.sendpatchset@localhost.localdomain>
References: <20070130181625.25041.95438.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070130181625.25041.95438.sendpatchset@localhost.localdomain>
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

[NETFILTER]: SIP conntrack: fix skipping over user info in SIP headers

When trying to skip over the username in the Contact header, stop at the
end of the line if no @ is found to avoid mangling following headers.
We don't need to worry about continuation lines because we search inside
a SIP URI.

Fixes Netfilter Bugzilla #532.

Signed-off-by: Lars Immisch <lars@ibp.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit b54e6be6e7cc6a9dc5ec5d8876a9d04b552795e5
tree f0addf22cec7621ab515b918cab5b32df2e1b1e4
parent 0893450b69979cc8ee6ef9335bdef4f442f21e8e
author Lars Immisch <lars@ibp.de> Sun, 28 Jan 2007 00:29:58 +0100
committer Patrick McHardy <kaber@trash.net> Sun, 28 Jan 2007 00:29:58 +0100

 net/ipv4/netfilter/ip_conntrack_sip.c |    8 +++++++-
 net/netfilter/nf_conntrack_sip.c      |    8 +++++++-
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_sip.c b/net/ipv4/netfilter/ip_conntrack_sip.c
index 3a26d63..571d27e 100644
--- a/net/ipv4/netfilter/ip_conntrack_sip.c
+++ b/net/ipv4/netfilter/ip_conntrack_sip.c
@@ -283,8 +283,14 @@ static int skp_epaddr_len(const char *dp
 {
 	int s = *shift;
 
-	for (; dptr <= limit && *dptr != '@'; dptr++)
+	/* Search for @, but stop at the end of the line.
+	 * We are inside a sip: URI, so we don't need to worry about
+	 * continuation lines. */
+	while (dptr <= limit &&
+	       *dptr != '@' && *dptr != '\r' && *dptr != '\n') {
 		(*shift)++;
+		dptr++;
+	}
 
 	if (*dptr == '@') {
 		dptr++;
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index eb2a241..c93fb37 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -303,8 +303,14 @@ static int skp_epaddr_len(struct nf_conn
 {
 	int s = *shift;
 
-	for (; dptr <= limit && *dptr != '@'; dptr++)
+	/* Search for @, but stop at the end of the line.
+	 * We are inside a sip: URI, so we don't need to worry about
+	 * continuation lines. */
+	while (dptr <= limit &&
+	       *dptr != '@' && *dptr != '\r' && *dptr != '\n') {
 		(*shift)++;
+		dptr++;
+	}
 
 	if (*dptr == '@') {
 		dptr++;
