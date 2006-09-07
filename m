From: Patrick McHardy <kaber@trash.net>
Subject: Re: small check_entry & module_refcount cleanup
Date: Thu, 07 Sep 2006 17:02:36 +0200
Message-ID: <4500348C.4010508@trash.net>
References: <200609041617.39950.dim@openvz.org>
	<200609060124.k861OBle010614@toshiba.co.jp>
	<44FF1209.2000302@trash.net> <200609071408.28380.dim@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Dmitry Mishin <dim@openvz.org>
In-Reply-To: <200609071408.28380.dim@openvz.org>
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

Dmitry Mishin wrote:
> While standard_target has target->me == NULL, module_put() should be
> called for it as for others, because there were try_module_get() before.

Applied, thanks Dmitry.
