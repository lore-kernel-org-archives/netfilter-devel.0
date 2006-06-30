From: Amin Azez <azez@ufomechanic.net>
Subject: xtables Re: Hacking iptables 1.3.5 for 2.6.17
Date: Fri, 30 Jun 2006 13:40:43 +0100
Message-ID: <44A51BCB.7090006@ufomechanic.net>
References: <e82pqq$3es$1@sea.gmane.org>	<200606300948.k5U9mNot001866@toshiba.co.jp>	<44A50091.7070003@ufomechanic.net>
	<200606301157.k5UBvJTl016149@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200606301157.k5UBvJTl016149@toshiba.co.jp>
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

Yasuyuki KOZAKAI wrote:
> As you says, netfilter_ipv4.h in 2.6.17.x has unnecessary
> '#include <config.h>' outside of __KERNEL__. But it seemd to be deleted
> in recent kernel as follows.
> 
>> commit 62c4f0a2d5a188f73a94f2cb8ea0dba3e7cf0a7f
>> Author: David Woodhouse <dwmw2@infradead.org>
>> Date:   Wed Apr 26 12:56:16 2006 +0100
>>
>>     Don't include linux/config.h from anywhere else in include/
>>
>>     Signed-off-by: David Woodhouse <dwmw2@infradead.org> 
> 
> I don't think/know that this goes to stable tree, though.

Thanks; thats helpful and also solves a long-standing puzzlement for me.
(Into my quilt stack it goes)

Next question relates to the port to xtables and friends, and what I
need to do to convert iptables targets.

I notice a lot of things have moved to net/netfilter/xt_*.c

Is this an absolute requirement, or is there some compatability system?

I'm porting the layer7 match first, currently when adding a layer7 rule
I get (dmesg):
[71987.513531] ip_tables: layer7 match: invalid size 0 != 8452

I know where the error is coming from I just wonder if I have to do a
complete conversion now, or a quick fix and fuller conversion later...

thanks

Sam
