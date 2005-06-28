From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH 1/2] updates for [nf|ct]netlink and event API
Date: Tue, 28 Jun 2005 04:15:43 +0200
Message-ID: <42C0B2CF.6000508@eurodev.net>
References: <42C03F2E.30706@eurodev.net>	<20050627202621.GY19928@sunbeam.de.gnumonks.org>
	<42C0AF26.1040705@eurodev.net> <42C0B1FA.4040500@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@netfilter.org>
In-Reply-To: <42C0B1FA.4040500@netfilter.org>
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
> Pablo Neira wrote:
> 
>> Harald Welte wrote:
>>
>>> I don't understand why the order of the expectation list was changed,
>>> though.  Would you please explain why this was done?
>>
>>
>>
>> Because of the table dumping logic I was using.
>>
>> -                       if (ct->id <= *id)
>> +                       if (ct->id >= *id)
>>                                 continue;
> 
> 
> Please ignore the patches I've sent you.

Damn, I'm tired, wrong patch again :(. Ignore it, I'll send a new digest 
that applies to SVN tomorrow morning.

--
Pablo
