From: Yuan ChunYang <cyyuanml@sonata.iscas.ac.cn>
Subject: about netfilter priority
Date: 09 Jul 2003 22:27:48 +0800
Sender: linux-net-owner@vger.kernel.org
Message-ID: <1057760867.2143.15.camel@sonata>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-net-owner@vger.kernel.org>
To: ml_linux-net <linux-net@vger.kernel.org>,
	netfilter-devel <netfilter-devel@lists.netfilter.org>
List-Id: netfilter-devel.vger.kernel.org


As we know ,netfilter supply seven priorities,
        NF_IP_PRI_FIRST = INT_MIN,
        NF_IP_PRI_CONNTRACK = -200,
        NF_IP_PRI_MANGLE = -150,
        NF_IP_PRI_NAT_DST = -100,
        NF_IP_PRI_FILTER = 0,
        NF_IP_PRI_NAT_SRC = 100,
        NF_IP_PRI_LAST = INT_MAX,

1.Can somebody can tell me how to use this priority?
2. In my test, i find that :
   (1)if define NF_IP_LOCAL_OUT hooks,priority >= -24
   (2)if define NF_IP_POST_ROUTING hooks, priority >= -32
  else my module can be compiled but not be  insmod.
  
In netfilter of Linux 2.5.72, i think the priority being able to be defined by yourself. 

  I can not understand these.

Please help me!
                                   yuan

#################################################################
#
# define
#

#define NF_IP_PRI_MY_FIRST	-23
#define NF_IP_PRI_MY_LAST	-32

static struct nf_hook_ops my_ip_ops[] = {
	{ { NULL, NULL }, my_ip_output_first,
	PF_INET, NF_IP_LOCAL_OUT, NF_IP_PRI_MY_FIRST },

	{ { NULL, NULL }, my_ip_postroute_last,
	PF_INET, NF_IP_POST_ROUTING, NF_IP_PRI_MY_LAST }
};

#################################################################
#
# register
#

#define NUMHOOKS (sizeof(my_ip_ops)/sizeof(my_ip_ops[0]))

	for (i=0;i<NUMHOOKS;i++) {
		int ret;
		
		printk(KERN_INFO "i=%d\n",i);

		if ((ret = nf_register_hook(&my_ip_ops[i])) >= 0)
			continue;

		while (i--)
			nf_unregister_hook(&my_ip_ops[i]);
			
		return ret;
	}
#######################################################################

