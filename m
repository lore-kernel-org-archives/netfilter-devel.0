From: Patrick McHardy <kaber@trash.net>
Subject: nf-2.6.23 tree updated
Date: Wed, 27 Jun 2007 14:24:43 +0200
Message-ID: <4682570B.8040404@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

I've uploaded a new tree at

http://people.netfilter.org/kaber/nf-2.6.23.git/

Changes since the last update are a fixed crash in ct_extend
during unregistration, the move of conntrack and NAT hash to
hlists, use of hashing for expectations and a patch similar
to Vasily's early_drop improvement.

I'll rebase to net-2.6.23 once Dave's tree sits on top of -rc5
(there's a conflict currently) and push upstream.
