From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] matching any helper in ipt_helper.c
Date: Fri, 05 Mar 2004 03:13:05 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4047E231.60304@trash.net>
References: <Pine.LNX.4.60.0403031947450.8957@dsl093-017-216.msp1.dsl.speakeasy.net> <40469E10.7080100@trash.net> <Pine.LNX.4.60.0403032150000.8957@dsl093-017-216.msp1.dsl.speakeasy.net> <4046BFB9.809@trash.net> <Pine.LNX.4.60.0403041500280.10634@dsl093-017-216.msp1.dsl.speakeasy.net> <4047A42E.6080307@trash.net> <Pine.LNX.4.60.0403041821010.21790@dsl093-017-216.msp1.dsl.speakeasy.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,  linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Matthew Strait <quadong@users.sourceforge.net>
In-Reply-To: <Pine.LNX.4.60.0403041821010.21790@dsl093-017-216.msp1.dsl.speakeasy.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Matthew Strait wrote:
> Silly me, I assumed that the error was generated in user space.  Ok.  In
> that case, let's forget translating "any" to "", because that just makes
> the output of "iptables -L" confusing.  Sound good?
>

I actually meant translate in both direction. But no problem, I'm going
to make a patch for iptables myself, if Martin is fine with it we can
remove the childlevel match.

Thanks.

Patrick
