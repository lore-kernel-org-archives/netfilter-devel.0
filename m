From: Martijn Lievaart <netfilter-devel@rtij.nl>
Subject: Re: suggestion, p-o-m, iplimit for ipv6 protocol
Date: Wed, 30 Apr 2003 22:31:08 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3EB0328C.4030305@rtij.nl>
References: <Pine.LNX.4.33.0304301249220.3330-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Tom Marshall <tommy@home.tig-grr.com>,
  netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.33.0304301249220.3330-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Jozsef Kadlecsik wrote:

>On Tue, 29 Apr 2003, Tom Marshall wrote:
>  
>
>>Sorry for a perhaps naive question, but why is there no IPv6 conntrack?
>>    
>>
>
>A blind porting of the IPv4 conntrack is unacceptable due to the code
>duplication.
>
>A blind union with IPv4 conntrack is unacceptable due to the sheer wasting
>of memory.
>
>An intelligent unification of IPv4/6 conntrack is possible. That itself is
>not so easy and one should keep in mind the relation with NAT, which
>makes it at the end complicated and hard.
>
>
>  
>
I understand, but for myself am willing to pay the price of a blind 
port. Has anyone done work in that direction?

TIA,
Martijn Lievaast
