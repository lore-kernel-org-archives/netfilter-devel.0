From: Philip Craig <philipc@snapgear.com>
Subject: Re: [RFC][PATCH] optimise iptables interface matching
Date: Fri, 25 May 2007 09:07:11 +1000
Message-ID: <46561A9F.2010800@snapgear.com>
References: <465528CB.4020108@snapgear.com> <4655CEB0.4060306@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4655CEB0.4060306@trash.net>
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

Patrick McHardy wrote:
> I don't like the kernel-internal fiddling with the flags too
> much, but I don't see a way around it.

The other idea I had was moving the interface matching into
an internal match that would be checked by IPT_MATCH_ITERATE().
Not sure if this is feasible yet.

> userspace should just ignore unknown flags.

I was trying to completely hide them from userspace so that we
still have the option to use them for something else later on.
If we ever send them to userspace, then they are taken forever,
otherwise a newer iptables userspace may not work with an older
kernel.
