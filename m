From: Pablo Neira <pablo@eurodev.net>
Subject: Re: kernel panic with ctnetlink/nfnetlink
Date: Thu, 16 Jun 2005 12:23:51 +0200
Message-ID: <42B15337.5070903@eurodev.net>
References: <20050615164034.GA15168@safetpin.homeunix.org>	<42B0BC21.3020004@eurodev.net>	<20050616010225.GA18652@safetpin.homeunix.org>
	<42B0D7A1.70508@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, pud@subnet666.de
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <42B0D7A1.70508@eurodev.net>
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

Pablo Neira wrote:
>> here the latest panic:
>>
>>
>> Unable to handle kernel NULL pointer dereference
> 
> 
> Please, decode this with ksymoops.

Sorry I meant, make sure you've set CONFIG_KALLSYMS in your custom 
kernel. This will help me and others to understand the matrix. Other 
things like CONFIG_FRAME_POINTER would help as well.

--
Pablo
