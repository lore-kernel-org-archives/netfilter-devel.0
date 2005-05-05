From: Duncan Godfrey <d.j.godfrey@reading.ac.uk>
Subject: Just starting with libipq
Date: Thu, 05 May 2005 15:11:44 +0100
Message-ID: <427A29A0.8020502@reading.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
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

Hello,

I was wondering if someone would be able to help me, Im just starting 
out with some libipq development and Im trying to compile some example 
source code from a tutorial site (I have compiled the source on the man 
page an it worked fine).

Everytime I compile it with gcc -o quick quick.c -libpq, I get the 
following errors:

quick.c:56: error: dereferencing pointer to incomplete type
quick.c:58: error: dereferencing pointer to incomplete type

Has anyone else had a similar experience? Thanks in advance for any help.

Duncan

The code is:

#include <linux/netfilter.h>
#include <libipq.h>
#include <stdio.h>

#define BUFSIZE 2048

static void die(struct ipq_handle *h)
{
  ipq_perror("passer");
  ipq_destroy_handle(h);
  exit(1);
}

int main(int argc, char **argv)
{
  int status;
  unsigned char buf[BUFSIZE];

  struct ipq_handle *h;
       
  h = ipq_create_handle(0, PF_INET);
  if (!h)
    die(h);
       
  status = ipq_set_mode(h, IPQ_COPY_PACKET, BUFSIZE);
  if (status < 0)
    die(h);
               
  do{

    status = ipq_read(h, buf, BUFSIZE, 0);
    if (status < 0)
      die(h);
                       
    switch (ipq_message_type(buf)) {
    case NLMSG_ERROR:
      fprintf(stderr, "Received error message %d\n",
          ipq_get_msgerr(buf));
      break;
        
    case IPQM_PACKET: {
      ipq_packet_msg_t *m = ipq_get_packet(buf);

      struct iphdr *ip = (struct iphdr*) m->payload;

      struct tcphdr *tcp = (struct tcphdr*) (m->payload + (4 * ip->ihl));
                                 
      int port = htons(tcp->dest);       
                              
      status = ipq_set_verdict(h, m->packet_id,
                   NF_ACCEPT, 0, NULL);
      if (status < 0)
    die(h);
      break;
    }
                       
    default:
      fprintf(stderr, "Unknown message type!\n");
      break;
    }
  } while (1);
       

  ipq_destroy_handle(h);
  return 0;
}
