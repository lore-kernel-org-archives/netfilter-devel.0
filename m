From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [NETFILTER 00/05]: updated nf_nat patch
Date: Sat, 04 Nov 2006 02:34:45 +0900 (JST)
Message-ID: <200611031734.kA3HYkN3003415@toshiba.co.jp>
References: <20061103164836.15103.46291.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <20061103164836.15103.46291.sendpatchset@localhost.localdomain>
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

From: Patrick McHardy <kaber@trash.net>
Date: Fri,  3 Nov 2006 17:46:24 +0100 (MET)

> I've updated your nf_nat patch to apply on top of Martin's patches
> (on top of the current git tree) and merged the changes we had in
> IPv4 NAT since then.

Great!

> I've also reviewed the patch a bit, the main problem I found so
> far is the nf_conntrack allocation scheme, which requires all
> features to be known at creation time, so it doesn't allow
> nf_conntrack_alter_reply to assign a helper to a connection
> that previously didn't have one (same problem for helpers
> like H.323 which manually assign helpers in their expectfns).

It might be the time to add something like Rusty's ct_extend.

My temporary idea is forcing to allocate area for helper in all
conntrack after H.323 helper is loaded.

-- Yasuyuki Kozakai
