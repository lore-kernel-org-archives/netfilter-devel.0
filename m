From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] --log-ip-options broken in 2.4
Date: Fri, 04 Mar 2005 11:39:10 +0100
Message-ID: <42283ACE.1080006@trash.net>
References: <20050129070423.GA25755@orthanc.gambrl01.md.comcast.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080503010202020106010600"
Cc: netfilter-devel@lists.netfilter.org
To: Michael Rash <mbr@cipherdyne.org>
In-Reply-To: <20050129070423.GA25755@orthanc.gambrl01.md.comcast.net>
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
--------------080503010202020106010600
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Michael Rash wrote:
> It looks like --log-ip-options is broken in 2.4, i.e. the OPT field
> never appears in Netfilter logs even when packets contain IP options.
> I have attached a small patch that fixes this.  It removes the
> "iph->ihl * 4 >= datalen" condition, which rarely happens ("ping -T
> tsonly -s 1 <host>" will trigger it for example).  The resulting code is
> analogous to the code in the 2.6 kernel.

In 2.6 the size of the area is verfied by skb_header_pointer, we
need to do this manually in 2.4. I'm going to submit the attached
patch for this problem.

Regards
Patrick

--------------080503010202020106010600
Content-Type: text/x-patch;
 name="08.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="08.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2005/03/04 11:36:23+01:00 kaber@coreworks.de 
#   [NETFILTER]: Fix IP/TCP option logging
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ipt_LOG.c
#   2005/03/04 11:35:42+01:00 kaber@coreworks.de +4 -3
#   [NETFILTER]: Fix IP/TCP option logging
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv4/netfilter/ipt_LOG.c b/net/ipv4/netfilter/ipt_LOG.c
--- a/net/ipv4/netfilter/ipt_LOG.c	2005-03-04 11:37:01 +01:00
+++ b/net/ipv4/netfilter/ipt_LOG.c	2005-03-04 11:37:01 +01:00
@@ -67,8 +67,8 @@
 		printk("FRAG:%u ", ntohs(iph->frag_off) & IP_OFFSET);
 
 	if ((info->logflags & IPT_LOG_IPOPT)
-	    && iph->ihl * 4 != sizeof(struct iphdr)
-	    && iph->ihl * 4 >= datalen) {
+	    && iph->ihl * 4 > sizeof(struct iphdr)
+	    && iph->ihl * 4 <= len) {
 		unsigned int i;
 
 		/* Max length: 127 "OPT (" 15*4*2chars ") " */
@@ -126,7 +126,8 @@
 		printk("URGP=%u ", ntohs(tcph->urg_ptr));
 
 		if ((info->logflags & IPT_LOG_TCPOPT)
-		    && tcph->doff * 4 != sizeof(struct tcphdr)) {
+		    && tcph->doff * 4 > sizeof(struct tcphdr)
+		    && tcph->doff * 4 <= datalen) {
 			unsigned int i;
 
 			/* Max length: 127 "OPT (" 15*4*2chars ") " */

--------------080503010202020106010600--
