From: "bunty " <bunty123_4@rediffmail.com>
Subject: problem in adding own protocol handler using netfilter
Date: 9 Dec 2004 17:58:26 -0000
Message-ID: <20041209175826.23780.qmail@webmail35.rediffmail.com>
Reply-To: bunty  <bunty123_4@rediffmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

Hello,=0A             I am writing a new protocol handler that will first t=
ake packet from Ethernet device and then remove my own header and pass it t=
o IP layer. I register my protocol with dev_add_pack. I am adding my own he=
ader in netfilter modules. I am adding my header at NF_IP_LOCAL_OUT and rem=
oving it on NF_IP_POST_ROUTING. Now I want to know what should be protocol =
ID for those packets outgoing through my protocol.=0A             My protoc=
ol resides in between Ethernet and IP layer. In ip_output.c ip_finish_outpu=
t() attaches ETH_P_IP as skb->protocol. My question is should I change it t=
o my ETH_P_MYIP protocol? =0A              Also I want to know calling dire=
ctly ip_rcv from myip_rcv is allowed? Where again I require to change in ke=
rnel?=0A           Please help me to understand this concept of adding own =
protocol to linux.=0AAny other help is appreciated.=0ARegards,=0AParag.=0A
