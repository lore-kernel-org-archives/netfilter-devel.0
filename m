From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6.11 0/4]: Netfilter fixes
Date: Fri, 04 Feb 2005 04:05:02 +0100
Message-ID: <4202E65E.2030008@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
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

Hi Dave,

I hope these patches can still make it in 2.6.11. The TCP window tracking
bug seems quite important to me, but I haven't actually heard complains 
besides
Phil's yet. The others patches aren't very serious, but the patches are 
pretty
trivial.

You can pull all changes from bk://212.42.230.204/nf-2.6

Thanks,
Patrick


<nib:cookinglinux.org>:
  o [NETFILTER]: Fix ip_conntrack_ftp crash with debugging enabled

<sjean:cookinglinux.org>:
  o [NETFILTER]: Use GFP_ATOMIC in ipt_hashlimit

Pablo Neira:
  o [NETFILTER]: fix iptables userspace build

Phil Oester:
  o [NETFILTER]: Improve TCP window tracking retransmission detection
