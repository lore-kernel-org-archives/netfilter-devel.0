From: Roberto Nibali <ratz@tac.ch>
Subject: Re: TCP window tracking patch status query for further design considerations
Date: Tue, 08 Oct 2002 16:55:36 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3DA2F1E8.8000704@tac.ch>
References: <Pine.LNX.4.33.0210081210410.23021-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello Jozsef,

Sorry to bother you again.

> The problem hasn't still been investigated. :-( I have been totally buried
> with other tasks in the last weeks. :-((

Could you explain or point me to some RFC for the following lines in the TCP 
window tracking patch.?

+/* Fixme: what about big packets? */
+#define MAXACKWINCONST                 66000
+#define MAXACKWINDOW(sender)           ((sender)->td_maxwin > MAXACKWINCONST ? 
(sender)->td_maxwin : MAXACKWINCONST)

Shouldn't it be (or what is the point of having MAXACKWINCONST):

+#define MAXACKWINDOW(sender)           ((sender)->td_maxwin > MAXACKWINCONST ?
  MAXACKWINCONST : (sender)->td_maxwin)

Why do you do the following thing? Isn't it up to the ruleset to take care of 
this? What if I would like to have those flags accepted :)?

+       tcpflags = (((u_int8_t *)tcph)[13] & ~(TH_ECE|TH_CWR));
+       if (tcpflags != TH_SYN
+           && tcpflags != (TH_SYN|TH_ACK)
+           && tcpflags != TH_RST
+           && tcpflags != (TH_RST|TH_ACK)
+           && tcpflags != (TH_RST|TH_ACK|TH_PUSH)
+           && tcpflags != (TH_FIN|TH_ACK)
+           && tcpflags != TH_ACK
+           && tcpflags != (TH_ACK|TH_PUSH)
+           && tcpflags != (TH_ACK|TH_URG)
+           && tcpflags != (TH_ACK|TH_URG|TH_PUSH)
+           && tcpflags != (TH_FIN|TH_ACK|TH_PUSH)
+           && tcpflags != (TH_FIN|TH_ACK|TH_URG)
+           && tcpflags != (TH_FIN|TH_ACK|TH_URG|TH_PUSH)) {
+               if (ip_ct_tcp_log_out_of_window && net_ratelimit())
+                       log_invalid_packet(iph, tcph, "ip_conntrack_tcp: 
INVALID: invalid TCP flag combination.\n");
+               return 1;
+       }

Best regards,
Roberto Nibali, ratz
-- 
echo '[q]sa[ln0=aln256%Pln256/snlbx]sb3135071790101768542287578439snlbxq' | dc
