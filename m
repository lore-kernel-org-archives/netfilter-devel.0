From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH]: fixed kernel panic when trying to find tcp option
Date: Wed, 15 Sep 2004 10:22:36 -0700
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040915102236.6100ea14.davem@davemloft.net>
References: <200409151136.i8FBajor029883@toshiba.co.jp>
	<20040915084335.6944eebe.davem@davemloft.net>
	<20040915085049.7a7d45f0.davem@davemloft.net>
	<200409151720.i8FHKJAC002371@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, usagi-core@linux-ipv6.org,
        yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200409151720.i8FHKJAC002371@toshiba.co.jp>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, 16 Sep 2004 02:20:18 +0900 (JST)
Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> wrote:

> If you do it, all tcp packets which has no option will be dropped
> in the case of adding tcp-option match rule.

You are right.

Did your patch return "invert" from tcp_find_option() when optlen
is zero?  I deleted it, sorry.
