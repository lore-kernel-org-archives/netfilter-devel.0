From: "li meng" <lmbjok@hotmail.com>
Subject: FW: netfilt die
Date: Sat, 14 Aug 2004 10:40:19 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <BAY15-F22ApmdUrmibf000019a5@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=gb2312; format=flowed
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




>From: "li meng" <lmbjok@hotmail.com>
>To: netfilter-failover@lists.netfilter.org, lmbjok@hotmail.com
>Subject: netfilt die
>Date: Sat, 14 Aug 2004 10:38:36 +0000
>
>i  am a new babie to write netfilt program, a program cause netfilt die, 
so it doesnt work.
>
>when i compile it and run it in the following two situtaion, it productes 
the two result.
>
>i) iptables work just forward, it works.
>
>ii)iptables work as forward and masquade: every packet cause a daemon 
disappeared -- i think it die--until all daemons disappeared!
>
>the following is the program.
>
>/************************************ BEGIN **************************/
>#include <linux/netfilter.h>
>#include <libipq/libipq.h>
>#include <stdio.h>
>#include <stdlib.h>
>#include <string.h>
>#include <netinet/ip.h>
>#define __FAVOR_BSD		/* use bsd'ish tcp header */
>#ifndef __USE_BSD
>#define __USE_BSD		/* use bsd'ish tcp header */
>#endif
>#include <netinet/tcp.h>
>#include <sys/socket.h>
>#include <netinet/in.h>
>#include <arpa/inet.h>
>#include <time.h>
>#include <arpa/inet.h>
>#include <time.h>
>#include <sys/un.h>
>#include <stdio.h>
>#include <stdlib.h>
>#include <unistd.h>
>#include <string.h>
>
>
>int debug = 0;
>struct ipq_handle *h;
>pid_t child_make ();
>int child_main ();
>static void die (struct ipq_handle *h);
>int checkpacket (const unsigned char *pktptr, int pktlen, long pkttime);
>int writelog (long, long, char *, char *, int);
>
>int
>main (int argc, char **argv)
>{
>   int daemons = 0;
>   int i = 0;
>   pid_t pid;
>
>   if (argc > 1)
>     {
>       daemons = atoi (argv[1]);
>     }
>   if (daemons < 5)
>     daemons = 5;
>   if (argc > 2)
>     {
>       debug = atoi (argv[2]);
>     }
>   printf ("\nDaemons=%d DEBUG LEVEL:%d\n", daemons, debug);
>
>   h = ipq_create_handle (0);
>   if (!h)
>     die (h);
>
>   for (i = 0; i < daemons; i++)
>     {
>       pid = child_make ();
>     }
>   return (0);
>}
>
>pid_t
>child_make ()
>{
>   pid_t pid;
>   if ((pid = fork ()) > 0)
>     return pid;
>   child_main ();
>   return 1;
>}
>
>int
>child_main ()
>{
>   int status;
>   unsigned char buf[BUFSIZE];
>
>   status = ipq_set_mode (h, IPQ_COPY_PACKET, BUFSIZE);
>   if (status < 0)
>     die (h);
>
>   do
>     {
>       status = ipq_read (h, buf, BUFSIZE, 0);
>       if (status < 0)
>	die (h);
>
>       switch (ipq_message_type (buf))
>	{
>	case NLMSG_ERROR:
>	  fprintf (stderr, "Received error message %d\n",
>		   ipq_get_msgerr (buf));
>	  break;
>
>	case IPQM_PACKET:
>	  {
>	    ipq_packet_msg_t *m = ipq_get_packet (buf);
>	    if (checkpacket (m->payload, m->data_len, m->timestamp_sec))
>	      {
>		status =
>		  ipq_set_verdict (h, m->packet_id, NF_ACCEPT, 0, NULL);
>		if (status < 0)
>		  {
>		    die (h);
>		  };
>	      }
>	    else
>	      {
>		status = ipq_set_verdict (h, m->packet_id, NF_DROP, 0, NULL);
>		if (status < 0)
>		  {
>		    die (h);
>		  };
>	      }
>	  }
>	  break;
>
>	default:
>	  fprintf (stderr, "Unknown message type!\n");
>	  break;
>	}
>     }
>   while (1);
>}
>
>static void
>die (struct ipq_handle *h)
>{
>   ipq_perror ("passer");
>   ipq_destroy_handle (h);
>   exit (1);
>}
>
>int
>checkpacket (const unsigned char *pktptr, int pktlen, long pkttime)
>{
>   struct in_addr ipaddr;
>   struct ip *iph;
>   struct tcphdr *tcph;
>
>   iph = (struct ip *) pktptr;
>   if (!iph)
>     {
>       return 1;
>     }
>   ipaddr = iph->ip_src;
>   if (iph->ip_p == 6)		//TCP package
>     {
>       tcph = (struct tcphdr *) (iph + (iph->ip_hl << 2));
>       if (pktlen < 200)
>	return 1;
>       pktptr += iph->ip_hl << 2;
>       pktptr += tcph->th_off << 2;
>       if(pktlen>800)
>         return 0;
>     }
>   else if (iph->ip_p == 17)	//UDP package
>     {
>       ;
>     }
>   else if (iph->ip_p == 1)	//ICMP package
>     {
>       ;
>     }
>   return 1;
>}
>
>
>
>/************************************ END **************************/
>
>
>can you help me to sovle this problem?
>
>thanks in advanced!
>
>
>George
>

_________________________________________________________________
√‚∑—œ¬‘ÿ MSN Explorer:   http://explorer.msn.com/lccn/  
