From: Torsten Luettgert <t.luettgert@pressestimmen.de>
Subject: set breaks in 2.6.17
Date: Fri, 23 Jun 2006 23:14:38 +0200
Message-ID: <1151097278.3421.26.camel@murdegern.hindenburgdamm.example>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: kadlec@netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hi list, and especially Jozsef,

your set match and SET target break because of API changes
in 2.6.17.

The fix is trivial (insert a bunch of "const struct xt_match/target *"
parameters), but necessary. set will really break now, because a
new param is inserted before params which are actually used.

How do you want to handle it? I'd prefer to add a linux-2.6.17
dir in the patchlet and then fix both trees, so 2.6.16 will still
work.

Regards,
Torsten
