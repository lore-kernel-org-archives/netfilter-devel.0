From: Patrick McHardy <kaber@trash.net>
Subject: Re: ip_rt_bug in mangle/OUTPUT
Date: Wed, 06 Jun 2007 13:36:38 +0200
Message-ID: <46669C46.9000305@trash.net>
References: <4654AE59.3090506@cpsc.ucalgary.ca> <4655D083.8070309@trash.net>
	<4665C58A.6070401@cpsc.ucalgary.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Rennie deGraaf <degraaf@cpsc.ucalgary.ca>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4665C58A.6070401@cpsc.ucalgary.ca>
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

Rennie deGraaf wrote:
> Patrick McHardy wrote:
> 
>>If you don't need the rerouting to be happen (you only change the
>>source address and don't use routing rules based on that) you can
>>simply return NF_STOP instead of NF_ACCEPT. It will do exactly
>>the same thing but avoid rerouting.
> 
> 
> That solution worked well on recent kernels.  Unfortunately, my boss now
> wants my code to work on Linux 2.6.9, which doesn't appear to have
> NF_STOP.  (It seems to have been added in 2.6.12.)  Can you think of any
> other work-arounds, short of dropping the packets and re-injecting the
> modified versions through raw sockets?


No, old kernel version will even leak packets when you send unknown
return codes.
