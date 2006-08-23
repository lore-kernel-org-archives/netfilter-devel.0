From: Jeho Park <jhpark-nf@kernelproject.org>
Subject: Re: status of nf-HIPAC integration ?
Date: Wed, 23 Aug 2006 16:50:54 +0900
Message-ID: <44EC08DE.2080107@kernelproject.org>
References: <20060821145720.GA749@ekonomika.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: mbellion@hipac.org, netfilter-devel@lists.netfilter.org,
	kulnet@kulnet.kuleuven.be
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Steven Van Acker <deepstar+NRpGDEuW@singularity.be>
In-Reply-To: <20060821145720.GA749@ekonomika.be>
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

hi steven


Steven Van Acker wrote:

>Hello,
>
>for some time now we have been using the nf-HIPAC patch in our firewalls' kernels
>and I'm glad to say it works nicely. Our firewalls still run 2.4.x kernels. Ever 
>since the introduction of x-tables in the 2.6.x branch, the nf-HIPAC patch no 
>longer applies.
>
>I found a patch at 
>http://www.kernelproject.org/people/jhpark/nf-hipac-0.9.1-to-linux-2.6.16.16.patch
>by Jeho-Park, which should allow me to compile 2.6.16.16 with nf-HIPAC. 
>
>Has anyone tried this patch ?
>
>  
>
yes, i applied that patch to the standard linux 2.6.16.16 ~ 2.6.16.18 
and 2.6.17.3
the patch include original nf-hipac patch v 0.9.2 and somewhat bit 
changes which as you know, stemed from x-tables

todays, i tested thputs with smartbits (nf-hipac vs iptables) in the 
kernel 2.6.17.3
result URL:
http://www.kernelproject.org/people/jhpark/fw_thput_test1.htm

the result looks somewhat ugly because thput result is much low.
but as you refer my result, you can compare thput of the iptables with 
that of the nf-hipac in the kernel 2.6.17.3

test variable is like this : rule number, packet size, ...

the patch include original nf-hipac patch v 0.9.2 and somewhat bit 
changes which as you know, stemed from x-tables

thanks

---
jeho park <jhpark-nf@kernelproject.org>

>I'm not sure what the future of nf-HIPAC is. I'd like it very much if the 
>mainstream kernel came with nf-HIPAC by default, but I see no indications that 
>anything is moving in that direction.
>
>Is nf-HIPAC still being worked on ?
>Is it still on the TODO-list to integrate nf-HIPAC into the mainstream kernel ?
>
>kind regards,
>-- Steven Van Acker
>
>  
>
