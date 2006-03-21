From: Dmitry Mishin <dim@sw.ru>
Subject: Re: [NETFILTER 09/09]: futher {ip,ip6,arp}_tables unification
Date: Tue, 21 Mar 2006 12:21:00 +0300
Message-ID: <200603211221.01041.dim@sw.ru>
References: <20060321015549.11977.45799.sendpatchset@localhost.localdomain>
	<200603211056.02339.dim@sw.ru> <441FC06E.60902@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: dev@openvz.org, netfilter-devel@lists.netfilter.org, davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <441FC06E.60902@trash.net>
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

On Tuesday 21 March 2006 11:59, Patrick McHardy wrote:
> Dmitry Mishin wrote:
> > Could you give more details on it in order to avoid such confusion next
> > time?
>
> Sorry, I haven't figured out the problem yet, but it seems your
> patch wasn't responsible. Anyway, I'll fix it once I figure it
> out, so don't worry.
Could it be due to alignment checks in user or kernel space? I don't check it, 
but think that current ip6_tables compatibility layer isn't sufficient, as it 
is for ip_tables compatibility.

Quoting my answer from the respective discussion:
"
> What is the reason that you did not just address this in the
> compat_sys_setsockopt implementation?
Code above doesn't work. iptables with version >= 1.3 does alignment checks as 
well as kernel does. So, we can't simply put entries with 8 bytes alignment 
to userspace or with 4 bytes alignment to kernel - we need translate them 
entry by entry. So, I tried to do this the most correct way - that userspace 
will hide its alignment from kernel and vice versa, with not only 
SET_REPLACE, but also GET_INFO, GET_ENTRIES and SET_COUNTERS translation.
"

-- 
Thanks,
Dmitry.
