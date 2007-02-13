From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: Bug: "You must specify `--icmpv6-type'"
Date: Tue, 13 Feb 2007 12:17:34 +0900 (JST)
Message-ID: <200702130317.l1D3HZBT003648@toshiba.co.jp>
References: <20070209102829.GA31011@roonstrasse.net>
	<200702130301.l1D3159w015381@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: max@duempel.org, netfilter-devel@lists.netfilter.org
To: yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200702130301.l1D3159w015381@toshiba.co.jp>
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


Hi, again,

From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Date: Tue, 13 Feb 2007 12:01:04 +0900 (JST)

> From: Max Kellermann <max@duempel.org>
> Date: Fri, 9 Feb 2007 11:28:29 +0100


> > According to the ip6tables manpage, the "icmpv6" module is implicitly
> > loaded whenever you specify "-p icmpv6".  It is however only loaded
> > when you also specify "--icmpv6-type".  So either the documentation is
> > wrong, or ip6tables' behaviour is.
> 
> This behavior is intended. The matches for protocol are not loaded when you
> specify only '-p protocol', but loaded when you specify extra options of
> them, too. This is to avoid unnecessary loading.

I noticed libipt_icmp doesn't check no specified type, then applied
following.

Thanks for chance to find out that.

-- Yasuyuki Kozakai

Error if no ICMP type is specified even though user intended
to use icmp match.

---
 extensions/libipt_icmp.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/extensions/libipt_icmp.c b/extensions/libipt_icmp.c
index 8f22d05..ce46837 100644
--- a/extensions/libipt_icmp.c
+++ b/extensions/libipt_icmp.c
@@ -284,6 +284,9 @@ static void save(const struct ipt_ip *ip
 /* Final check; we don't care. */
 static void final_check(unsigned int flags)
 {
+	if (!flags)
+		exit_error(PARAMETER_PROBLEM,
+			   "icmp match: You must specify `--icmp-type'");
 }
 
 static struct iptables_match icmp = { 
-- 
1.4.4
