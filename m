From: "Eduard Calvo (B-teljpa) EXP JAN 03" <ecalvo@mat.upc.es>
Subject: Handling packets in userspace with libipq
Date: Thu, 12 Dec 2002 16:42:43 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1039707763.3df8ae73aac54@wmail-mat.upc.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

 
  Hi gurus! 
 
  I have a brand new ip_queue handler to do SNAT before routing. It is located 
in PREROUTING, and everything related to the caching of the packets and its 
information seems to go right. 
 
  The problem arises when I have to return the NAT'ed packet to the next hook 
with ip_set_verdict. I don't know quite well how to tell the kernel to get the 
modifyed packet and not the copy it has. 
  
  In my code I have: 
 
	ret = ipq_set_verdict(qh, p->packet_id, NF_ACCEPT, (int) 
ip_header->tot_len, p->payload); 
 
	And ret takes always -1. 
 
	Where: "p" is a ipq_message_t struct pointer that refers to the 
modified packet read with ipq_read ant then ipq_get_packet. 
	       "ip_header" is a iphdr struct pointer that starts in 
p->payload.  
 
  Do you have any idea? 
  Thanks in advanced. 
				 
				         Eduard 
                                       

-------------------------------------------------
This mail sent through IMP: http://horde.org/imp/
