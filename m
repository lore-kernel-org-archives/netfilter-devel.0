From: Patrick McHardy <kaber@trash.net>
Subject: Re: xtables Re: Hacking iptables 1.3.5 for 2.6.17
Date: Fri, 30 Jun 2006 16:39:16 +0200
Message-ID: <44A53794.6060405@trash.net>
References: <e82pqq$3es$1@sea.gmane.org>	<200606300948.k5U9mNot001866@toshiba.co.jp>	<44A50091.7070003@ufomechanic.net>	<200606301157.k5UBvJTl016149@toshiba.co.jp>
	<44A51BCB.7090006@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <44A51BCB.7090006@ufomechanic.net>
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

Amin Azez wrote:
> I notice a lot of things have moved to net/netfilter/xt_*.c
> 
> Is this an absolute requirement, or is there some compatability system?

No requirement, things can just stay where they are.

> I'm porting the layer7 match first, currently when adding a layer7 rule
> I get (dmesg):
> [71987.513531] ip_tables: layer7 match: invalid size 0 != 8452

8452? Thats ridiculous much .. anyway, you need to initialize the
.matchsize field to sizeof(struct ...) (the one shared with userspace).
