From: Roberto Nibali <ratz@tac.ch>
Subject: Re: iptables static linking
Date: Thu, 06 Mar 2003 11:21:27 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E672127.6000001@tac.ch>
References: <3E66E3DA.3000808@naturesoft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: shobhan <shobhankumar-rc@naturesoft.net>
In-Reply-To: <3E66E3DA.3000808@naturesoft.net>
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

> I am trying to compile iptables code with out shared libraries.but it is 
> hanging when i ran iptables.   Can we compile iptables without shared 
> libraries

Yes, it is possible and it also works. I recommend using at least version 1.2.7a 
because there an issue with statically linking was fixed.

Best regards,
Roberto Nibali, ratz
-- 
echo '[q]sa[ln0=aln256%Pln256/snlbx]sb3135071790101768542287578439snlbxq' | dc
