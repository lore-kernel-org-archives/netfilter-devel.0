From: Patrick McHardy <kaber@trash.net>
Subject: Re: [BK PATCH] Fix ip_conntrack_amanda data corruption bug that
 breaks amanda dumps
Date: Fri, 05 Nov 2004 00:53:22 +0100
Message-ID: <418AC0F2.7020508@trash.net>
References: <20041104121522.GA16547@merlin.emma.line.org>
	<418A7B0B.7040803@trash.net>
	<20041104231734.GA30029@merlin.emma.line.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050109020206080500040208"
Cc: linux-net@vger.kernel.org, netfilter-devel@lists.netfilter.org,
	linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Matthias Andree <matthias.andree@gmx.de>
In-Reply-To: <20041104231734.GA30029@merlin.emma.line.org>
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
--------------050109020206080500040208
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Matthias Andree wrote:

>On Thu, 04 Nov 2004, Patrick McHardy wrote:
>
>>The data that is changed is only a copy, the actual packet is not touched.
>>    
>>
>
>Why then does the application not see the packets as long as
>ip_conntrack_amanda is loaded and starts seeing them again as soon as
>"rmmod ip_conntrack_amanda" has completed?
>  
>

Your observation and your patch were correct, thanks. It is supposed
to be just a copy, I missed that it wasn't anymore. While your patch
works too, and is even faster with non-linear skbs, I don't like the
idea of using the skb as a scratch-area, so I sent this patch to Dave
instead.

Regards
Patrick


--------------050109020206080500040208
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/11/04 22:50:11+01:00 kaber@coreworks.de 
#   [NETFILTER]: Don't use skb_header_pointer in amanda conntrack helper
#   
#   Fixes broken packets, noticed by Matthias Andree <matthias.andree@gmx.de>
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_conntrack_amanda.c
#   2004/11/04 22:50:04+01:00 kaber@coreworks.de +5 -7
#   [NETFILTER]: Don't use skb_header_pointer in amanda conntrack helper
#   
#   Fixes broken packets, noticed by Matthias Andree <matthias.andree@gmx.de>
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv4/netfilter/ip_conntrack_amanda.c b/net/ipv4/netfilter/ip_conntrack_amanda.c
--- a/net/ipv4/netfilter/ip_conntrack_amanda.c	2004-11-04 22:50:37 +01:00
+++ b/net/ipv4/netfilter/ip_conntrack_amanda.c	2004-11-04 22:50:37 +01:00
@@ -49,7 +49,7 @@
 {
 	struct ip_conntrack_expect *exp;
 	struct ip_ct_amanda_expect *exp_amanda_info;
-	char *amp, *data, *data_limit, *tmp;
+	char *data, *data_limit, *tmp;
 	unsigned int dataoff, i;
 	u_int16_t port, len;
 
@@ -70,11 +70,9 @@
 	}
 
 	LOCK_BH(&amanda_buffer_lock);
-	amp = skb_header_pointer(skb, dataoff,
-				 skb->len - dataoff, amanda_buffer);
-	BUG_ON(amp == NULL);
-	data = amp;
-	data_limit = amp + skb->len - dataoff;
+	skb_copy_bits(skb, dataoff, amanda_buffer, skb->len - dataoff);
+	data = amanda_buffer;
+	data_limit = amanda_buffer + skb->len - dataoff;
 	*data_limit = '\0';
 
 	/* Search for the CONNECT string */
@@ -110,7 +108,7 @@
 		exp->mask.dst.u.tcp.port = 0xFFFF;
 
 		exp_amanda_info = &exp->help.exp_amanda_info;
-		exp_amanda_info->offset = tmp - amp;
+		exp_amanda_info->offset = tmp - amanda_buffer;
 		exp_amanda_info->port   = port;
 		exp_amanda_info->len    = len;
 

--------------050109020206080500040208--
