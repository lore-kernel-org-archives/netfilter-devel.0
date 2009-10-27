From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: xt_ACCOUNT and big endian machines
Date: Tue, 27 Oct 2009 11:04:38 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0910271038170.13188@obet.zrqbmnf.qr>
References: <200910231623.42725.thomas.jarosch@intra2net.com> <alpine.LSU.2.00.0910231726400.12517@obet.zrqbmnf.qr> <200910261003.01234.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:33637 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752212AbZJ0KEe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Oct 2009 06:04:34 -0400
In-Reply-To: <200910261003.01234.thomas.jarosch@intra2net.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2009-10-26 10:03, Thomas Jarosch wrote:
>On Friday, 23. October 2009 17:48:04 you wrote:
>> >I'm wondering if this is the best approach to support big endian
>> > machines with all those #ifdefs?
>> 
>> The second is ok, though I dunno why he did not chose to do the
>> same in the first. Hence:
>
>Thanks for the fix! What about the left shift operations f.e. in 
>ipt_acc_handle_get_data()? The original patch touched those, too.

Adding this in.

diff --git a/extensions/ACCOUNT/iptaccount.c b/extensions/ACCOUNT/iptaccount.c
index 2d4556f..b4fddf9 100644
--- a/extensions/ACCOUNT/iptaccount.c
+++ b/extensions/ACCOUNT/iptaccount.c
@@ -39,8 +39,9 @@ char *addr_to_dotted(unsigned int addr)
 	static char buf[17];
 	const unsigned char *bytep;
 
+	addr = ntohl(addr);
 	bytep = (const unsigned char *)&addr;
-	snprintf(buf, 16, "%u.%u.%u.%u", bytep[0], bytep[1], bytep[2], bytep[3]);
+	snprintf(buf, 16, "%u.%u.%u.%u", bytep[3], bytep[2], bytep[1], bytep[0]);
 	buf[16] = 0;
 	return buf;
 }
diff --git a/extensions/ACCOUNT/xt_ACCOUNT.c b/extensions/ACCOUNT/xt_ACCOUNT.c
index 6154bbe..c7e5aae 100644
--- a/extensions/ACCOUNT/xt_ACCOUNT.c
+++ b/extensions/ACCOUNT/xt_ACCOUNT.c
@@ -744,7 +744,7 @@ static int ipt_acc_handle_copy_data(void *to_user, unsigned long *to_user_pos,
 
 	for (i = 0; i <= 255; i++) {
 		if (data->ip[i].src_packets || data->ip[i].dst_packets) {
-			handle_ip.ip = net_ip | net_OR_mask | (i << 24);
+			handle_ip.ip = htonl(net_ip | net_OR_mask | i);
 
 			handle_ip.src_packets = data->ip[i].src_packets;
 			handle_ip.src_bytes = data->ip[i].src_bytes;
@@ -796,7 +796,7 @@ static int ipt_acc_handle_get_data(uint32_t handle, void *to_user)
 		struct ipt_acc_mask_24 *network =
 			ipt_acc_handles[handle].data;
 		if (ipt_acc_handle_copy_data(to_user, &to_user_pos, &tmpbuf_pos,
-		    network, net_ip, 0))
+		    network, ntohl(net_ip), 0))
 			return -1;
 
 		/* Flush remaining data to userspace */
@@ -817,7 +817,7 @@ static int ipt_acc_handle_get_data(uint32_t handle, void *to_user)
 				struct ipt_acc_mask_24 *network =
 					network_16->mask_24[b];
 				if (ipt_acc_handle_copy_data(to_user, &to_user_pos,
-				    &tmpbuf_pos, network, net_ip, (b << 16)))
+				    &tmpbuf_pos, network, ntohl(net_ip), (b << 16)))
 					return -1;
 			}
 		}
@@ -845,7 +845,7 @@ static int ipt_acc_handle_get_data(uint32_t handle, void *to_user)
 							network_16->mask_24[b];
 						if (ipt_acc_handle_copy_data(to_user,
 						    &to_user_pos, &tmpbuf_pos,
-						    network, net_ip, (a << 8) | (b << 16)))
+						    network, ntohl(net_ip), (a << 16) | (b << 8)))
 							return -1;
 					}
 				}
