From: Pablo Neira <pablo@eurodev.net>
Subject: Re: libipq bug on 2.6.4 ?
Date: Tue, 06 Apr 2004 20:51:19 +0200
Sender: linux-net-owner@vger.kernel.org
Message-ID: <4072FC27.8060309@eurodev.net>
References: <58842.192.197.51.41.1081275810.squirrel@www.gromalin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-net-owner@vger.kernel.org>
To: DAVID Thomas <lists@gromalin.com>,
	netfilter-devel@lits.netfilter.org, linux-net@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi David,

AFAIK, this is not a bug, actually if a packet passes by OUTPUT, it 
means that this is locally generated traffic:

Local machine ---> OUTPUT ----> POSTROUTING

to be exact, this packet is still in level 3 (network), so it doesn't 
know anything about layer 2 (link, it implies MAC address), that 
information would be added later when passed to layer 2.

On the other hand, if you add that rule in INPUT, it has the information 
about MAC and stuff because it is traversing the stack in the opposite 
sense as described above.

regards,
Pablo

DAVID Thomas wrote:

>hi all,
>i'm a computer student, and I've found a strange behaviour when using
>ip_queue with iptables v1.2.9 on a 2.6.4 kernel.I've written s very simple code, which only displays a ipq_packet_msg_t
>structure. The code is at the end of this mail.
>When i use this rule : iptables -A INPUT -j QUEUE and i've got no problem
>do display the structure.But when i use this rule : iptables -A OUTPUT -j QUEUE, the strucuture is
>not complete. For example :
>Id Packet : 204
>Ip_filter Mark: 0
>Hook : 3
>Indev :
>Outdev : eth0
>HW Protocol : 0000
>HW Type : 0
>HW Addr Len : 0
>HW Address : 00:00:00:00:00:00
>Len data : 1331
>
>I hope I didn't forget something, but I think there is a problem here
>
>DAVID Thomas
>
>Here is the code :
>
>#include <linux/netfilter.h>
>#include <libipq/libipq.h>
>#include <stdio.h>
>
>#define BUFSIZE 2048
>
>static void die(struct ipq_handle *h)
>{
>  ipq_perror("passer");
>  ipq_destroy_handle(h);
>  exit(1);
>}
>
>int main(int argc, char **argv)
>{
>  int status;
>  unsigned char buf[BUFSIZE];
>  struct ipq_handle *h;
>
>  h = ipq_create_handle(0, PF_INET);
>  if (!h)
>    die(h);
>
>  status = ipq_set_mode(h, IPQ_COPY_PACKET, BUFSIZE);
>  if (status < 0)
>    die(h);
>
>  do{
>    status = ipq_read(h, buf, BUFSIZE, 0);
>    if (status < 0)
>      die(h);
>
>    switch (ipq_message_type(buf)) {
>    case NLMSG_ERROR:
>      fprintf(stderr, "Received error message %d\n",
>	      ipq_get_msgerr(buf));
>      break;
>
>    case IPQM_PACKET: {
>      ipq_packet_msg_t *m = ipq_get_packet(buf);
>
>      status = ipq_set_verdict(h, m->packet_id,
>			       NF_ACCEPT, 0, NULL);
>      printf("Id Packet : %d\n", ntohs(m->packet_id));
>      printf("Ip_filter Mark: %x\n", m->mark);
>      printf("Hook : %d\n", m->hook);
>      printf("Indev : %s\n", m->indev_name);
>      printf("Outdev : %s\n", m->outdev_name);
>      printf("HW Protocol : %.4x\n", ntohs(m->hw_protocol));
>      printf("HW Type : %x\n", m->hw_protocol);
>      printf("HW Addr Len : %d\n",ntohs(m->hw_addrlen));
>      printf("HW Address : %02X:%02X:%02X:%02X:%02X:%02X\n",
>      m->hw_addr[0], m->hw_addr[1],	     m->hw_addr[2], m->hw_addr[3], m->hw_addr[4], m->hw_addr[5]);
>      printf("Len data : %d\n", ntohs(m->data_len));
>      printf("\n");
>      if (status < 0)
>	die(h);
>      break;
>    }
>
>    default:
>      fprintf(stderr, "Unknown message type!\n");
>      break;
>    }
>  } while (1);
>
>  ipq_destroy_handle(h);
>  return 0;
>}
>
>
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-net" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>  
>



