From: Pablo Neira <pablo@eurodev.net>
Subject: Re: iptables 1.3.1 MARK target
Date: Thu, 17 Mar 2005 23:13:38 +0100
Message-ID: <423A0112.2020900@eurodev.net>
References: <20050317165248.GB28102@ltsp> <4239FEE3.20700@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Graham Keeling <graham@equiinet.com>
In-Reply-To: <4239FEE3.20700@eurodev.net>
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
> Graham Keeling wrote:
> 
>> Hi,
>> I'm posting this in case you guys aren't aware of it...
>>
>> I'm using kernel 2.4.26.
>> I recently upgraded iptables from 1.2.8 to 1.3.1.
>> I found that the MARK target didn't work anymore.
>> I couldn't do --set-mark, --or-mark or --and-mark.
>> The error messages were;
>> --set-mark: invalid argument
>> --or-mark: kernel too old for --or-mark
>> --and-mark: kernel too old for --and-mark
> 
> 
> that's right since versioning stuff was pushed forward into kernel 
> mainline, now we can extend current matches and target ensuring backward 
> compatibility. If you want to use those parameters you must upgrade your 
> kernel.

wait a minute, I got what you meant. You are using MARK from 
patch-o-matic-ng and doesn't work anymore. So you are right, we need to 
port MARK-operations to the new versioning infrastructure, then it will 
work fine with iptables-1.3

--
Pablo
