From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: ECN target corrupts packets (2.6 only)
Date: Sun, 02 Jan 2005 22:04:48 +0100
Message-ID: <41D861F0.8000303@trash.net>
References: <1104664660.17292.19.camel@localhost.localdomain>
	<1625859504.20050102160729@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070800020502000302080305"
Cc: Rusty Russell <rusty@rustcorp.com.au>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Maciej Soltysiak <solt@dns.toxicfilms.tv>
In-Reply-To: <1625859504.20050102160729@dns.toxicfilms.tv>
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
--------------070800020502000302080305
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Maciej Soltysiak wrote:

>>Nasty bug, caught while writing the ECN target test.  Corrupts
>>checksums of packets when target is used on them.
>>    
>>
>>Let this be a warning on the evils of casts.
>>    
>>
>Heh, so that's why ECN stopped working for me :-)
>I will check that out.
>
>I did tcpdumps but for some strange reason I could not see
>the problem there. Maybe tcpdump got premangled packets..
>  
>
There's more brokeness, it mangles the tcp header before making
it writable and doesn't reload pointers after doing so. This patch
should fix all of it and as a side-effect avoids some useless
copying. Any voluteers for testing ? :)

Regards
Patrick


--------------070800020502000302080305
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

===== net/ipv4/netfilter/ipt_ECN.c 1.11 vs edited =====
--- 1.11/net/ipv4/netfilter/ipt_ECN.c	2004-10-26 01:10:25 +02:00
+++ edited/net/ipv4/netfilter/ipt_ECN.c	2005-01-02 22:00:14 +01:00
@@ -61,31 +61,28 @@
 	if (th == NULL)
 		return 0;
 
-	diffs[0] = ((u_int16_t *)th)[6];
-	if (einfo->operation & IPT_ECN_OP_SET_ECE)
-		th->ece = einfo->proto.tcp.ece;
-
-	if (einfo->operation & IPT_ECN_OP_SET_CWR)
-		th->cwr = einfo->proto.tcp.cwr;
-	diffs[1] = ((u_int16_t *)&th)[6];
-
-	/* Only mangle if it's changed. */
-	if (diffs[0] != diffs[1]) {
-		diffs[0] = diffs[0] ^ 0xFFFF;
+	if ((einfo->operation & IPT_ECN_OP_SET_ECE &&
+	     th->ece != einfo->proto.tcp.ece) ||
+	    (einfo->operation & IPT_ECN_OP_SET_CWR &&
+	     th->cwr != einfo->proto.tcp.cwr)) {
 		if (!skb_ip_make_writable(pskb,
 					  (*pskb)->nh.iph->ihl*4+sizeof(_tcph)))
 			return 0;
+		th = (void *)(*pskb)->nh.iph + (*pskb)->nh.iph->ihl*4;
 
-		if (th != &_tcph)
-			memcpy(&_tcph, th, sizeof(_tcph));
+		diffs[0] = ((u_int16_t *)th)[6];
+		if (einfo->operation & IPT_ECN_OP_SET_ECE)
+			th->ece = einfo->proto.tcp.ece;
+		if (einfo->operation & IPT_ECN_OP_SET_CWR)
+			th->cwr = einfo->proto.tcp.cwr;
+		diffs[1] = ((u_int16_t *)th)[6];
+		diffs[0] = diffs[0] ^ 0xFFFF;
 
 		if ((*pskb)->ip_summed != CHECKSUM_HW)
-			_tcph.check = csum_fold(csum_partial((char *)diffs,
-							     sizeof(diffs),
-							     _tcph.check^0xFFFF));
-		memcpy((*pskb)->data + (*pskb)->nh.iph->ihl*4,
-		       &_tcph, sizeof(_tcph));
-		if ((*pskb)->ip_summed == CHECKSUM_HW)
+			th->check = csum_fold(csum_partial((char *)diffs,
+			                      sizeof(diffs),
+			                      th->check^0xFFFF));
+		else
 			if (skb_checksum_help(*pskb, inward))
 				return 0;
 		(*pskb)->nfcache |= NFC_ALTERED;

--------------070800020502000302080305--
