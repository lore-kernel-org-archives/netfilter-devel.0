From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [BK PATCH] Fix ip_conntrack_amanda data corruption bug that
 breaks amanda dumps
Date: Sat, 06 Nov 2004 02:53:46 +0100
Message-ID: <418C2EAA.7050507@eurodev.net>
References: <20041104121522.GA16547@merlin.emma.line.org>	<418A7B0B.7040803@trash.net>	<20041104231734.GA30029@merlin.emma.line.org>	<418AC0F2.7020508@trash.net>
	<418BE156.4020400@eurodev.net> <418BFC5C.20201@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Henrik Nordstrom <hno@marasystems.com>,
	netfilter-devel@lists.netfilter.org,
	linux-kernel@vger.kernel.org, linux-net@vger.kernel.org,
	"David S. Miller" <davem@redhat.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <418BFC5C.20201@trash.net>
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

> Pablo Neira wrote:
>
>> Patrick, what about this? this way we save a copy to a buffer for 
>> linear skbs.
>>
>> Signed-off-by: Pablo Neira Ayuso <pablo@eurodev.net>
>>
>> @@ -74,12 +75,17 @@
>>                  skb->len - dataoff, amanda_buffer);
>>     BUG_ON(amp == NULL);
>>     data = amp;
>> -    data_limit = amp + skb->len - dataoff;
>> -    *data_limit = '\0';
>>
>>     /* Search for the CONNECT string */
>> -    data = strstr(data, "CONNECT ");
>> -    if (!data)
>> +    while((data = memchr(data, 'C', skb->len - dataoff)) != NULL) {
>> +        if (strncmp(data, "CONNECT ", 8) == 0) {
>>  
>>
> What if the C is the last byte ? There are also more str* commands below
> that need a terminating 0-byte.


you both are right. Patrick's patch is the best way to fix this problem.

Pablo
