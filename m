From: shobhan <shobhankumar-rc@naturesoft.net>
Subject: Re: iptables static linking
Date: Thu, 06 Mar 2003 16:45:34 +0530
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E672DD6.7060801@naturesoft.net>
References: <3E66E3DA.3000808@naturesoft.net> <3E672127.6000001@tac.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Roberto Nibali <ratz@tac.ch>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Roberto

Thanks, It worked for me

Shobhan
Roberto Nibali wrote:

> Hi,
>
>> I am trying to compile iptables code with out shared libraries.but it 
>> is hanging when i ran iptables.   Can we compile iptables without 
>> shared libraries
>
>
> Yes, it is possible and it also works. I recommend using at least 
> version 1.2.7a because there an issue with statically linking was fixed.
>
> Best regards,
> Roberto Nibali, ratz
