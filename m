From: Herve Eychenne <rv@wallfire.org>
Subject: Re: [PATCH] Re: hashsize available through /proc was RAM and conntrack performance: first draft of the document is online
Date: Thu, 27 Nov 2003 12:38:15 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031127113815.GD1083@eychenne.org>
References: <20031127041452.GD1084@eychenne.org> <Pine.LNX.4.44.0311271102000.21649-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0311271102000.21649-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, Nov 27, 2003 at 11:09:03AM +0100, Henrik Nordstrom wrote:

> On Thu, 27 Nov 2003, Herve Eychenne wrote:

Anyway, Harald had already made a patch for pom without telling,
and Patrick discussed it some hours ago.

> Also what kernel version did you do this in? Your source does not seem to
> match either 2.4.22 or 2.6.0-test10.. in the sources I see the conntrack
> sysctls are all in ip_conntrack_standalone.c not ip_conntrack_core.c..
> (looks like you got the filename wrong only..  the sources seem to match
> ip_conntrack_standalone.c even if the header say 
> ip_conntrack_core.c.new/orig)

I worked on 2.4.22 Debian kernel sources (patched), but in vanilla
kernel 2.4.22, the files you're talking about are identical to the
Debian sources (which contain only a few patches).
And I maintain that my patch is against ip_conntrack_core.c...

This is crazy, as I'm aware that Harald's patch what against
ip_conntrack_standalone.c... but I just downloaded a fresh 2.4.22
kernel from kernel.org, and I can swear that sysctls are in
ip_conntrack_core.c (and not ip_conntrack_standalone.c).

rv@comet:/usr/src/linux-2.4.22/net/ipv4/netfilter$ grep sysctl *
ip_conntrack_core.c:#include <linux/sysctl.h>
ip_conntrack_core.c:static struct ctl_table_header *ip_conntrack_sysctl_header;
ip_conntrack_core.c:unregister_sysctl_table(ip_conntrack_sysctl_header);
ip_conntrack_core.c:    ip_conntrack_sysctl_header
ip_conntrack_core.c:  = register_sysctl_table(ip_conntrack_root_table, 0);
ip_conntrack_core.c:    if (ip_conntrack_sysctl_header == NULL) {
ip_queue.c:#include <linux/sysctl.h>
ip_queue.c:static int sysctl_maxlen = IPQ_QMAX_DEFAULT;
ip_queue.c:static struct ctl_table_header *ipq_sysctl_header;
ip_queue.c:     { NET_IPQ_QMAX, NET_IPQ_QMAX_NAME, &sysctl_maxlen,
ip_queue.c:  sizeof(sysctl_maxlen), 0644, NULL, proc_dointvec },
ip_queue.c:  ipq_sysctl_header = register_sysctl_table(ipq_root_table, 0);
ip_queue.c:             goto cleanup_sysctl;
ip_queue.c:cleanup_sysctl:
ip_queue.c:     unregister_sysctl_table(ipq_sysctl_header);
ipt_REJECT.c:   /* FIXME: Use sysctl number. --RR */
ipt_ULOG.c: *            nlgroup now global (sysctl)
rv@comet:/usr/src/linux-2.4.22/net/ipv4/netfilter$

Has someone an explanation, before I'm going nuts?

 Herve

-- 
 _
(°=  Hervé Eychenne
//)
v_/_ WallFire project:  http://www.wallfire.org/
