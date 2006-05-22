From: Patrick McHardy <kaber@trash.net>
Subject: EXPORT_SYMBOL vs EXPORT_SYMBOL_GPL
Date: Mon, 22 May 2006 18:01:23 +0200
Message-ID: <4471E053.2090601@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: yasuyuki.kozakai@toshiba.co.jp
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

Hi Yasuyuki,

while doing some stupid cleanup work on the conntrack code (moving
all EXPORT_SYMBOLs next to the exported function) I noticed
nf_conntrack uses EXPORT_SYMBOL for the exact same functions that
are EXPORT_SYMBOL_GPL'ed by ip_conntrack. I think we should change
it to _GPL too for consistency and because most of them mess deeply
inside the internals of conntrack.

Any objections to this change?
