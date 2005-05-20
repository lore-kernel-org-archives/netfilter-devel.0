From: cranium2003 <cranium2003@yahoo.com>
Subject: IP packet logging  function help
Date: Thu, 19 May 2005 21:19:17 -0700 (PDT)
Message-ID: <20050520041917.322.qmail@web33004.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-bounces@lists.netfilter.org>
To: netfilter <netfilter-devel@lists.netfilter.org>,
	netfilter <netfilter@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

hello,
       By adding iptable rule
iptable -A OUTPUT -j LOG
 I am able to check log of each outgoing packets. But
i want to know who is actually calling ipt_log_target
function defined in ipt_LOG.c as
static unsigned int
ipt_log_target(struct sk_buff **pskb,
               unsigned int hooknum,
               const struct net_device *in,
               const struct net_device *out,
               const void *targinfo,
               void *userinfo)

I want to know which file in source code has pointer
to call ipt_log_target function? I want instance/copy
of const struct net_device *out to my function in
kernel to know that eth0 or eth1 is transmitting
packet.
Thanks in advance.
regards,
cranium


		
__________________________________ 
Do you Yahoo!? 
Make Yahoo! your home page 
http://www.yahoo.com/r/hs
