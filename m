From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] info file for ROUTE target
Date: Tue, 14 Dec 2004 03:47:00 +0100
Message-ID: <41BE5424.40001@trash.net>
References: <1102603380.7528.98.camel@descartes.info.ucl.ac.be>
	<20041209195706.GA4121@oknodo.bof.de> <41B8EB72.50502@trash.net>
	<1102669404.11255.29.camel@descartes.info.ucl.ac.be>
	<20041210091445.GC4121@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "netfilter-devel@lists.netfilter.org"
	<netfilter-devel@lists.netfilter.org>,
	Cedric de Launois <delaunois@info.ucl.ac.be>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
In-Reply-To: <20041210091445.GC4121@oknodo.bof.de>
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

Patrick Schaaf wrote:

>>My fear is that you could still have something like this :
>>
>>          PC1                                    PC2
>>
>>      orig packet     
>>           |
>>           v                  dup pkt 1
>>   [ROUTE --tee --gw PC2] -------------------------.
>>         | |   ^                                   |
>>         | |   |                                   v
>>         | |   '-----dup pkt 2 ---------- [ROUTE --tee --gw PC1]
>>         | |                                      | |
>>         v v                                      v v
>> Flood of duplicated packets            Flood of duplicated packets
>>
>
>This is easily possible. There are lots of other failure scenarios.
>
>For example, when the chosen --gw resolves through our defaul route,
>chances are good all duplicate packets will come back to us almost
>immediately. We saw this in our testing, already. TTL should always
>be properly decremented, so this is a bit self-limiting, but
>nevertheless it's certainly a dangerous thing.
>
Seems ok to me, you can also add a route via loopback, it will loop until
the ttl expires. Fact is you can shoot yourself in the foot with some
setups. I've added your patch except the file iptables/extensions/xxx :)

Regards
Patrick
