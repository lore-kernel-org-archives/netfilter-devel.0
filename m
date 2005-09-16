From: scarab@echostar.pl
Subject: NF_IP_PRE_ROUTING?
Date: Fri, 16 Sep 2005 21:45:35 +0200
Message-ID: <200509162145.35698.scarab@echostar.pl>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
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

Hi
I wrote simple linux firewall (nf_hook based). Below  is part of that code:
------------
static struct nf_hook_ops       lpf_nfh;

lpf_nfh.hook = lpf_hook_fn; 
lpf_nfh.hooknum = NF_IP_PRE_ROUTING; 
lpf_nfh.pf = PF_INET;  
lpf_nfh.priority = NF_IP_PRI_FIRST; 

nf_register_hook(&lpf_nfh); 
--------------
 
I have question. It should get only incoming packets so why it takes outgoing 
to? If i will use  NF_IP_POST_ROUTING [4] then it should get outgoing packets 
right? I found that diagram in "Linux netfilter hacking howto":

--->[1]--->[ROUTE]--->[3]--->[4]--->
                          |                   ^
                          |                    |
                          |              [ROUTE]
                          v                    |
                         [2]                [5]
                          |                   ^
                          |                    |
                          v                    |

Can anyone tell me why it works that way?
Thank you

PS. Sorry for my poor english
