From: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
Subject: Re: iptables modules efficiency, caching in conntrack
Date: Mon, 15 May 2006 21:29:57 +0200
Message-ID: <4468D6B5.20108@gmx.net>
References: <e4a6bo$evh$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <e4a6bo$evh$1@sea.gmane.org>
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

Hi Amin,

Amin Azez wrote:
> I've done work with a few iptables modules, conntrack, ipt_recent,
> ipt_account (recently) and others.
> 
> The design usually consists of a module specific storage using some
> aspects of the connection or packet as a key to the storage.
> 
> For each packet, each module calculates the key, fetches and locks the
> storage record, makes decisions and updates, unlocks and continues.
> 
> I also notice a similarity between many modules, ipt_set, ipt_recent,
> ipt_account, and think how much space and time is used less efficiently
> when more than one of these are used together.

Have you looked at ipt_ACCOUNT (the capitalized one)? IIRC their storage
model is quite efficient and works fine even under memory pressure and
requires only 0-order-allocations.

If you want, I can supply you with a 64-bit-clean kernel-2.6 version
of ipt_ACCOUNT.

Regards,
Carl-Daniel
-- 
http://www.hailfinger.org/
