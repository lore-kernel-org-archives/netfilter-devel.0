From: Patrick McHardy <kaber@trash.net>
Subject: Re: ip_conntrack_tcp problem on kernel 2.4.28 !!! INVALID ?
Date: Sat, 25 Dec 2004 15:11:10 +0100
Message-ID: <41CD74FE.3090202@trash.net>
References: <opsjkf9pg8or678w@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Rusty Russell <rusty@rustcorp.com.au>, netfilter-devel@lists.netfilter.org,
	linux-kernel@vger.kernel.org, Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel-owner@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Konsar <konsar@brod.pl>
In-Reply-To: <opsjkf9pg8or678w@localhost>
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

Konsar wrote:
> Hi !!!
> 
> I have patches kernel 2.4.28 + patch-o-matic-ng-20040621 with  
> iptables-1.2.11 on my router/NAT server.This islog from my server
 >
> [...]
>
> Dec 25 14:15:47 gizmo kernel: ip_conntrack_tcp: INVALID: invalid RST  
> (ignored) SRC=64.230.127.202 DST=22.22.22.22 LEN=40 TOS
> =0x00 PREC=0x00 TTL=111 ID=25587 PROTO=TCP SPT=46885 DPT=1804 SEQ=0  
> ACK=881916807 WINDOW=0 RES=0x00 ACK RST URGP=0
> janek.log lines 17-47/47 (END)
> 
> What is this and how close this log ? Where is problem ?

The problem is edonkey, you get all kinds of crap if you run
it or catch the IP of someone who did. Its about the biggest
sin for a network I've ever seen. The only funny part about
it are the crappy implementations, you just have to smile if
you see people do GUI refreshing in the UDP packet handler :)

Regards
Patrick

BTW: No need to CC tons of people for questions like these.
