From: "Srinivas G." <srinivasg@esntechnologies.co.in>
Subject: unable to reinject the IP packets using ipq_set_verdict (libipq API)
Date: Mon, 20 Dec 2004 17:33:03 +0530
Message-ID: <4EE0CBA31942E547B99B3D4BFAB34811258EA4@mail.esn.co.in>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: rsamprat@cisco.com, munky@maluco.com.br, greearb@candelatech.com,
	schuster.sven@gmx.de, jz105@york.ac.uk
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
To: <netfilter-devel@lists.netfilter.org>
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

Dear All,

=20

I developed a small application which uses the libipq APIs to capture
the IP packets using netfilter hook. (Here I am not using the iptables.
I used the netfilter hook module to queue the packets in the kernel
space using NF_QUEUE verdict. At the user side I am using the ip_queue
module and then libipq APIs to read the queued packets from the kernel
space)

=20

When I try to print the packet's data in the libipq application it was
printed perfectly. But when I try to reinject the modified packet back
to kernel space using the ipq_set _verdict, it was not working. See the
attached code below.

=20

=20

  case IPQM_PACKET:=20

{

                        ipq_packet_msg_t *m =3D ipq_get_packet(buf);

                        unsigned char *packet =3D (unsigned char *)m +
sizeof(*m);

                        unsigned int header_length =3D 0;

                        struct iphdr *iph;

                        struct tcphdr *tcph;

                        unsigned char *payload;

=20

                        /* calculate the IP header length */

                        iph =3D (struct iphdr *)packet;

                        header_length +=3D iph->ihl * 4;

=20

                        /* calculate the TCP header */

                        tcph =3D (struct tcphdr *)(packet +
header_length);

                        header_length +=3D tcph->doff * 4;

                                   =20

                        /* compute the payload */

                        payload =3D packet + header_length;

                                   =20

                        printf("Packet receivd!\n");          =20

=20

                        /* length of the packet data is */

                        printf("Packet length =3D %d!\n",m->data_len);

                                    =20

                        /* address of the packet in the memory */

                        printf("Packet address in the memory :
%X!\n",packet);

                                    =20

                        /* address of the payload in the memory */

                        printf("payload address in the memory :
%X!\n",payload);

=20

                        for(i=3D0;i<20;i++)

                        {

                            printf("%c",*(payload + i));

                            *(payload + i) =3D 'a';

                        }

=20

                        printf("\n");

=20

                        /* after modification re-inject the packet into

                         * the kernel space i.e. issue the verdict */

                        status =3D ipq_set_verdict(pHandle, =
m->packet_id,
NF_ACCEPT, 0, NULL);

=20

                        if (status < 0)

                             die(pHandle);

                                     =20

                        break;

            }

=20

=20

I modified the following line in different ways with different arguments
for the 4th and 5th parameters. I read the man page of ipq_set_verdict
and modified those variables.=20

=20

status =3D ipq_set_verdict(pHandle, m->packet_id, NF_ACCEPT, 0, NULL);

=20

Instead of sending the 0 and NULL, I send

1.                  Application defined buffer length and application
defined buffer pointer.

2.                  m->data_len and packet pointer=20

3.                  20 (number of character I modified in the
application) and payload pointer

4.                  m->data_len and m

=20

I tried with other combinations, not only above mentioned combinations.=20

=20

Even though, I was unable to retransmit the modified packet.=20

=20

How am I testing it? I connected two individual systems using CROSS
CABLE. On one system I am running the client program and another system
I am running the server program and libipq application. On server
machine I am receiving the original data instead of modified one.

=20

Any help greatly appreciated.

=20

Thanks and regards,

Srinivas G

=20

=20
