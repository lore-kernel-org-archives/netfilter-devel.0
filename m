From: Andrew Beverley <andy@andybev.com>
Subject: Connlimit and linux-2.6.17
Date: Wed, 19 Jul 2006 22:29:15 +0100
Message-ID: <44BEA42B.3000304@andybev.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: martin.bene@icomedias.com, kraxel@bytesex.org
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

I (and others, see netfilter list) are having trouble compiling kernel 2.6.17.4 
and iptables-1.3.5-20060508 to use connlimit. Once compiled in and I run:

iptables -t mangle -A PREROUTING -p tcp -i eth0 -m \
	connlimit --connlimit-above 5 -j LOG

I get "iptables: Invalid argument", and dmesg tells me "ip_tables: connlimit 
match: invalid size 0 != 16"

The kernel and iptables are patched with connlimit from patch-o-matic-ng-20060626, 
which in turn is patched as per 
http://patchwork.netfilter.org/netfilter-devel/patch.pl?id=3456 to update the 
connlimit patch.

I have noticed that when compiling the kernel I get error messages as
follows when compiling connlimit:

net/ipv4/netfilter/ipt_connlimit.c:211: warning: initialization from incompatible 
pointer type
net/ipv4/netfilter/ipt_connlimit.c:212: warning: initialization from incompatible 
pointer type
net/ipv4/netfilter/ipt_connlimit.c:213: warning: initialization from incompatible 
pointer type

The code in question is the highlighted lines below:

static struct ipt_match connlimit_match = {
         .name = "connlimit",
         .match = &match,               <--
         .checkentry = &check,          <--
         .destroy = &destroy,           <--
         .me = THIS_MODULE
};

The above error messages do not appear when using 2.6.15, and connlimit works.

Any ideas?

On another note, is it possible for connlimit to form part of the stable kernel? 
It is a real pain having to mess around patching each time I get a new kernel, 
especially as currently the patch-o-matic also requires patching!

Andy Beverley
