From: Patrick McHardy <kaber@trash.net>
Subject: Re: /proc/net/ip_conntrack trange behavior
Date: Wed, 29 Aug 2007 20:49:25 +0200
Message-ID: <46D5BFB5.6000206@trash.net>
References: <46CE8C05.5060202@nj.cpsecure.com>
	<200708290914.l7T9E934019648@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Dong_Wei@nj.cpsecure.com
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200708290914.l7T9E934019648@toshiba.co.jp>
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

Yasuyuki KOZAKAI wrote:
> From: Dong_Wei <Dong_Wei@nj.cpsecure.com>
> Date: Fri, 24 Aug 2007 15:43:01 +0800
> 
>> Hi, all
>> 	When I checked /proc/net/ip_conntrack in my Linux server, I found some 
>> strange tracks like the following:
>>
>> [normal case]
>> tcp      6 387113 ESTABLISHED src=219.135.189.40 dst=58.60.9.41
>> sport=2391 dport=443 src=58.60.9.41 dst=219.135.189.40 sport=443
>> dport=2391 [ASSURED] use=1
>>
>> [strange track]
>> tcp      6 377231 ESTABLISHED src=222.173.17.207 dst=219.135.189.11
>> sport=19691 dport=3815 [UNREPLIED] src=219.135.189.11 dst=222.173.17.207
>> sport=3815 dport=19691 use=1
>>
>> As we kown after SYN->SYN,ACK->ACK. TCP connection is in ESTABLISHED
>> state. and the ip_conntrack "see" the REPLY direction packet, I think
>> the conntrak should be ASSURED. not UNREPLIED.
>>
>> So, pls help me. My kernel version is 2.4.22
>>
>> Thanks in advance  :-)
>>
> 
> When only SYN and SYN/ACK are detected by ip_conntrack, the state of the
> connection is ESTABLISHED. Please note that 'ESTABLISHED' is not TCP state,
> but generic connection state.


Well, its TCP connection state. Whats probably happening is that you
have connection pickup enabled, in which case a single ACK can lead
to TCP ESTABLISHED state. It won't match "-m state --state ESTABLISHED"
though.
