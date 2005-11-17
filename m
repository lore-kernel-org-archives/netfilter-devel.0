From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER]: DCCP conntrack/NAT
Date: Thu, 17 Nov 2005 06:46:17 +0100
Message-ID: <437C1929.8070808@trash.net>
References: <437C1805.40400@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	dccp@vger.kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Ian McDonald <imcdnzl@gmail.com>
In-Reply-To: <437C1805.40400@trash.net>
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

Patrick McHardy wrote:
> I've updated the DCCP conntrack patch to apply to the current
> kernel and added NAT support. No further work has be done
> so far, the state transitions are probably still incomplete
> and/or wrong, but NAT seems to work in some quick testing.
> 
> If you're going to test it, please let me know about problems.

Already found the first one. If you want to use it on SMP you
need to replace DEFINE_SPINLOCK by DEFINE_RWLOCK.

> diff --git a/net/ipv4/netfilter/ip_conntrack_proto_dccp.c b/net/ipv4/netfilter/ip_conntrack_proto_dccp.c
> new file mode 100644
> index 0000000..f90e152
> --- /dev/null
> +++ b/net/ipv4/netfilter/ip_conntrack_proto_dccp.c
> @@ -0,0 +1,741 @@
...
> +
> +static DEFINE_SPINLOCK(dccp_lock);
> +
