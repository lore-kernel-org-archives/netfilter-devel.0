From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] make happy cracking message more verbose
Date: Fri, 07 Nov 2003 16:16:54 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FABB766.7020000@trash.net>
References: <Pine.LNX.4.51.0311062049040.953@dns.toxicfilms.tv> <3FAADD04.7020200@trash.net> <Pine.LNX.4.51.0311071431080.4534@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050705080808080201070705"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Maciej Soltysiak <solt@dns.toxicfilms.tv>
In-Reply-To: <Pine.LNX.4.51.0311071431080.4534@dns.toxicfilms.tv>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------050705080808080201070705
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Maciej Soltysiak wrote:

>>It turned out to be an unrelated bug, located
>>in skb_copy_expand.
>>    
>>
>Hmm, is there a fix ? I would like to test it, and see if
>it still happens on my box.
>  
>

Yes it's attached to this mail. It's also in davem's tree
now, but IIRC the bitkeeper repositories are down until
the weekend.

Best regards,
Patrick


--------------050705080808080201070705
Content-Type: text/plain;
 name="2.6-skb_copy_expand.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="2.6-skb_copy_expand.diff"

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.1413  -> 1.1414 
#	   net/core/skbuff.c	1.32    -> 1.33   
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 03/11/06	kaber@trash.net	1.1414
# Fix skb_copy_expand offset calculation
# --------------------------------------------
#
diff -Nru a/net/core/skbuff.c b/net/core/skbuff.c
--- a/net/core/skbuff.c	Thu Nov  6 17:34:55 2003
+++ b/net/core/skbuff.c	Thu Nov  6 17:34:55 2003
@@ -595,10 +595,10 @@
 
 	head_copy_len = skb_headroom(skb);
 	head_copy_off = 0;
-	if (newheadroom < head_copy_len) {
-		head_copy_off = head_copy_len - newheadroom;
+	if (newheadroom <= head_copy_len)
 		head_copy_len = newheadroom;
-	}
+	else
+		head_copy_off = newheadroom - head_copy_len;
 
 	/* Copy the linear header and data. */
 	if (skb_copy_bits(skb, -head_copy_len, n->head + head_copy_off,

--------------050705080808080201070705--
