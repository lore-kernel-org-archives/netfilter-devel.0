From: "Jorge Bastos" <mysql.jorge@decimal.pt>
Subject: Re: [NETFILTER 00/03]: Netfilter fixes
Date: Fri, 26 Jan 2007 14:50:24 -0000
Message-ID: <029501c74159$633941a0$0301a8c0@hercules.decimalint.pt>
References: <20070125002156.1883.33845.sendpatchset@localhost.localdomain>
	<20070126.010819.92584803.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
To: "David Miller" <davem@davemloft.net>, <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

David,
I have kernel 2.6.20-rc6 and i can't make pptp connections, only 2.6.20-rc5 
with the patch patrick provided me.
In wich version did you apply this?

Jorge



----- Original Message ----- 
From: "David Miller" <davem@davemloft.net>
To: <kaber@trash.net>
Cc: <netfilter-devel@lists.netfilter.org>
Sent: Friday, January 26, 2007 9:08 AM
Subject: Re: [NETFILTER 00/03]: Netfilter fixes


> From: Patrick McHardy <kaber@trash.net>
> Date: Thu, 25 Jan 2007 01:21:56 +0100 (MET)
>
>> following are three netfilter fixes for 2.6.20, fixing a problem with 
>> ICMP
>> translation in the new nf_nat code and two bugs in the new PPTP helper 
>> port
>> breaking NAT of PPTP connections.
>>
>> Please apply, thanks.
>
> All applied, thanks a lot Patrick.
>
> 
