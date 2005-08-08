From: Aleksandar Milivojevic <alex@milivojevic.org>
Subject: Re: ipsec in transport mode is not handled correctly
Date: Mon, 08 Aug 2005 13:37:03 -0500
Message-ID: <20050808133703.pqoit3s6boks40oo@www.milivojevic.org>
References: <20050808103459.e1sm3gpj4wgs4coc@www.milivojevic.org>
	<20050808.083759.41635231.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-reply-to: <20050808.083759.41635231.davem@davemloft.net>
To: "David S. Miller" <davem@davemloft.net>
Content-disposition: inline
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

Quoting "David S. Miller" <davem@davemloft.net>:

> From: Aleksandar Milivojevic <alex@milivojevic.org>
> Subject: ipsec in transport mode is not handled correctly
> Date: Mon, 08 Aug 2005 10:34:59 -0500
>
>> I've noticed that on kernel-2.6.9-11.EL IPSec packets go through 
>> INPUT chain of
>> filter table only once if I use IPSec in transport mode.  They go there only
>> encrypted (ESP packet), but there's no second pass with decrytped packet.
>
> Well known problem, we're working on a solution constantly but
> it's not easy to fix.

Thanks for the quick answer.  Sorry for bugging the list with problem that was
well known.  I've searched around a bit, but probably haven't searched hard
enough ;-)

Anyhow, keep the good work

----------------------------------------------------------------
This message was sent using IMP, the Internet Messaging Program.
