From: Pablo Neira <pablo@netfilter.org>
Subject: [PATCH] ctnetlink updates take #2
Date: Tue, 08 Nov 2005 02:44:12 +0100
Message-ID: <437002EC.4000104@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>
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

Hi Harald,

Here follows another set of patches for ctnetlink (one for nfnetlink
included):

Pablo Neira:
ctnetlink:
[PATCH 1/8] Fix return value at nfattr_bad_size
[PATCH 2/8] Propagate error to userspace at getting
[PATCH 3/8] Identify expect by its ID
[PATCH 4/8] Fix racy counters zeroing
nfnetlink:
[PATCH 7/8] Skip sizechecking if it's zero
[PATCH 8/8] Add missing sizecheckings

Krzysztof Oledzki:
ctnetlink:
[PATCH 5/8] Check for ICMP_ID in icmp_nfattr_to_tuple
[PATCH 6/8] Fix ICMP id type

cheers,
Pablo

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
