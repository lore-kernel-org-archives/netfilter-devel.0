From: Shen Qiyu <shenqiyu@eastday.com>
Subject: For netfilter ipt_ops, init() and nf_register_hook()
Date: Wed, 23 Oct 2002 14:57:33 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <002701c27a61$766f7eb0$c801a8c0@network1.sh.cn>
Mime-Version: 1.0
Content-Type: multipart/alternative;
 boundary="Boundary_(ID_QBtkecoD4uASjDVVU0saEA)"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.

--Boundary_(ID_QBtkecoD4uASjDVVU0saEA)
Content-type: text/plain; charset=gb2312
Content-transfer-encoding: 7BIT

Hi, guys,

When I read the source of netfilter(withe kernel 2.4.18), something pullzed me.

net/ipv4/netfilter/Iptable_filter.c
....
static struct nf_hook_ops ipt_ops[]
= { { { NULL, NULL }, ipt_hook, PF_INET, NF_IP_LOCAL_IN, NF_IP_PRI_FILTER },
    { { NULL, NULL }, ipt_hook, PF_INET, NF_IP_FORWARD, NF_IP_PRI_FILTER },
    { { NULL, NULL }, ipt_local_out_hook, PF_INET, NF_IP_LOCAL_OUT,
  NF_IP_PRI_FILTER }
};
...
static int __init init(void)
{
 ...
 ret = nf_register_hook(&ipt_ops[0]);
...
}

net\core\Netfilter.c

int nf_register_hook(struct nf_hook_ops *reg)
{
 struct list_head *i;

 br_write_lock_bh(BR_NETPROTO_LOCK);
 for (i = nf_hooks[reg->pf][reg->hooknum].next; 
      i != &nf_hooks[reg->pf][reg->hooknum]; 
      i = i->next) {
  if (reg->priority < ((struct nf_hook_ops *)i)->priority)
   break;
 }
 list_add(&reg->list, i->prev);
 br_write_unlock_bh(BR_NETPROTO_LOCK);
 return 0;
}

It seems that in list_add(&reg->list, i->prev), only a {NULL, NULL} list head is added, so how it run?

Regards.

Paul.
2002.10.23



--Boundary_(ID_QBtkecoD4uASjDVVU0saEA)
Content-type: text/html; charset=gb2312
Content-transfer-encoding: 7BIT

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<META content="MSHTML 6.00.2600.0" name=GENERATOR>
<STYLE></STYLE>
</HEAD>
<BODY bgColor=#ffffff>
<DIV><FONT face=Arial size=2>Hi, guys,</FONT></DIV>
<DIV><FONT face=Arial size=2></FONT>&nbsp;</DIV>
<DIV><FONT face=Arial size=2>When I read the source of netfilter(withe kernel 
2.4.18), something pullzed me.</FONT></DIV>
<DIV><FONT face=Arial size=2></FONT>&nbsp;</DIV>
<DIV><FONT face=Arial size=2>net/ipv4/netfilter/Iptable_filter.c</FONT></DIV>
<DIV><FONT face=Arial size=2>....</FONT></DIV>
<DIV><FONT face=Arial size=2>static struct nf_hook_ops ipt_ops[]<BR>= { { { 
NULL, NULL }, ipt_hook, PF_INET, NF_IP_LOCAL_IN, NF_IP_PRI_FILTER 
},<BR>&nbsp;&nbsp;&nbsp; { { NULL, NULL }, ipt_hook, PF_INET, NF_IP_FORWARD, 
NF_IP_PRI_FILTER },<BR>&nbsp;&nbsp;&nbsp; { { NULL, NULL }, ipt_local_out_hook, 
PF_INET, NF_IP_LOCAL_OUT,<BR>&nbsp;&nbsp;NF_IP_PRI_FILTER }<BR>};</FONT></DIV>
<DIV><FONT face=Arial size=2>...</FONT></DIV>
<DIV><FONT face=Arial size=2>static int __init init(void)<BR>{</FONT></DIV>
<DIV><FONT face=Arial size=2>&nbsp;...</FONT></DIV>
<DIV><FONT face=Arial size=2>&nbsp;ret = 
nf_register_hook(&amp;ipt_ops[0]);<BR>...</FONT></DIV>
<DIV><FONT face=Arial size=2>}</FONT></DIV>
<DIV><FONT face=Arial size=2></FONT>&nbsp;</DIV>
<DIV><FONT face=Arial size=2>net\core\Netfilter.c</FONT></DIV>
<DIV><FONT face=Arial size=2></FONT>&nbsp;</DIV>
<DIV><FONT face=Arial size=2>int nf_register_hook(struct nf_hook_ops 
*reg)<BR>{<BR>&nbsp;struct list_head *i;</FONT></DIV>
<DIV>&nbsp;</DIV>
<DIV><FONT face=Arial 
size=2>&nbsp;br_write_lock_bh(BR_NETPROTO_LOCK);<BR>&nbsp;for (i = 
nf_hooks[reg-&gt;pf][reg-&gt;hooknum].next; <BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; i 
!= &amp;nf_hooks[reg-&gt;pf][reg-&gt;hooknum]; 
<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; i = i-&gt;next) {<BR>&nbsp;&nbsp;if 
(reg-&gt;priority &lt; ((struct nf_hook_ops 
*)i)-&gt;priority)<BR>&nbsp;&nbsp;&nbsp;break;<BR>&nbsp;}<BR>&nbsp;list_add(&amp;reg-&gt;list, 
i-&gt;prev);<BR>&nbsp;br_write_unlock_bh(BR_NETPROTO_LOCK);<BR>&nbsp;return 
0;<BR>}</FONT></DIV>
<DIV><FONT face=Arial size=2>&nbsp;</DIV></FONT>
<DIV><FONT face=Arial size=2>It seems that in list_add(&amp;reg-&gt;list, 
i-&gt;prev), only a {NULL, NULL} list head is added, so how it run?</FONT></DIV>
<DIV><FONT face=Arial size=2></FONT>&nbsp;</DIV>
<DIV><FONT face=Arial size=2>Regards.</FONT></DIV>
<DIV><FONT face=Arial size=2></FONT>&nbsp;</DIV>
<DIV><FONT face=Arial size=2>Paul.</FONT></DIV>
<DIV><FONT face=Arial size=2>2002.10.23</DIV>
<DIV><BR></DIV></FONT></BODY></HTML>

--Boundary_(ID_QBtkecoD4uASjDVVU0saEA)--
