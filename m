From: Martijn Lievaart <m@rtij.nl>
Subject: Strange MASQUERADING behaviour, bug or feature?
Date: Mon, 17 Apr 2006 23:46:58 +0200
Message-ID: <44440CD2.6060006@rtij.nl>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=_ma.rtij.nl-20193-1145310419-0001-2"
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

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_ma.rtij.nl-20193-1145310419-0001-2
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

[ Long story, better to much information than to little ]

I encountered some non-intuitive behaviour with MASQUERADE. I wrote a 
dial-on-demand utility, that uses a tun interface. When it sees packets, 
it brings up the real interface. However, packets are masqueraded with 
the ip address of the tun interface, just like the testsetup below. As 
the real interface is assigned an address with dhcp (the reason for 
using masquerade in the first place), I cannot assign the real address 
to the tun interface.

To reproduce this behaviour in a test setup, I wrote a small utility 
that allocates a nullX device, a device that just discards all packets 
send to it. It assigns a link local ipv4 address to that interface.
On the test machine (machine A, kernel 2.6.15) I set up these iptables 
rules:
*nat
:OUTPUT ACCEPT [1463:59018]
:POSTROUTING ACCEPT [1468:59346]
:PREROUTING ACCEPT [1209:217623]
-A POSTROUTING -o null0 -j MASQUERADE
-A POSTROUTING -o null1 -j MASQUERADE
COMMIT
*filter
:FORWARD ACCEPT [647:54256]
:INPUT ACCEPT [328800:93378200]
:OUTPUT ACCEPT [352242:343481377]
COMMIT

I bring up the first null interface and create a route for the test network:
# ./null
Using interface null0 with address 169.254.0.1.
57: null0: <POINTOPOINT,MULTICAST,NOARP,UP> mtu 1500 qdisc pfifo_fast 
qlen 500
    link/[65534]
    inet 169.254.0.1/32 scope global null0
waiting for packets...

(in another window)
# ip ro add 1.2.3.0/24 dev null0 metric 10
The metric is so we can make the packets go to null1 later.

On another machine (B), I set up a route to the test network and ping it.
# ip ro add 1.2.3.0/24 via A
# ping 1.2.3.4

On machine A, I see the packets being masqueraded with the IP address of 
null0:
# tcpdump -i null0 icmp
tcpdump: WARNING: arptype 65534 not supported by libpcap - falling back 
to cooked socket
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on null0, link-type LINUX_SLL (Linux cooked), capture size 96 
bytes
23:36:47.688396 IP 169.254.0.1 > 1.2.3.4: icmp 64: echo request seq 4
23:36:48.688383 IP 169.254.0.1 > 1.2.3.4: icmp 64: echo request seq 5
23:36:49.688413 IP 169.254.0.1 > 1.2.3.4: icmp 64: echo request seq 6
23:36:50.688389 IP 169.254.0.1 > 1.2.3.4: icmp 64: echo request seq 7

Now I bring up the second null interface and add a route with a lower 
metric. Note the address assigned to the interface!
# ./null
Using interface null1 with address 169.254.1.1.
58: null1: <POINTOPOINT,MULTICAST,NOARP,UP> mtu 1500 qdisc pfifo_fast 
qlen 500
    link/[65534]
    inet 169.254.1.1/32 scope global null1
waiting for packets...

(in another window)
# ip ro add 1.2.3.0/24 dev null1

The window where I run null1 now starts printing dots, null1 is 
receiving packets. Now when I dump these packets:
# tcpdump -i null1 icmp
tcpdump: WARNING: arptype 65534 not supported by libpcap - falling back 
to cooked socket
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on null1, link-type LINUX_SLL (Linux cooked), capture size 96 
bytes
23:37:35.688593 IP 169.254.0.1 > 1.2.3.4: icmp 64: echo request seq 52
23:37:36.688614 IP 169.254.0.1 > 1.2.3.4: icmp 64: echo request seq 53
23:37:37.688626 IP 169.254.0.1 > 1.2.3.4: icmp 64: echo request seq 54
23:37:38.688598 IP 169.254.0.1 > 1.2.3.4: icmp 64: echo request seq 55

Hey, that is the wrong source address! Now when I kill the null0 
interface, suddenly the source address changes to the correct 
(169.254.1.1) address. Also when I stop the ping and restart it, the 
source address is correct.

Is this behaviour by design? Is it considered a bug or a feature? Is the 
ping-stream from machine B seen as one contrack entry, and thus causing 
this behaviour?

Regards,
M4


--=_ma.rtij.nl-20193-1145310419-0001-2
Content-Type: text/x-csrc; name="null.c"; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="null.c"

#include <sys/types.h>
#include <sys/select.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/ioctl.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <linux/if.h>
#include <linux/if_tun.h>

int tun_alloc(char *dev);
void usage(const char *msg);

const char* argv0;
const int debug = 1;

int main(int argc, char **argv)
{
  int fd_tun;
  char null_intf[260];
  char scratch[1024];
  int intf_no;

  argv0 = argv[0];

  if (argc > 1)
    usage(0);

  if (geteuid())
    usage("Must be run by root");

  strcpy(null_intf, "null%d");
  if ((fd_tun = tun_alloc(null_intf)) < 0) {
    perror("Could not alloc tun device");
    exit(1);
  }

  intf_no = atoi(null_intf+4);

  printf("Using interface %s with address 169.254.%d.1.\n", null_intf, intf_no);
  /* Bring up the interface with a link local address */
  sprintf(scratch, "/sbin/ip link set %s up", null_intf);
  system(scratch);
  sprintf(scratch, "/sbin/ip addr add 169.254.%d.1/32 dev %s", intf_no, null_intf);
  system(scratch);
  if (debug) {
    sprintf(scratch, "/sbin/ip addr ls dev %s", null_intf);
    system(scratch);
  }

  debug && puts("waiting for packets...");
  while (1) {
    if (read(fd_tun, scratch, sizeof(scratch))<0) {
      perror("Error reading from tun device");
      exit(1);
    }
    if (debug) {
      printf(".");
      fflush(stdout);
    }
  }    

  /* never get here */
  close(fd_tun);
  exit(0);
}


void usage(const char *msg)
{
  if (msg)
    printf("Error: %s\n\n", msg);

  printf("Null interface, discard everything sent here.\n"
	 "\n"
	 "usage: %s <interface> <route> [<route> ...]\n", argv0);
  exit(1);
}



int tun_alloc(char *dev)
{
  struct ifreq ifr;
  int fd, err;

  if( (fd = open("/dev/net/tun", O_RDWR)) < 0 ) {
    /*    return tun_alloc_old(dev); */
    perror("Cannot open tun allocation device");
    exit(1);
  }

  memset(&ifr, 0, sizeof(ifr));

  /* Flags: IFF_TUN   - TUN device (no Ethernet headers)
   *        IFF_TAP   - TAP device
   *
   *        IFF_NO_PI - Do not provide packet information
   */
  ifr.ifr_flags = IFF_TUN | IFF_NO_PI;
  if( *dev )
    strncpy(ifr.ifr_name, dev, IFNAMSIZ);

  if( (err = ioctl(fd, TUNSETIFF, (void *) &ifr)) < 0 ){
    close(fd);
    return err;
  }
  strcpy(dev, ifr.ifr_name);
  return fd;
}


--=_ma.rtij.nl-20193-1145310419-0001-2--
