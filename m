From: "Nikolaos Fideropoulos" <n.fideropoulos@tu-bs.de>
Subject: tunneled packets
Date: Tue, 26 Nov 2002 16:17:24 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <008201c2955f$06e94da0$0c0aa8c0@aristo>
Reply-To: "Nikolaos Fideropoulos" <n.fideropoulos@tu-bs.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello,

i have 2 questions:

1) i want to monitor tunneled packets, but i'm not sure how they pass the
hooks. is following right?:

(incoming packets):
incoming_device->PRE_ROUTING->FORWARD->POST_ROUTING->tun-device(decapsulatio
n)->PRE_ROUTING->LOCAL_IN

(outgoing packets):
LOCAL_OUT->POST_ROUTING->tun-device(encapsualtion)->PRE_ROUTING->FORWARD->PO
ST_ROUTING->outgoing_device


2) I wanna write a small module which does some checks on packets in
NF_IP_LOCAL_IN, NF_IP_LOCAL_OUT and maintains a connection-table. I would
like to know if it's ok to do that in 1 Module (and 1 function), or should
that be done for any reason in seperate modules?

(example-code)
static int __init init(void)      {
            return nf_register_hook(&first);
            return nf_register_hook(&second);
      }


static struct nf_hook_ops first
     = { { NULL, NULL }, example_hook, PF_INET, NF_IP_LOCAL_IN,
NF_IP_PRI_FILTER-1 };
static struct nf_hook_ops second
      = { { NULL, NULL }, example_hook, PF_INET, NF_IP_LOCAL_OUT,
NF_IP_PRI_FILTER-1 };


example_hook(unsigned int hook, struct sk_buff **skb,
                                const struct net_device *indev, const
                                struct net_device *outdev, int
                                (*okfn)(struct sk_buff *))
{
..}



Regards,
Nikos
