From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: tcp conntrack logging
Date: Fri, 20 May 2005 08:45:47 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0505200838380.13712@blackhole.kfki.hu>
References: <21952731.1115981390581.JavaMail.ngmail@webmail-06.arcor-online.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: thomasmkling@arcor.de
In-Reply-To: <21952731.1115981390581.JavaMail.ngmail@webmail-06.arcor-online.net>
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

On Fri, 13 May 2005 thomasmkling@arcor.de wrote:

> I want to write an extended logging of TCP-Connections: iptables -A INPUT -j LOGTCP
>
> LOGTCP should just be a copy of ipt_LOG.c:
>
> /* --------copy------------
> static void dump_packet(const struct ipt_log_info *info, const struct sk_buff *skb, unsigned int iphoff)
> {
> ...
> case IPPROTO_TCP: {
> struct tcphdr _tcph, *th;
>
> /* Max length: 10 "PROTO=TCP " */
> printk("PROTO=TCP ");
> ...
> [*]
> ...
> break;
> --------copy------------ /*
>
> And here [*] I want to call some functions from tcp_conntrack:
> printk("tcp_in_window, sender->td_end, sender->td_maxend, sender->maxwin, receiver->td_end, receiver->td_maxend, receiver->td_maxwin);
>
> The problem: I just don't know how to access these values from there. I
> looked through several other modules that use ip_conntrack, but didn't
> find the idea to get started.

That requires several steps with the usual cautions and checks: the nfct
field of skbuff stores the pointer to the ip_conntrack structure. In
ip_conntrack, the proto field carries the protocol-specific data, which
have got a tcp field and you are there.

Why would you need such internal data logged?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
