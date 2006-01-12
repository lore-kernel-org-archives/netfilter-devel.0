From: "Hong Yan" <yh@cs.cmu.edu>
Subject: RE: libnetfilter_queue vs libipq
Date: Thu, 12 Jan 2006 15:31:42 -0500
Message-ID: <002501c617b7$356b5b40$ddb50280@scs.ad.cs.cmu.edu>
References: <20060112095453.GO4430@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0026_01C6178D.4C955340"
Cc: laforge@gnumonks.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
In-Reply-To: <20060112095453.GO4430@sunbeam.de.gnumonks.org>
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

This is a multi-part message in MIME format.

------=_NextPart_000_0026_01C6178D.4C955340
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Here's the experiment setup: we connected 3 emulab (www.emulab.net) =
Linux
(kernel 2.6.12) PCs (3GHZ CPU and 2G MB RAM) via 100M bps Ethernet
interfaces to form a client-firewall-server chain, we run a TCP/UDP
measurement tool called iPerf on the client and the server, when the
iptables are clean, the TCP throughput is 95M bps. We then run the =
following
libipq test:

yum install iptables-devel=20
/sbin/iptables -F FORWARD
/sbin/iptables -A FORWARD -p tcp --dport 5001 -j QUEUE
/sbin/modprobe iptable_filter
/sbin/modprobe ip_queue
./ipq-test

And the throughput dropped to 2M bps. I have also tried snort_inline and =
the
performance is as bad. Did I do something wrong?

Here's the ipq-test source code (also attached):

#include <linux/netfilter.h>
#include <libipq.h>
#include <stdio.h>

#define BUFSIZE 2048=20

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
       =20
        h =3D ipq_create_handle(0, PF_INET);
        if (!h)
                die(h);
               =20
        status =3D ipq_set_mode(h, IPQ_COPY_PACKET, BUFSIZE);
        if (status < 0)
                die(h);
               =20
        do{

                status =3D ipq_read(h, buf, BUFSIZE, 0);
                if (status < 0)
                        die(h);
                       =20
                switch (ipq_message_type(buf)) {
                        case NLMSG_ERROR:
                                fprintf(stderr, "Received error message
%d\n",
                                        ipq_get_msgerr(buf));
                                break;
                               =20


                        case IPQM_PACKET: {
                                ipq_packet_msg_t *m =3D =
ipq_get_packet(buf);
                                status =3D ipq_set_verdict(h, =
m->packet_id,
                                                         NF_ACCEPT, 0,
NULL);
                                if (status < 0)
                                        die(h);
                                break;
                        }
                       =20
                        default:
                                fprintf(stderr, "Unknown message =
type!\n");
                                break;
                }
        } while (1);
       =20

        ipq_destroy_handle(h);
        return 0;
}



-----Original Message-----
From: Harald Welte [mailto:laforge@gnumonks.org]=20
Sent: Thursday, January 12, 2006 4:55 AM
To: Hong Yan
Cc: netfilter-devel@lists.netfilter.org
Subject: Re: libnetfilter_queue vs libipq

On Wed, Jan 11, 2006 at 09:44:33PM -0500, Hong Yan wrote:
=20
> I'm a graduate student at Carnegie Mellon University. We built a =
firewall
> using libipq and later switched to libnetfilter_queue because we found
that
> libnetfilter_queue significantly outperforms libipq. A simple testing
> program using libnetfilter_queue to intercept and then accept all =
packets
> has 94.2 M bps TCP throughput but with libipq it can only achieve 2M =
bps.

I'm very surprised by your results.  Maybe you can describe the
application in more detail (as in how the queue mechanism is used,
whether you reinject or only send a verdict, if you process one packet
at a time, how long your queue lengths get, what kind of hardware, is
the app multithreaded, etc.)

> We wonder what is causing the big difference in performance. Could you
shed
> us some light on this?

Other real-world application users of libipq / libnetfilter_queue have
show an almost equal performance for both systems.

In theory, libnetfilter_queue should even have a little bit more
overhead then libipq (at the gain of more flexibility). =20

Therefore, I think it is important for us to learn, what exactly causes
this performance difference in your case.

Please follow-up to netfilter-devel@lists.netfilter.org, since there
certainly are other developers who would like to learn about this issue.

Thanks!

--=20
- Harald Welte <laforge@gnumonks.org>          	        =
http://gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. =
A6)

------=_NextPart_000_0026_01C6178D.4C955340
Content-Type: application/octet-stream;
	name="ipq-test.c"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="ipq-test.c"

#include <linux/netfilter.h>
#include <libipq.h>
#include <stdio.h>

#define BUFSIZE 2048=20

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
       =20
        h =3D ipq_create_handle(0, PF_INET);
        if (!h)
                die(h);
               =20


        status =3D ipq_set_mode(h, IPQ_COPY_PACKET, BUFSIZE);
        if (status < 0)
                die(h);
               =20
        do{

                status =3D ipq_read(h, buf, BUFSIZE, 0);
                if (status < 0)
                        die(h);
                       =20
                switch (ipq_message_type(buf)) {
                        case NLMSG_ERROR:
                                fprintf(stderr, "Received error message =
%d\n",
                                        ipq_get_msgerr(buf));
                                break;
                               =20


                        case IPQM_PACKET: {
                                ipq_packet_msg_t *m =3D =
ipq_get_packet(buf);
                                /*
                                struct iphdr *ip =3D (struct iphdr*) =
m->payload;
                                struct tcphdr *tcp =3D=20
                                (struct tcphdr*) (m->payload + (4 * =
ip->ihl));
                                int port =3D htons(tcp->dest);       =20
                                */
                              =20
                                status =3D ipq_set_verdict(h, =
m->packet_id,
                                                         NF_ACCEPT, 0, =
NULL);
                                if (status < 0)
                                        die(h);
                                break;
                        }
                       =20
                        default:
                                fprintf(stderr, "Unknown message =
type!\n");
                                break;
                }
        } while (1);
       =20

        ipq_destroy_handle(h);
        return 0;
}

------=_NextPart_000_0026_01C6178D.4C955340--
