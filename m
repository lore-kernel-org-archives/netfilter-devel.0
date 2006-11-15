From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH][IPTABLES] userspace u32 match support
Date: Wed, 15 Nov 2006 13:53:13 +0100
Message-ID: <455B0DB9.4050901@netfilter.org>
References: <4553D66B.2010309@netfilter.org>
	<Pine.LNX.4.64.0611151010310.26451@bizon.gios.gov.pl>
	<455ADF71.5010503@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, Michael Rash <mbr@cipherdyne.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <455ADF71.5010503@trash.net>
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
> Krzysztof Oledzki wrote:
>> On Fri, 10 Nov 2006, Pablo Neira Ayuso wrote:
>>
>>> Add support for u32 match in userspace
>>
>> Thanks, but the original u32 match was much more powerful and allowed
>> for example to move to a next header (ip->tcp) using the @ operator and
>> generally to build more advanced test. As you used the same name (u32)
>> it will be no longer possible to use the old one.
> 
> Yes, this is a problem. Without beeing able to get at the TCP
> header or data it is of much less use.
> 
>> So, are there any plans to implement full power of the old u32 extension?
> 
> I agree, we should integrate the original version.

OK, I'll give another spin to this issue.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
