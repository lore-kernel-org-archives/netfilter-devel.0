From: thomasmkling@arcor.de
Subject: tcp conntrack logging
Date: Fri, 13 May 2005 12:49:50 +0200 (CEST)
Message-ID: <21952731.1115981390581.JavaMail.ngmail@webmail-06.arcor-online.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
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

I want to write an extended logging of TCP-Connections: iptables -A INPUT -=
j LOGTCP =20

LOGTCP should just be a copy of ipt_LOG.c:=20

/* --------copy------------
static void dump_packet(const struct ipt_log_info *info, const struct sk_bu=
ff *skb, unsigned int iphoff)
{
...
case IPPROTO_TCP: {
struct tcphdr _tcph, *th;
=20
/* Max length: 10 "PROTO=3DTCP " */
printk("PROTO=3DTCP ");
...=20
[*]
...
break;
--------copy------------ /*

And here [*] I want to call some functions from tcp_conntrack:
printk("tcp_in_window, sender->td_end, sender->td_maxend, sender->maxwin, r=
eceiver->td_end, receiver->td_maxend, receiver->td_maxwin);

The problem: I just don't know how to access these values from there. I loo=
ked through several other modules that use ip_conntrack, but didn't find th=
e idea to get started.






Machen Sie aus 14 Cent spielend bis zu 100 Euro!
Die neue Gaming-Area von Arcor - =FCber 50 Onlinespiele im Angebot.
http://www.arcor.de/rd/emf-gaming-1
