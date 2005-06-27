From: "Andrew Hall" <temp02@bluereef.com.au>
Subject: Re: Iptables snapshot compile failure with 2.6.12 headers: - please
	disregard
Date: Mon, 27 Jun 2005 13:48:37 +1000
Message-ID: <07f301c57acb$19aaa250$5001010a@bluereef.local>
References: <008901c57ab9$e6946330$5001010a@bluereef.local>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="iso-8859-1";
	reply-type=response
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
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

> Presently it seems that the Iptables shapshot will fail to compile when 
> using 2.6.11+ headers.
>
> A little while ago I remember someone saying that they needed to comment 
> out a couple of lines in a particular kernel header file to get iptables 
> to compile properly, does anyone have the file and the two lines that 
> needed commenting out?
>
> Thanks,
>
> Andrew.
>

It's the ipsec patches that cause the failure, and Tom's patch fixes this so 
there's no longer a problem.

Thanks, 
