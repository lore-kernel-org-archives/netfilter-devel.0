From: Christian Riechmann <riechmann@fgan.de>
Subject: ip6tables don't filter Neighbor Solicitation packets
Date: Mon, 8 Mar 2004 14:07:25 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040308130725.GA2170@rie.rie.priv>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="rwEMma7ioTxnRzrJ"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

it seems to me, that Neighbor Discovery Solicitation packets
are not filtered by ip6tables to an ipq program, although these
packets are ICMPv6 and Multicast packets.

Hoping that someone on the list can give me a hint, how to solve
the problem:
  I am using iptables-1.2.9
  with Kernel 2.4.25 with IPv6 and I am interested in reading the
  the following ICMPv6 packets:
	Neighbor Discovery Solicitation
	Neighbor Discovery Advertisement (not yet tested)
	Router Solicitation (not yet tested)
	Router Advertisement (not yet tested)
  before they are send out to the link layer.

Here is how I tested:

1. As application I use ping6.
2. Before pinging I load 2 ip6tables rules:
	ip6tables -A OUTPUT -p icmpv6 -j QUEUE
	ip6tables -A OUTPUT -d ff00::0/8 -j QUEUE

   Then I start tcpdump and a slightly enhanced version ipq-demoprogram
   (attached to this message) to see what is going on.
   Next is starting the ping6.

3. Here are the results:

   Tcpdump shows the multicasted neighbor solicitation messages, but
   the ipq6-demoprogram only shows only the initiating Echo messages.
   (Neighbor advertisement messages are not detected, as the ping6-edr
   host was not connected to the link.)

   a. Result of tcpdump:

rie:/home/rie# tcpdump -x -n -e
tcpdump: listening on eth0
11:40:05.909530 0:2:2d:3f:20:4d 33:33:ff:3f:20:38 86dd 86: 3ffe:400:130:3200:202:2dff:fe3f:204d > ff02::1:ff3f:2038: icmp6: neighbor sol: who has 3ffe:400:130:3200:202:2dff:fe3f:2038
                         6000 0000 0020 3aff 3ffe 0400 0130 3200
                         0202 2dff fe3f 204d ff02 0000 0000 0000
                         0000 0001 ff3f 2038 8700 8035 0000 0000
                         3ffe 0400 0130 3200 0202 2dff fe3f 2038
                         0101 0002 2d3f 204d
11:40:06.902836 0:2:2d:3f:20:4d 33:33:ff:3f:20:38 86dd 86: 3ffe:400:130:3200:202:2dff:fe3f:204d > ff02::1:ff3f:2038: icmp6: neighbor sol: who has 3ffe:400:130:3200:202:2dff:fe3f:2038
                         6000 0000 0020 3aff 3ffe 0400 0130 3200
                         0202 2dff fe3f 204d ff02 0000 0000 0000
                         0000 0001 ff3f 2038 8700 8035 0000 0000
                         3ffe 0400 0130 3200 0202 2dff fe3f 2038
                         0101 0002 2d3f 204d
11:40:07.902836 0:2:2d:3f:20:4d 33:33:ff:3f:20:38 86dd 86: 3ffe:400:130:3200:202:2dff:fe3f:204d > ff02::1:ff3f:2038: icmp6: neighbor sol: who has 3ffe:400:130:3200:202:2dff:fe3f:2038
                         6000 0000 0020 3aff 3ffe 0400 0130 3200
                         0202 2dff fe3f 204d ff02 0000 0000 0000
                         0000 0001 ff3f 2038 8700 8035 0000 0000
                         3ffe 0400 0130 3200 0202 2dff fe3f 2038
                         0101 0002 2d3f 204d

3 packets received by filter
0 packets dropped by kernel
rie:/home/rie#



   b. Result from the ipq-demoprogram:

rie:/home/rie/wm/ipq-demo# ./a.out
[11:40:05]:
60000000 00403a40 3ffe0400 01303200
02022dff fe3f204d 3ffe0400 01303200
02022dff fe3f2038 800011a9 da060001
854d4c40 3edf0d00 08090a0b 0c0d0e0f
10111213 14151617 18191a1b 1c1d1e1f
20212223 24252627 28292a2b 2c2d2e2f
30313233 34353637

