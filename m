From: Robbie Dinn <robbie@microbus.com>
Subject: Re: Question, my modifed -j LOG
Date: Sun, 21 Aug 2005 15:16:47 +0100
Message-ID: <43088CCF.6050401@microbus.com>
References: <20050820172824.GE5638@aaricia.csbnet.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20050820172824.GE5638@aaricia.csbnet.se>
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

Joakim Axelsson wrote:
> The --log-prefix is way to short only allowing 30 characters. I have a huge
> firewall with over 10000 rules (of couse not every packet using every rule).
> Its impossible to keep track on where the packet is unless i supply the
> table (filter,nat,mangle,raw) and the chain name in --log-prefix. Even if i
> try to keep this short there is very little, if no room, left for a reason
> to fit in --log-prefix. Simple solution for me is to modify -j LOG to handle
> a longer --log-prefix.

How about using an unmodified iptables --log-prefix , but instead of
using the long string with the full information in it, substitute
that string with it's (fixed length) hash. You could then postprocess
the logfiles to replace the hash with the original text.

i.e. change the problem from a kernel hacking exercise into a boring
scripting/text filtering exercise.

I suspect this isn't the answer you are looking for, but it might do
the job.
