From: Balazs Scheidler <bazsi@balabit.hu>
Subject: [RFC] TCP core changes needed for transparent proxying
Date: Tue, 4 Jun 2002 12:39:58 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020604103958.GA31060@balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: ak@suse.de
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

Sorry to disturb you again with my transparent proxy efforts, but finally
after my third complete reorganization, things seem to work fine, without
_any_ core TCP changes. 

I have a couple of problems though, which all involve core TCP code patches,
and so I would like some advice on the preferred way.

1. notification about destroyed sockets

I definitely need a notification when a socket is closed. Possible
solutions:
  a) create a notifier in inet_sock_release() function, where my tproxy
     module registers itself.
  b) call a netfilter specific function when CONFIG_NETFILTER is defined
     in a way similar to how setsockopts are delegated to netfilter.

I like the second option a bit more, as putting notifiers here and there is
IMHO ugly. Other parts in netfilter might need such a feature too, as
netfilter modules might assign state to sockets (through
setsockopt/getsockopt) which needs to be freed when the socket is closed.

2. receiving rewritten original address for datagram based protocols (UDP)

As looking up a table when a packet is received is not atomic (the way it
needs to be done when using simple NAT), I was thinking about attaching the
original address information to the packet itself, which can be queried via
an aux message with recvmsg(). As it is not possible to hook into aux
message processing, I did this with a patch to ip_sockglue.c. The important
parts of my patch is at the end of this message.

I tried to be as general as possible, and made the NAT framework to save
original addresses in IPCB(skb), which is returned in an IP_ORIGADDRS
auxillary message when recvmsg() is called on a socket with IP_RECVORIGADDRS
setsockopt enabled.

Is this solution ok for you?

3. specifying outgoing source address for datagram based protocols (UDP)

A similar problem applies to sending as well. To be atomic, I need to
specify the outgoing source address at sendmsg() time using an aux message.
The problem is again that it is difficult to hook into aux message
processing, and the skb is not created until ip_build_xmit() time, therefore
the skb cannot be used to store this information unless ip_build_xmit()
itself is patched.

Any idea to resolve this issue?

And now my current patch against ip_sockglue.c

diff -urN --exclude-from kernel-exclude linux-2.4.18-vanilla/net/ipv4/ip_sockglue.c linux-2.4.18-cttproxy/net/ipv4/ip_sockglue.c
--- linux-2.4.18-vanilla/net/ipv4/ip_sockglue.c Wed Oct 31 00:08:12 2001
+++ linux-2.4.18-cttproxy/net/ipv4/ip_sockglue.c        Fri May 24 02:44:44 2002@@ -48,6 +48,7 @@
 #define IP_CMSG_TOS            4
 #define IP_CMSG_RECVOPTS       8
 #define IP_CMSG_RETOPTS                16
+#define IP_CMSG_ORIGADDRS      32
 
 /*
  *     SOL_IP control messages.
@@ -107,6 +108,20 @@
        put_cmsg(msg, SOL_IP, IP_RETOPTS, opt->optlen, opt->__data);
 }
 
+#if defined(CONFIG_IP_NF_NAT_NEEDED)
+
+void ip_cmsg_recv_origaddrs(struct msghdr *msg, struct sk_buff *skb)
+{
+        struct in_origaddrs ioa;
+        
+        ioa.ioa_srcaddr.s_addr = IPCB(skb)->orig_srcaddr;
+        ioa.ioa_srcport = IPCB(skb)->orig_srcport;
+        ioa.ioa_dstaddr.s_addr = IPCB(skb)->orig_dstaddr;
+        ioa.ioa_dstport = IPCB(skb)->orig_dstport;
+        put_cmsg(msg, SOL_IP, IP_ORIGADDRS, sizeof(ioa), &ioa);
+}
+
+#endif
 
 void ip_cmsg_recv(struct msghdr *msg, struct sk_buff *skb)
 {
@@ -135,6 +150,12 @@
 
        if (flags & 1)
                ip_cmsg_recv_retopts(msg, skb);
+       if ((flags>>=1) == 0)
+               return;
+#if defined(CONFIG_IP_NF_NAT_NEEDED)
+       if (flags & 1)
+               ip_cmsg_recv_origaddrs(msg, skb);
+#endif
 }
 
 int ip_cmsg_send(struct msghdr *msg, struct ipcm_cookie *ipc)
@@ -167,6 +188,19 @@
                        ipc->addr = info->ipi_spec_dst.s_addr;
                        break;
                }
+#if defined(CONFIG_IP_NF_NAT_NEEDED)
+               case IP_ORIGADDRS:
+                {
+                        struct in_origaddrs *ioa;
+                        
+                        if (cmsg->cmsg_len != CMSG_LEN(sizeof(struct in_origaddrs)))
+                                return -EINVAL;
+                        ioa = (struct in_origaddrs *) CMSG_DATA(cmsg);
+                        
+                        /* FIXME: where to store addresses so NAT might pick it up? */
+                       break;
+               }
+#endif
                default:
                        return -EINVAL;
                }


-- 
Bazsi
PGP info: KeyID 9AF8D0A9 Fingerprint CD27 CFB0 802C 0944 9CFD 804E C82C 8EB1
