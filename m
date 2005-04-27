From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] Fix NAT TCP sequence adjustment
Date: Wed, 27 Apr 2005 10:44:00 +1000
Message-ID: <1114562640.24187.9.camel@localhost.localdomain>
References: <20050402202438.GA2968@linuxace.com>
	<4250435E.1090309@trash.net> <20050403235320.GB28850@linuxace.com>
	<20050404044033.GA1847@linuxace.com>  <4250FA72.3020502@trash.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4250FA72.3020502@trash.net>
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

On Mon, 2005-04-04 at 10:27 +0200, Patrick McHardy wrote:
> Phil Oester wrote:
> > If the retransmitted packet were the same packet as the last one which was
> > mangled, the seq will be adjusted by offset_before, which at this point is
> > the same adjustment as the first packet received via offset_after. So,
> > seq == correction_pos for the retransmitted packet, and this is fairly trivial
> > to handle.  This is the only case where I can see before() triggering a false
> > positive.
> 
> What you are trying to do is to reconstruct the original sequence
> number, so lets consider the possible cases:

Please enhance nfsim-testsuite with these.  I dislike adding new hooks,
but to be honest I haven't had time to follow this conversation.  At
least a testcase will allow us to vet other solutions, and prevent us
from breaking this again.

Rusty.
-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
