From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] libnfnetlink and libnetfilter_conntrack updates
Date: Mon, 18 Dec 2006 04:06:30 +0100
Message-ID: <458605B6.8060903@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>,
	Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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

Hi everyone,

I finally finished the new libnetfilter_conntrack API, I have spent this
weekend porting conntrackd to the new API as a way to test it, and it
seems to work fine here. The new API includes documentation and
overcomes (or at least tries to) the existing limitations. The patch is
available here (~80Kbytes):

http://people.netfilter.org/pablo/libnetfilter_conntrack/api.patch

Together with this patch comes another patch for libnfnetlink to
introduce some new API:

http://people.netfilter.org/pablo/libnfnetlink/libnfnetlink.patch

The use of the new API is strongly recommended since we plan to remove
the obsolete API sooner or later, anyway we'll warn everyone several
times before doing so. I'm also planning to port the remaining libraries
(libnetfilter_queue/log) to the new API.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
