From: Patrick McHardy <kaber@trash.net>
Subject: Re: Patch for CONFIG_IP_NF_NAT_LOCAL in 2.6.11 ?
Date: Thu, 10 Mar 2005 19:00:46 +0100
Message-ID: <42308B4E.3030303@trash.net>
References: <019201c52592$e181a4b0$0a00a8c0@alexandre>
	<42307E2A.5060806@trash.net>
	<019f01c52595$dd3a56b0$0a00a8c0@alexandre>
	<42308509.4040902@trash.net>
	<01cd01c5259a$89ab8dc0$0a00a8c0@alexandre>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Alexandre Chaves Fonseca <alex.f-linux@specialist.com.br>
In-Reply-To: <01cd01c5259a$89ab8dc0$0a00a8c0@alexandre>
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
> you say that I have to do this:
> 
> iptables -t nat -A OUTPUT -p tcp -s 127.0.0.1 -d 127.0.0.1 --dport 25 -j 
> DNAT --to 192.168.0.50:25
> iptables -t nat -A POSTROUTING -p tcp -s 127.0.0.1 -d 192.168.0.50 
> --dport 25 -j SNAT --to 192.168.0.10
> 
> (192.168.0.10 is my IP)
> 
> right ?
> 
> but it doesn't work yet...
> 
> what I am doing wrong ?

Check if the rules are used and what happens on the network ..

Regards
Patrick
