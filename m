From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nf-failover] Oops in ctnetlink_create_conntrack
Date: Sat, 13 Jan 2007 17:45:03 +0100
Message-ID: <45A90C8F.9030202@netfilter.org>
References: <200701130319.30347.simonl@parknet.dk>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020805050809010102080207"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	netfilter-failover@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Simon Lodal <simonl@parknet.dk>
In-Reply-To: <200701130319.30347.simonl@parknet.dk>
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
--------------020805050809010102080207
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Simon Lodal wrote:
> I got an oops in ctnetlink_create_conntrack when running 'conntrackd -c', with 
> a 'conntrackd -d' running. I hope this is the right place to report this bug.
> 
> Trigger: Executed 'conntrackd -c' twice. First time it succeeded, second time 
> it produced an oops.
> Reproducible: Yes, every time.
> [...]
> EIP: [<4029f2a7>] ctnetlink_create_conntrack+0x6e/0x3a7 SS:ESP 0068:5fbc1bb8

Does the patch attached fix the problem that you're reporting? It was
already committed to the upcoming 2.6.20 [1]

[1]
http://lists.netfilter.org/pipermail/netfilter-devel/2006-November/026212.html

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------020805050809010102080207
Content-Type: text/plain;
 name="02fixstatus.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02fixstatus.patch"

[CTNETLINK] Check for status flags existence on conntrack creation

Check that status flags are available in the netlink message received 
to create a new conntrack.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: linux-2.6.git/net/ipv4/netfilter/ip_conntrack_netlink.c
===================================================================
--- linux-2.6.git.orig/net/ipv4/netfilter/ip_conntrack_netlink.c	2006-11-08 23:54:28.000000000 +0100
+++ linux-2.6.git/net/ipv4/netfilter/ip_conntrack_netlink.c	2006-11-08 23:54:55.000000000 +0100
@@ -945,9 +945,11 @@ ctnetlink_create_conntrack(struct nfattr
 	ct->timeout.expires = jiffies + ct->timeout.expires * HZ;
 	ct->status |= IPS_CONFIRMED;
 
-	err = ctnetlink_change_status(ct, cda);
-	if (err < 0)
-		goto err;
+	if (cda[CTA_STATUS-1]) {
+		err = ctnetlink_change_status(ct, cda);
+		if (err < 0)
+			goto err;
+	}
 
 	if (cda[CTA_PROTOINFO-1]) {
 		err = ctnetlink_change_protoinfo(ct, cda);
Index: linux-2.6.git/net/netfilter/nf_conntrack_netlink.c
===================================================================
--- linux-2.6.git.orig/net/netfilter/nf_conntrack_netlink.c	2006-11-08 23:55:06.000000000 +0100
+++ linux-2.6.git/net/netfilter/nf_conntrack_netlink.c	2006-11-08 23:55:49.000000000 +0100
@@ -961,9 +961,11 @@ ctnetlink_create_conntrack(struct nfattr
 	ct->timeout.expires = jiffies + ct->timeout.expires * HZ;
 	ct->status |= IPS_CONFIRMED;
 
-	err = ctnetlink_change_status(ct, cda);
-	if (err < 0)
-		goto err;
+	if (cda[CTA_STATUS-1]) {
+		err = ctnetlink_change_status(ct, cda);
+		if (err < 0)
+			goto err;
+	}
 
 	if (cda[CTA_PROTOINFO-1]) {
 		err = ctnetlink_change_protoinfo(ct, cda);

--------------020805050809010102080207--
