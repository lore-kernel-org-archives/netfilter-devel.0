From: Roberto Nibali <ratz@tac.ch>
Subject: Re: TCP window tracking patch status query for further design considerations
Date: Tue, 08 Oct 2002 14:08:20 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3DA2CAB4.1030005@tac.ch>
References: <Pine.LNX.4.33.0210081210410.23021-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

Thank you very much for your reply.

> The problem hasn't still been investigated. :-( I have been totally buried
> with other tasks in the last weeks. :-((

I understand that. All good people are buried in work.

> I hope in this month I'll be able to run an excessive testing of the
> delayed SMTP delivery caused by the patch and find the solution.

If I can be of any help, let me know. I can run some tests in my lab since I 
have to test this patch anyway. I currently work with packet generation tools to 
send specially crafted IP packets to see if I can evade some functionality.

At least it seems to be quite stable so far. The only problem I'm experiencing 
is the interaction of the TCP state transition table modification influence when 
using LVS. In LVS we have done a similar state transition definition but IIRC it 
differs from yours. So now we have proc-fs exports for TCP state transition 
timing with your window tracking patch and proc-fs exports for the same timing 
entries from LVS.

> Even after the problem is fixed, some time will be required for further
> testing the patch before considering submitting into the kernel. Also,
> a decision will be required on the the proc interface of netfilter due to
> the new level introduced by the patch.

Let me know when you work on it again so I can maybe help you. I see that your 
patch does break some user space scripts that assume certain proc-fs entries for 
the conntrack_max variable. I hope though that nevertheless the netfilter team 
will be working on a future inclusion of this patch.

Thanks a bunch for your time,
Roberto Nibali, ratz
-- 
echo '[q]sa[ln0=aln256%Pln256/snlbx]sb3135071790101768542287578439snlbxq' | dc