[11:40:06]:
60000000 00403a40 3ffe0400 01303200
02022dff fe3f204d 3ffe0400 01303200
02022dff fe3f2038 80003a72 da060002
864d4c40 14150e00 08090a0b 0c0d0e0f
10111213 14151617 18191a1b 1c1d1e1f
20212223 24252627 28292a2b 2c2d2e2f
30313233 34353637

[11:40:07]:
60000000 00403a40 3ffe0400 01303200
02022dff fe3f204d 3ffe0400 01303200
02022dff fe3f2038 80003b71 da060003
874d4c40 12150e00 08090a0b 0c0d0e0f
10111213 14151617 18191a1b 1c1d1e1f
20212223 24252627 28292a2b 2c2d2e2f
30313233 34353637

rie:/home/rie/wm/ipq-demo#



Thanks in advance

Christian
-- 
Christian Riechmann    E-Mail: riechmann@fgan.de
c/o FGAN/FKIE          Tel: (+49) 228/9435 345,378
Neuenahrer Strasse 20  Fax: (+49) 228/9435 685
D-53343 Wachtberg, Germany


--rwEMma7ioTxnRzrJ
Content-Type: text/x-csrc; charset=us-ascii
Content-Disposition: attachment; filename="ipq6.c"

/*
 * This code is GPL.
 */
#include <linux/netfilter.h>
#include <libipq/libipq.h>
#include <stdio.h>
#include <time.h>

#define BUFSIZE 2048

static void
die (struct ipq_handle *h)
{
  ipq_perror ("DIED !");
  ipq_destroy_handle (h);
  exit (1);
}

void
dump (char *buff, int length)
{
  int i, k, l;
  k = 0;
  l = 0;
  for (i = 0; i < length; i++)
    {
      printf ("%02x", 255 & buff[i]);
      if (k == 3)
	{
	  if (l == 15)
	    {
	      printf ("\n");
	      l = 0;
	    }
	  else
	    {
	      printf (" ");
	      l++;
	    }
	  k = 0;
	}
      else
	{
	  k++;
	  l++;
	}
    }
  printf ("\n");
  if (l != 0)
    {
      printf ("\n");
    }
}

int
main (int argc, char **argv)
{
  int status;
  unsigned char buf[BUFSIZE];
  struct ipq_handle *h;
  int i, k, l;

  h = ipq_create_handle (0, PF_INET6);
  if (h == NULL)
    {
      fprintf (stderr, "Nach ipq_create_handle\n");
      ipq_perror("ipq_create_handle");
      die (h);
    }

  status = ipq_set_mode (h, IPQ_COPY_PACKET, BUFSIZE);
  if (status < 0)
    {
      fprintf (stderr, "Nach ipq_set_mode\n");
      ipq_perror("ipq_set_mode");
      die (h);
    }

  do
    {
      status = ipq_read (h, buf, BUFSIZE, 0);
      if (status < 0)
	{
	  fprintf (stderr, "Nach ipq_read\n");
      ipq_perror("ipq_read");
	  die (h);
	}

      switch (ipq_message_type (buf))
	{
	case NLMSG_ERROR:
	  fprintf (stderr, "Received error message %d\n",
		   ipq_get_msgerr (buf));
	  break;

	case IPQM_PACKET:
	  {
	    time_t t = time(NULL);
	    char timestr[100];
	    struct tm *zeit;
	    
	    zeit = localtime(&t);
	    strftime(timestr, sizeof(timestr), "[%H:%M:%S]\0", zeit);
	    printf("%s:\n", timestr);
	    ipq_packet_msg_t *m = ipq_get_packet (buf);

	    /*
	     * Processing the packet
	     */

	    dump (&(m->payload[0]), m->data_len);

	    status = ipq_set_verdict (h, m->packet_id, NF_ACCEPT, 0, NULL);
	    if (status < 0)
	      die (h);
	    break;
	  }

	default:
	  fprintf (stderr, "Unknown message type!\n");
	  break;
	}
    }
  while (1);

  ipq_destroy_handle (h);
  return 0;
}

--rwEMma7ioTxnRzrJ--
