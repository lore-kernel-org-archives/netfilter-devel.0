From: Patrick McHardy <kaber@trash.net>
Subject: Re: Patch for CONFIG_IP_NF_NAT_LOCAL in 2.6.11 ?
Date: Thu, 10 Mar 2005 18:34:01 +0100
Message-ID: <42308509.4040902@trash.net>
References: <019201c52592$e181a4b0$0a00a8c0@alexandre>
	<42307E2A.5060806@trash.net>
	<019f01c52595$dd3a56b0$0a00a8c0@alexandre>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Alexandre Chaves Fonseca <alex.f-linux@specialist.com.br>
In-Reply-To: <019f01c52595$dd3a56b0$0a00a8c0@alexandre>
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

Alexandre Chaves Fonseca wrote:
> This means that I have this ?!
> 
> Before (with kernel <= 2.6.10), I had the rule:
> 
> iptables -t nat -A OUTPUT -p tcp -s 127.0.0.1 -d 127.0.0.1 --dport 25 -j 
> DNAT --to 192.168.0.50:25
> 
> And now, with 2.6.11, the rule doesn't work... and syslog show:
> 
> NAT: no longer support implicit source local NAT
> NAT: packet src 192.168.0.50 -> dst 127.0.0.1

This means that NAT no longer fixes up the source address when
doing DNAT in LOCAL_OUT, so the packet goes out with 127.0.0.1
as source. You need to SNAT it manually if you want to get
the old behaviour.

Regards
Patrick
