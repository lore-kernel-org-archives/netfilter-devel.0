From: Roberto Nibali <ratz@drugphish.ch>
Subject: Re: when IPVS into netfilter?
Date: Tue, 20 May 2003 09:42:17 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3EC9DC59.6010006@drugphish.ch>
References: <3EB44BE7.3070602@wanadoo.es> <3EBCE288.5020801@drugphish.ch> <3EBEACBC.2090202@wanadoo.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Xose Vazquez Perez <xose@wanadoo.es>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello Xose,

> I can't understand this, the code is not ready for to put into kernel but
> it is ready for enterprise use ;-)

1. That's your view, yes. Kernel net maintainers were not so nice with
    us when we first proposed the code for inclusion.
2. There is a lot of stable code around on the net that can't be
    included into the mainline kernel because the design doesn't suit the
    rest of the kernel control path. Think about the grsecurity patches.
3. We are now officially working on it :).

> well, never is too late for 2.5. A lot of features were included into
> latest 2.4.xx. And ,in theory, it is more frozen than a penguin at north pole.

We'll see. I've started a discussion in the core dev team about it.

> if the code is not into the kernel, then it's little useful. Because
> not all people are kernel hackers and they need official distribution
> support. And custom kernels are not supported.

There are official distributions which support LVS, RH and SuSE come to 
mind.

> It is not necessary to have a leader, bugs must go to mailing-list.

Yes, that's what they always say. The truth is different, ask Harald 
Welte about some netfilter questions he finds in his Inbox.

> well, ipvs has 5 years of history. Versions are released every XX time.
> Red Hat has sold 6.2 and next distributions with ipvs patch.
> It works! And how many headaches has you gotten?

Yes, I know it works, it was stable starting around June 1999 on 2.0.35 
and ever since. No headaches so far :).

> it is easy to patch kernel, for me it's not a problem.
> But now LiNUX is not only a hacker OS, there are places where you need
> to have distribution support because the boss wants it :-)

Now how exactly does this work? Only because a feature is in the kernel, 
doesn't necessarily mean that a distributor supports it. But as I've 
said, we'll be working on an inclusion comitee for LVS. Most of the core 
  LVS hackers will meet at OLS this year and we'll have a BoF too, so 
stay tuned until about August. A lot of decisions will be made then, 
kernel wise, gcc wise, netfilter wise, ... .

And to go back on being more on-topic, I'd like to ask the netfilter 
team if the ip_fw_compat.c is going to remain in the 2.5.x/2.6.x cycle?
I was under the impression that Rusty once mentioned that he'd wanted to 
get rid of it, but I could be dreaming here.

We have following patch which hooks up LVS to netfilter and sneaks away 
packets and a patch to export a symbol for multicasting.

--- linux-2.5.69/net/ipv4/netfilter/ip_fw_compat.c      Mon May  5 
07:53:13 2003
+++ linux-2.5.69-ipvs-1.1.5/net/ipv4/netfilter/ip_fw_compat.c   Fri May 
  9 11:52:09 200
3
@@ -43,6 +43,10 @@
  extern int __init masq_init(void);
  extern void masq_cleanup(void);

+/* From ip_vs_core.c */
+extern unsigned int
+check_for_ip_vs_out(struct sk_buff **skb_p, int (*okfn)(struct sk_buff *));
+
  /* They call these; we do what they want. */
  int register_firewall(int pf, struct firewall_ops *fw)
  {
@@ -172,8 +176,14 @@
                 return NF_ACCEPT;

         case FW_MASQUERADE:
-               if (hooknum == NF_IP_FORWARD)
+               if (hooknum == NF_IP_FORWARD) {
+#ifdef CONFIG_IP_VS
+                        /* check if it is for ip_vs */
+                        if (check_for_ip_vs_out(pskb, okfn) == NF_STOLEN)
+                                return NF_STOLEN;
+#endif
                         return do_masquerade(pskb, out);
+                }
                 else return NF_ACCEPT;

         case FW_REDIRECT:


I will send in a patch to correct the extern part as it is not ifdef'd. 
The second one is, which makes the whole LVS code as non-intrusive as 
even possible. I think the netfilter community could live with two more 
ifdef-blocks, right? :)

The next one is a symbol export which we need to smuggle into the kernel 
bypassing DaveM :). No, seriously, it should be feasable.

--- linux-2.5.69/net/netsyms.c  Mon May  5 07:53:13 2003
+++ linux-2.5.69-ipvs-1.1.5/net/netsyms.c       Fri May  9 11:52:08 2003
@@ -265,6 +265,7 @@
  EXPORT_SYMBOL(in_aton);
  EXPORT_SYMBOL(ip_mc_inc_group);
  EXPORT_SYMBOL(ip_mc_dec_group);
+EXPORT_SYMBOL(ip_mc_join_group);
  EXPORT_SYMBOL(ip_finish_output);
  EXPORT_SYMBOL(inet_stream_ops);
  EXPORT_SYMBOL(inet_dgram_ops);


Comments, flames?

Best regards,
Roberto Nibali, ratz
-- 
echo '[q]sa[ln0=aln256%Pln256/snlbx]sb3135071790101768542287578439snlbxq'|dc
