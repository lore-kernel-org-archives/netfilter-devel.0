From: Patrick Schaaf <bof@bof.de>
Subject: Re: Wrong count on bytes
Date: Sat, 19 Oct 2002 08:39:38 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021019063938.GA19783@oknodo.bof.de>
References: <003001c276ef$01c5b270$8432a8c0@mcpollo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Javier Martin <martin@trymedia.com>
Content-Disposition: inline
In-Reply-To: <003001c276ef$01c5b270$8432a8c0@mcpollo>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

>   Chain OUTPUT (policy ACCEPT 410429507 packets, 581914465274 bytes)
>   Chain OUTPUT (policy ACCEPT 410555345 packets, 582099636248 bytes)
> 
> I'm using the following rules:
> 
>   iptables -I INPUT -i eth0 --destination x.x.x.x
>   iptables -I OUTPUT -o eth0 --source x.x.x.x

Maybe you are using these rules, but you certainly are not showing their
counters in the two lines above. You are showing the chain defaults of
the OUTPUT chain, counting anything _not_ covered by terminating earlier
rules.

I'd guess that your chain defaults cover localhost communication and
other stuff besides that which you thing you want to measure.

best regards
  Patrick
