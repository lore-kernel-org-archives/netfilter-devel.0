From: Roberto Nibali <ratz@drugphish.ch>
Subject: Re: TCP window tracking patch status query for further design considerations
Date: Wed, 09 Oct 2002 01:15:36 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3DA36718.7010903@drugphish.ch>
References: <Pine.LNX.4.33.0210090017160.24530-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Roberto Nibali <ratz@tac.ch>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
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

> Read Guido's article on which the patch is based:
> http://www.iane.nl/users/guido/papers/tcp_filtering.ps.gz

I actually did, even twice, but not carefully enough.

> The constant is a little bit bigger than the maximal possible window size
> without window scaling. The macro tries to take window scaling into
> account.

Got it.

>>Shouldn't it be (or what is the point of having MAXACKWINCONST):
>>
>>+#define MAXACKWINDOW(sender)           ((sender)->td_maxwin > MAXACKWINCONST ?
>>  MAXACKWINCONST : (sender)->td_maxwin)
> 
> 
> No, it'd make the possible ACK window smaller in the case of window
> scaling.

Makes sense now, why didn't it before?

> Those packets are either corrupted or invalid ones sent deliberately
> and would (wrongly) be reported as out of window ones.
> Most of the out of window log entries created by the earlier patch
> releases was generated because the code was not protected against such
> packets.

I understand. Thank you.

Regards,
Roberto Nibali, ratz
-- 
echo '[q]sa[ln0=aln256%Pln256/snlbx]sb3135071790101768542287578439snlbxq'|dc
