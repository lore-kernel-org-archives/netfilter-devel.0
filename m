From: Patrick McHardy <kaber@trash.net>
Subject: conntrack-acct patch
Date: Fri, 23 Jul 2004 02:32:54 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <41005CB6.9070400@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Harald,

I have a question about the conntrack-acct patch. Why is accounting
done with timer refreshing ? Is it just because the function already
takes ip_conntrack_lock ? I think accounting should be done in the
core after the conntrack protocol accepted the packet, instead of
adding side-effects to ip_ct_refresh, which might even need some
no-account flag one day for things like ctnetlink.

Regards
Patrick
