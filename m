From: Dong_Wei <Dong_Wei@nj.cpsecure.com>
Subject: Re: /proc/net/ip_conntrack trange behavior
Date: Thu, 30 Aug 2007 09:14:56 +0800
Message-ID: <46D61A10.6010405@nj.cpsecure.com>
References: <46CE8C05.5060202@nj.cpsecure.com>
	<200708290914.l7T9E934019648@toshiba.co.jp>
	<46D5BFB5.6000206@trash.net>
Reply-To: Dong_Wei@nj.cpsecure.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46D5BFB5.6000206@trash.net>
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

Thanks a lot. Yasuyuki and kaber

I have looked the 2.6.20 kernel and found that the reason.

When ip_conntrack try to pick up an ESTABLISHED TCP connection, this 
issue will happen.

2.6 set an 'sysctl' value to deal with this situation

static int tcp_new()
{
	...snip...
          if (new_state == TCP_CONNTRACK_SYN_SENT) {
		do_something();
          } else if (ip_ct_tcp_loose == 0) {
                  /* Don't try to pick up connections. */
                  return 0;
          } else {
		do_something();
          }
}

And we can't avoid this issue on 2.4, because no code deal with the 
special case.

Thanks!

> Yasuyuki KOZAKAI wrote:
>> From: Dong_Wei <Dong_Wei@nj.cpsecure.com>
>> Date: Fri, 24 Aug 2007 15:43:01 +0800
>>
>>> Hi, all
>>>     When I checked /proc/net/ip_conntrack in my Linux server, I found 
>>> some strange tracks like the following:
>>>
>>> [normal case]
>>> tcp      6 387113 ESTABLISHED src=219.135.189.40 dst=58.60.9.41
>>> sport=2391 dport=443 src=58.60.9.41 dst=219.135.189.40 sport=443
>>> dport=2391 [ASSURED] use=1
>>>
>>> [strange track]
>>> tcp      6 377231 ESTABLISHED src=222.173.17.207 dst=219.135.189.11
>>> sport=19691 dport=3815 [UNREPLIED] src=219.135.189.11 dst=222.173.17.207
>>> sport=3815 dport=19691 use=1
>>>
>>> As we kown after SYN->SYN,ACK->ACK. TCP connection is in ESTABLISHED
>>> state. and the ip_conntrack "see" the REPLY direction packet, I think
>>> the conntrak should be ASSURED. not UNREPLIED.
>>>
>>> So, pls help me. My kernel version is 2.4.22
>>>
>>> Thanks in advance  :-)
>>>
>>
>> When only SYN and SYN/ACK are detected by ip_conntrack, the state of the
>> connection is ESTABLISHED. Please note that 'ESTABLISHED' is not TCP 
>> state,
>> but generic connection state.
> 
> 
> Well, its TCP connection state. Whats probably happening is that you
> have connection pickup enabled, in which case a single ACK can lead
> to TCP ESTABLISHED state. It won't match "-m state --state ESTABLISHED"
> though.
> 
