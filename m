From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [4/3] OSF: typo fix.
Date: Mon, 30 May 2005 00:13:03 +0400
Message-ID: <20050530001303.5b1c51c4@zanzibar.2ka.mipt.ru>
Reply-To: johnpol@2ka.mipt.ru
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>
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

Connector message has wrong length parameter.

Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

--- orig/osf/linux-2.6/net/ipv4/netfilter/ipt_osf.c
+++ mod/osf/linux-2.6/net/ipv4/netfilter/ipt_osf.c
@@ -117,7 +117,7 @@
 	memcpy(&m->id, &osf_id, sizeof(m->id));
 	m->seq = osf_seq++;
 	m->ack = 0;
-	m->len = sizeof(*f);
+	m->len = sizeof(*data);
 	
 	memcpy(&data->f, f, sizeof(struct osf_finger));
 	memcpy(&data->ip, sk->nh.iph, sizeof(struct iphdr));





	Evgeniy Polyakov

Only failure makes us experts. -- Theo de Raadt
