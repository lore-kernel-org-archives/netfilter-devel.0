From: Patrick McHardy <kaber@trash.net>
Subject: Re: [1/1] ipt_osf: fix ipt_osf compilation on some distros.
Date: Sun, 27 Feb 2005 17:32:09 +0100
Message-ID: <4221F609.3060305@trash.net>
References: <1109308057.6728.54.camel@uganda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
To: johnpol@2ka.mipt.ru
In-Reply-To: <1109308057.6728.54.camel@uganda>
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

Evgeniy Polyakov wrote:
> Some distros have magical header mess, which leads to undefined struct
> tcphdr, 
> when net/tcp.h is not included directly.
> Following patch workarounds it.

You should include linux/tcp.h for struct tcphdr. You probably also
don't need the other net/ includes, for struct iphdr use linux/ip.h,
sock.h shouldn't be needed at all.

> Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
> 
> --- orig/osf/linux-2.6/net/ipv4/netfilter/ipt_osf.c~ 2005-02-07
> 18:55:56.000000000 +0300
> +++orig/osf/linux-2.6/net/ipv4/netfilter/ipt_osf.c  2005-02-24
> 12:49:22.329311368 +0300
> @@ -47,6 +47,7 @@
> 
>  #include <net/sock.h>
>  #include <net/ip.h>
> +#include <net/tcp.h>
> 
>  #include <linux/netfilter_ipv4/ip_tables.h>
> 
> 
> P.S. Should I resend lost patch with Subject line 
> "[1/1] libipt_osf: fix iptables-1.3.0rc1 compilation.", which moves
> kernel headers in ipt_osf.h into appropriate ifdef/endif?

Yes, please.

Regards
Patrick
