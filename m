From: Amin Azez <azez@ufomechanic.net>
Subject: aggg Re: libnfnetlink_conntrack encapsulation issues
Date: Thu, 27 Jul 2006 12:04:56 +0100
Message-ID: <44C89DD8.7030103@ufomechanic.net>
References: <44C89B2E.1080401@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <44C89B2E.1080401@ufomechanic.net>
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

Not only is linux_nfnetlink_conntrack.h from SVN and not any kernel, it
even ignores the kernel config so such ifdef's as:

enum ctattr_type {
        CTA_UNSPEC,
        CTA_TUPLE_ORIG,
        CTA_TUPLE_REPLY,
        CTA_STATUS,
        CTA_PROTOINFO,
        CTA_HELP,
        CTA_NAT_SRC,
#define CTA_NAT       CTA_NAT_SRC     /* backwards compatibility */
        CTA_TIMEOUT,
        CTA_MARK,
        CTA_COUNTERS_ORIG,
        CTA_COUNTERS_REPLY,
        CTA_USE,
        CTA_ID,
        CTA_NAT_DST,
#if defined(CONFIG_IP_NF_MATCH_LAYER7) ||
defined(CONFIG_IP_NF_MATCH_LAYER7_MODULE)
        CTA_L7,
#endif /* LAYER7 */
#ifdef CONFIG_IP_NF_CT_LINKLAYER
        CTA_LINKLAYER,
#endif /* LINKLAYER */
...
...
...

are ignored, resulting in a totally different enum anyway.

I see now that obviously these extra enum members should not be defined
with ifdef, and it fact it makes a lot of sense, otherwise rebuilding
with a new match enabled as a module would change the enum definition
for that module but for nothing else.

BUT if libnetlink_conntrack is going to be reading kernel files, ought
it not to read in the kernel config too?

oy oy oy. Sorry to be so dumb, but I don't think we've hit the right
kernel/userspace solution yet.

I'm reminded of the windows make_atom call which allows you or anyone to
 supply a string and get the same number back every time, I wonder if we
need that instead of enums.

Sam
