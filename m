From: Jeho Park <jhpark-nf@kernelproject.org>
Subject: Re: status of nf-HIPAC integration ?
Date: Wed, 23 Aug 2006 23:03:20 +0900
Message-ID: <44EC6028.2080900@kernelproject.org>
References: <20060821145720.GA749@ekonomika.be>	<44EC08DE.2080107@kernelproject.org>
	<44EC3C13.5030506@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: mbellion@hipac.org, Steven Van Acker <deepstar+NRpGDEuW@singularity.be>,
	netfilter-devel@lists.netfilter.org, kulnet@kulnet.kuleuven.be
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <44EC3C13.5030506@trash.net>
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

Patrick McHardy wrote:

>Jeho Park wrote:
>  
>
>>todays, i tested thputs with smartbits (nf-hipac vs iptables) in the
>>kernel 2.6.17.3
>>result URL:
>>http://www.kernelproject.org/people/jhpark/fw_thput_test1.htm
>>
>>the result looks somewhat ugly because thput result is much low.
>>but as you refer my result, you can compare thput of the iptables with
>>that of the nf-hipac in the kernel 2.6.17.3
>>    
>>
>
>That indeed looks ugly (for iptables). How was the ruleset structured?
>Could you put it on your page please?
>
>
>
>
>  
>
i uploaded the scripts.



rule 1000 hipac script:
http://www.kernelproject.org/people/jhpark/fw_forward1000_hp


rule 1000 iptables script:
http://www.kernelproject.org/people/jhpark/fw_forward1000_ipt


rule 2000 hipac script:
http://www.kernelproject.org/people/jhpark/fw_forward2000_hp


rule 2000 iptables script: 
http://www.kernelproject.org/people/jhpark/fw_forward2000_ipt



and above all, i fixed some my mistake. the router was not zeon dual
core but pentium-4 2.4G


so i fixed the result document (
http://www.kernelproject.org/people/jhpark/fw_thput_test1.htm
) 



p.s: 


the commands,  ipt and hp, in the scripts above are somewhat
changed iptables and nf-hipac command.


because i want to access any firewall ruleset with its unique ID for
convience, so i modified netfilter,


hipac kernel code and their user commands (iptables, nf-hipac)




thanks 



--


jeho park <jhpark-nf@kernelproject.org>
