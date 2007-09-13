From: SEBASTIEN LEGER <sebastienleger@yahoo.fr>
Subject: is skb payload missing when using NF_IP_POST_ROUTING ?
Date: Thu, 13 Sep 2007 13:20:20 +0000 (GMT)
Message-ID: <904365.95538.qm@web28107.mail.ukl.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <http://lists.netfilter.org/pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

=0AHi,=0A=0AI'm trying to develop a queue handler using netfilter and=0Aipt=
ables mangling to catch all data coming in and out of my network=0Acard. I'=
m using a hook on NF_IP_PRE_ROUTING and another one on=0ANF_IP_POST_ROUTING=
. Everything is running fine but...=0A=0Aunfortunately,=0Aall skb received =
on NF_IP_POST_ROUTING hook seem to have a non=0Ainitialized random payload,=
 however packet length is correct (size is=0Aretrieved from IP header analy=
sis, not from skb length field). Packet=0Apayload is dumped on dmesg and co=
mpared to a live tcpdump capture=0Arunning in background: dmesg contains ju=
nk data above TCP layer instead=0Aof pure FTP :(((=0A=0ADoes it mean that s=
kb payload is not yet=0Aavailable when NF_IP_POST_ROUTING hooks are called?=
 my understanding=0Awas that post routing was called just before sending pa=
cket on the=0Anetwork device, is it wrong? if I misunderstood, how can I ca=
tch=0Apackets coming out of my device and access to their full content?=0A=
=0AThanks in advance for your help.=0A=0Abest regards,=0A-- sebastien=0A=0A=
my kernel is linux-2.6.17-14mdv, and iptables v1.3.5=0A=0AI'm using simple =
commands to configure iptables:=0Aiptables -t mangle -I PREROUTING -j TEST =
-i eth0=0Aiptables -t mangle -I POSTROUTING -j TEST=0A=0A-> I'm using the f=
ollowing function to determine packet size:=0Aint getpacket_size(const stru=
ct sk_buff* packet) {=0A        if(NULL =3D=3D packet) {=0A                =
return 0;=0A        }=0A        if (packet->protocol =3D=3D ntohs(ETH_P_IP)=
)=0A {=0A                return ntohs(((struct iphdr*)packet->data)->tot_le=
n);=0A        }=0A        return packet->len;=0A}=0A-> and this is my queue=
 handler function:=0Astatic int my_queue_handler(struct sk_buff *skb, struc=
t nf_info *info, unsigned int queuenum, void *data) {=0A        printk("Pk =
content is:");=0A        dump_packet_debug(skb->data, min(80, getpacket_siz=
e(skb)));=0A        printk("\n");=0A        nf_reinject(skb, info, NF_ACCEP=
T);=0A        return 0;=0A}=0A=0A=0A=0A      ______________________________=
_______________________________________________ =0ANe gardez plus qu'une se=
ule adresse mail ! Copiez vos mails vers Yahoo! Mail 
