From: Olivier GRALL <olivier.grall@neotip.com>
Subject: ow to intercept an udp packet sent by a socket in a Netfilter module
Date: Thu, 23 Dec 2004 11:02:46 +0100
Message-ID: <41CA97C6.8070002@neotip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
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

Hello

I'm writing a little module using netfilter. I want to catch an UDP 
packet sended by a socket and to change its source port without 
conntrack see the changes. I want to do it on the POSTROUTING Hook but I 
don't see any packets from a socket in my module logs.

So I want to know how to capture packets coming from a local socket in 
POSTROUTING.

For the moment, I register like this:
    static struct nf_hook_ops ipt_ops_out =
    {
      { NULL, NULL},
      ms_media_hook_out,
      THIS_MODULE,
      PF_INET,
      NF_IP_POST_ROUTING,
      NF_IP_PRI_NAT_SRC+1
    };

Thanks,

Olivier GRALL
