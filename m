From: Patrick McHardy <kaber@trash.net>
Subject: Re: Still problems w/ ip_conntrack as module
Date: Sat, 6 Sep 2003 14:20:33 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0309061417540.4298-100000@gw.localnet>
References: <179356969284.20030905235320@lf.lv>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Peteris Krumins <newsgroups@lf.lv>
In-Reply-To: <179356969284.20030905235320@lf.lv>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 5 Sep 2003, Peteris Krumins wrote:
>  Now again, i upgraded the machine to 2.4.21-pre6
>  (last known stable from 2.4.x tree for my needs imo),
>  the problem is there again. This time i cant

Use a newer kernel, the fix went in 2.4.22-pre8. Alternatively
the patch is in patch-o-matic
(submitted/70_ip-conntrack-expect-drop-refcnt-combined.patch).

Regards
Patrick


> P.Krumins
