From: Essien Ita Essien <essiene@gmail.com>
Subject: ipq_packet_msg_t - dereferencing pointer to incomplete type
Date: Fri, 25 Feb 2005 10:12:29 +0100
Message-ID: <421EEBFD.2040000@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
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

Hi,

I'm trying to follow the tutorial in the libipq man page, with just a 
little modification, and i get a compile error when i try to access the 
ipq_packet_msg_t structure. I've checked where ipq_packet_msg_t is 
defined, and found it in <linux/netfilter_ipv4/ip_queue.h>, which i've 
found is conditionally included in <libipq.h> already. I even tried 
including straight into the program.

Any ideas what i'm doing wrong?

thanks.

The error i get is:

first.c: In function `main':
first.c:47: error: dereferencing pointer to incomplete type
first.c:51: error: dereferencing pointer to incomplete type



The program is:

#include <stdio.h>
#include <linux/netfilter.h>
#include <libipq.h>
#include <linux/ip.h>
#include <linux/tcp.h>



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
     h = ipq_create_handle(0,PF_INET);
     if (!h)
         die(h);


     status = ipq_set_mode(h,IPQ_COPY_PACKET,BUFSIZE);
     if (status < 0)
         die(h);

     while (1) {
         status = ipq_read(h,buf,BUFSIZE,0);
         if (status < 0)
             die(h);

         switch(ipq_message_type(buf)) {
             case NLMSG_ERROR:
                 fprintf(stderr,"Recieved Error Message: 
%d\n",ipq_get_msgerr(buf));
                 break;

             case IPQM_PACKET: {
                 struct ipq_packet_msg_t *m = ipq_get_packet(buf);
                 struct iphdr *ip = (struct iphdr*) m->payload; /*this 
line give the error*/
                 fprintf(stdout,"Saddr: %d\nDaddr: 
%d\n",ip->saddr,ip->daddr);


                 status = 
ipq_set_verdict(h,m->packet_id,NF_ACCEPT,0,NULL); /*this line also borks*/
                 if (status < 0)
                     die(h);

                 break;

                 }

             default:
                 fprintf(stderr,"Unknown Message Type!\n");
         }

     }

     ipq_destroy_handle(h);
     return 0;
}



#include <stdio.h>
#include <linux/netfilter.h>
#include <libipq.h>
#include <linux/ip.h>
#include <linux/tcp.h>



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
	h = ipq_create_handle(0,PF_INET);
	if (!h)
		die(h);


	status = ipq_set_mode(h,IPQ_COPY_PACKET,BUFSIZE);
	if (status < 0)
		die(h);

	while (1) {
		status = ipq_read(h,buf,BUFSIZE,0);
		if (status < 0)
			die(h);

		switch(ipq_message_type(buf)) {
			case NLMSG_ERROR:
				fprintf(stderr,"Recieved Error Message: %d\n",ipq_get_msgerr(buf));
				break;

			case IPQM_PACKET: {
				struct ipq_packet_msg_t *m = ipq_get_packet(buf);
				struct iphdr *ip = (struct iphdr*) m->payload; /*this line give the 
error*/
				fprintf(stdout,"Saddr: %d\nDaddr: %d\n",ip->saddr,ip->daddr);

				
				status = ipq_set_verdict(h,m->packet_id,NF_ACCEPT,0,NULL); /*this 
line also borks*/
				if (status < 0)
					die(h);

				break;

				}

			default:
				fprintf(stderr,"Unknown Message Type!\n");
		}

	}

	ipq_destroy_handle(h);
	return 0;
}
