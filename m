From: Roberto Nibali <ratz@drugphish.ch>
Subject: Re: dropping support for ipfwadm/ipchains (Re: when IPVS into netfilter?)
Date: Fri, 23 May 2003 23:11:59 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3ECE8E9F.1090107@drugphish.ch>
References: <3EB44BE7.3070602@wanadoo.es> <3EBCE288.5020801@drugphish.ch> <3EBEACBC.2090202@wanadoo.es> <3EC9DC59.6010006@drugphish.ch> <20030523195201.GO3077@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Xose Vazquez Perez <xose@wanadoo.es>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Harald,

> So this would make something like 2*(iptables_included-ipchains_included).
> But then the question is whether we are talking about stable kernels or
> development kernels?

I'd say development, that's how I interprete that "formula" und the 
wording around it, so it would be 2.7 then. But this is entirely up to 
you guys.

> I think ipfwadm can be dropped safely, but ipchains will have to stay.

Good, I just wanted to establish if the part my previous patch was 
against is going to remain for the 2.6 timeline. This seems to be the 
case then.

>>The second one is, which makes the whole LVS code as non-intrusive as 
>>even possible. I think the netfilter community could live with two more 
>>ifdef-blocks, right? :)
>  
> We certainly don't mind.  However, having IPVS specific ifdefs in the
> mainline kernel while IPVS is outside the mainstream kernel sounds a bit
> odd to me.   I think in general this is discouraged...

:) Of course. The idea is to submit LVS in overviewable chunks to the 
respective kernel lieutnants. The patch I posted is actually the only 
part where we change anything of the existing kernel tree. The rest are 
new files (also thanks to the cool Kconfig).

I only wanted to ask if those two ifdef'd hooks would be acceptable for 
you guys without sending the whole ipvs patch. You can have a look at it 
for yourselves:

http://www.linux-vs.org/software/kernel-2.5/linux-2.5.69-ipvs-1.1.5.patch.gz

Thanks for you time and the positive answer. See you at OLS,
Roberto Nibali, ratz
-- 
echo '[q]sa[ln0=aln256%Pln256/snlbx]sb3135071790101768542287578439snlbxq'|dc
