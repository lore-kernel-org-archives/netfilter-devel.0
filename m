From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables performance under 2.6.0[-test9]
Date: Tue, 28 Oct 2003 09:30:36 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F9E292C.3020509@trash.net>
References: <3F9D4370.99795B87@fy.chalmers.se> <3F9D5E60.866B0B63@fy.chalmers.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Andy Polyakov <appro@fy.chalmers.se>
In-Reply-To: <3F9D5E60.866B0B63@fy.chalmers.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Can you please provide (pcap format) packet dumps of

a) the correct situation
b) broken situation

I would like to have a look at it. Please make sure to capture
with "-s 1500" so the packets are in the dump completly.

Thanks,
Patrick

Andy Polyakov wrote:

>>I tried to deploy 2.6.0[-test9] iptables to masquerade a private
>>interace. Strangely enough ip_conntrack.ko module seems to affect
>>performance of *some* TCP connections. ... I'm looking for
>>triggering factors...
>>    
>>
>
>Apparently it's not certain connections as wholes which are affected,
>but only some outgoing packets. Those packets corresponding to socket
>writes larger than MTU-40 [where 40 is size of TCP/IP header]... I fail
>to imagine how come, but here is how I can reproduce the problem with
>attached head.pl script:
>
>- 'lsmod' to make sure *no* iptables modules are loaded;
>- 'time ./head.pl some.host 2000' says that it takes a portion of
>elapsed second for script to complete;
>- modprobe ip_conntrack;
>- 'time ./head.pl some.host 2000' now says that it takes over 3(!)
>elapsed seconds to complete;
>
>If I reduce amount of \n's send in first socket write by passing value
>of 1460 or lower as the last command-line argument, the script completes
>instantly regardless if ip_conntrack is loaded or not. Therefore the
>conclusion about MTU-40... Cheers. A.
>
