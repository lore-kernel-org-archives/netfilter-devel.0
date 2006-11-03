From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 10/11] Remove unused struct list_head from protocols
Date: Fri, 03 Nov 2006 13:27:56 +0100
Message-ID: <454B35CC.9040205@trash.net>
References: <20061101210845.337590368@wlug.westbo.se>
	<20061101210914.693243726@wlug.westbo.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <20061101210914.693243726@wlug.westbo.se>
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

Martin Josefsson wrote:
> Remove unused struct list_head from struct nf_conntrack_l3proto
> and nf_conntrack_l4proto as all protocols are kept in arrays, not linked lists.

Applied.
