From: "Vasantha Kumar Puttappa" <vasanthakumar@iitb.ac.in>
Subject: Regarding LIBIPQ problem
Date: Fri, 31 Mar 2006 22:47:26 +0530 (IST)
Message-ID: <1411.10.12.25.5.1143825446.squirrel@gpo.iitb.ac.in>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.netfilter.org
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

Dear friends,
 I am defining a IPtable rule to queue ICMP packets for user level
processing using LIBIPQ.

 Once I get the IP(ICMP)packet, I am encapsulating this in another IP packet
 as shown below

////////////////////////////////////////////////////////
 /* Allocate space for new IP header to be included in the encapsulated
packets */

packet   = (unsigned char *)calloc(1,sizeof(struct
iphdr)+ntohs(original_iph->tot_len));

new_iphdr  = (struct iphdr  *) calloc(1,sizeof(struct iphdr));

  new_iphdr->version =4;
  new_iphdr->ihl=5;  // checkout
  new_iphdr->tos =0;
  new_iphdr->id=htons(1); // temporary
  new_iphdr->frag_off=0;
  new_iphdr->ttl=64;
  new_iphdr->protocol=1;
  new_iphdr->saddr=original_iph->saddr;
  new_iphdr->daddr=inet_addr("10.107.26.26"); // ABC proxy IP address
  new_iphdr->tot_len=htons(ntohs(original_iph->tot_len) + (sizeof(struct
iphdr)));
  int header_length=20;
  new_iphdr->check=htons(ip_sum_calc((unsigned short
*)new_iphdr,header_length));


 // Place the IP packet inside another IP packet
  memcpy(packet,new_iphdr,(unsigned int)sizeof(struct iphdr));
  memcpy(packet+sizeof(struct iphdr),m->payload,m->data_len);
////////////////////////////////


Then I am setting the verdict as accept ,shown below

status = ipq_set_verdict(h, m->packet_id,NF_ACCEPT, new_iphdr->tot_len,
(unsigned char *)packet);


Problem:
  Even though ipq_set_verdict is being executed successfully, the new
packets are being dropped silently without any error message.


If anybody has a clue, plz let me know.

Kernel: 2.6.12-12 (mandriva)

Have a good day
-------
Vasanth
