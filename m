From: Roberto Nibali <ratz@tac.ch>
Subject: Re: iptables u32 match code for review/testing/...
Date: Wed, 08 Jan 2003 11:31:53 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E1BFE19.9020509@tac.ch>
References: <200212271854.gBRIsf131987@isis.cs3-inc.com>	<20030106125720.GF9467@sunbeam.de.gnumonks.org>	<15897.46884.822054.847738@isis.cs3-inc.com>	<20030107185748.GV9467@sunbeam.de.gnumonks.org> <15899.51201.381520.438520@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: ", Harald Welte" <laforge@gnumonks.org>,
   netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Don Cohen <don-nf@isis.cs3-inc.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

>  > I like the content (code/implementation/idea of having u32).
>  > The only issue is that it doesn't really fit into the current iptables
>  > architecture. Why?
>  > 	- because it is a whole classification engine on it's own
> Why is this bad?  I wrote it to do things I wanted to do but didn't
> see how.  I think that's good.  If it subsumes a few others that are
> out there, even better.  (But it's almost certainly a lot slower than 
> any more specialized match, so they're still useful.)

What's wrong with: http://www.cyberus.ca/~hadi/patches/action/ ?
Why couldn't you use some of its code for the classification engine?

> But if you do want wide indentation (and don't mind >80 cols)
> then here you go:

Looks a lot nicer and ledgible to me but I'm not the one in position to 
criticise coding style.

Best regards,
Roberto Nibali, ratz
-- 
echo '[q]sa[ln0=aln256%Pln256/snlbx]sb3135071790101768542287578439snlbxq' | dc
