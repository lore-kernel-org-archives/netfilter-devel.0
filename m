From: Roberto Nibali <ratz@tac.ch>
Subject: Re: TCP window tracking patch status query for further design considerations
Date: Wed, 09 Oct 2002 15:20:57 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3DA42D39.5050403@tac.ch>
References: <Pine.LNX.4.33.0210090012060.24530-100000@blackhole.kfki.hu> <3DA35A8C.6040201@drugphish.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
   Netfilter-devel
 <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Roberto Nibali <ratz@drugphish.ch>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

>> You send too big packets with the DF bit set, but you block the
>> correspondig ICMP error messages (see the kernel log above) as well.
>  
> D'oh, apologies to the netfilter-devel list for this embarrassing posting.

I've just realized that the tests I did were done over a VPN link with an MTU of 
1200 :(. I've fixed my setup on the packet filter as follows:

ip link set dev eth0 mtu 1200 && ip route flush cache

I will now go back and delve into testing the TCP window tracking patch.

Regards,
Roberto Nibali, ratz
-- 
echo '[q]sa[ln0=aln256%Pln256/snlbx]sb3135071790101768542287578439snlbxq' | dc
