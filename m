From: Piotr Chytla <pch@packetconsulting.pl>
Subject: CONNMARK target without ip_conntrack
Date: Wed, 19 Oct 2005 00:17:02 +0200
Message-ID: <20051018221702.GA22386@packetconsulting.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
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

Today one of my friends told me about very simple problem with CONNMARK ,
after loading it without ip_conntrack, everything is ok but marking
isn't working . 

In ipt_CONNMARK.c I've found in function target :

[..]
static unsigned int
target(struct sk_buff **pskb,
       const struct net_device *in,
       const struct net_device *out,
       unsigned int hooknum,
       const void *targinfo,
       void *userinfo)
{
[..]
        enum ip_conntrack_info ctinfo;
        struct ip_conntrack *ct = ip_conntrack_get((*pskb), &ctinfo);
        if (ct) {
		[..] - set/save/restore mark
	} 
[..]

Mark set/restore/save is set when ip_conntrack structure exist , but
there is no warning message in logs about not loaded ip_conntrack or
something similar. Maybe it's wise to put some warning message :

if (ct) {
	[..]
} else printk(KERN_ERR "CONNMARK: no conntrack!\n");

/pch

-- 
Dyslexia bug unpatched since 1977 ...
exploit has been leaked to the underground.
