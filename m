From: Roberto Nibali <ratz@tac.ch>
Subject: Re: Problem with IP-Pools
Date: Fri, 06 Dec 2002 14:00:23 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3DF09F67.30504@tac.ch>
References: <20021128162921.2b2a721d.markus.schaber@student.uni-ulm.de>	<20021205201113.GD11068@naboo.club.berlin.ccc.de> <20021205224314.3c38afec.markus.schaber@student.uni-ulm.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Markus Schaber <markus.schaber@student.uni-ulm.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello,

> You see, we're doing Gigabit ethernet here (about 600 MBit upstream
> bandwidth), and our largest host group currently has 9497 Entries.
> That's just too much for the usual O(n) method, one table containing one
> match rule per host, and building some tree-like tables to cut down the
> pass time to O(log(n)) is a maintenance nightmare.

I'm in kind of the same situation but I have solved it more or less. Please 
contact me privately so we can discuss about it.

> Not to mention the time to load an iptable with some tens of thousands
> of entries, we cannot wait half an hour for our firewall to boot up.

:) I know that problem. I'm working on a solution myself.

> If you know another method of managing such high traffic and host number
> combinations, we'd love to hear about it, because we _really_ want to
> leave Checkpoint.

I am surprised that checkpoint could handle such a configuration. We had to give 
up on checkpoint long ago because it wasn't able to handle hundreds of different 
NAPT configuration per interface correctly without stumbling over its own 
internal tables.

Just contact me offline so we can discuss things. Regards,
Roberto Nibali, ratz
-- 
echo '[q]sa[ln0=aln256%Pln256/snlbx]sb3135071790101768542287578439snlbxq' | dc
