From: Amin Azez <azez@ufomechanic.net>
Subject: Re: BUG/CONFLICT conntrack with preroute/postroute mangle table
Date: Mon, 09 May 2005 14:48:35 +0100
Message-ID: <427F6A33.8090807@ufomechanic.net>
References: <42677180.60003@ufomechanic.net>	<42677732.1000905@ufomechanic.net>	<20050421180723.03CF.LARK@linux.net.cn>	<426788B0.4090908@eurodev.net>	<426CF5FC.6090409@ufomechanic.net>	<426D1C69.2060107@ufomechanic.net>	<426D1E35.4030605@ufomechanic.net>	<426E4442.5070800@ufomechanic.net>	<d5cue9$3qf$1@sea.gmane.org>
	<427A4457.7010509@eurodev.net> <427F456F.50407@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, 'Krisztian Kovacs' <hidden@sch.bme.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <427F456F.50407@ufomechanic.net>
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



Amin Azez wrote:
> iptables refers to some kernel-side and some user-side code.
> When you say "iptables<1.3.1" which are you talking about? User side? 
> (I've inherited use of 1.2.11 for historical reasons though I'm hoping 
> to change that)
> Is it a requirement to update to iptables 1.3.1 user space applications 
> to avoid other instances of this bug?
> 
> Does a patch for this "one liner" need submitting to the list as 
> Subject: [PATCH], to get signed off by anyone at all?
> What is the procedure to ensure that this fix reaches the kernel properly?

Ignore my senseless ramblings, I also see that you have submitted a 
wider patch addressing this problem.

Thanks

Amin
