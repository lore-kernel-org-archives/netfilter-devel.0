From: Patrick McHardy <kaber@trash.net>
Subject: Re: 2.4.23 masquerading broken?
Date: Tue, 02 Dec 2003 18:25:22 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FCCCB02.5070203@trash.net>
References: <20031202165653.GJ615@gaast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Wilmer van der Gaast <lintux@lintux.cx>
In-Reply-To: <20031202165653.GJ615@gaast.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Wilmer van der Gaast wrote:

>For security reasons, I upgraded to 2.4.23 last night. Now, suddenly, IP
>masquerading seems to be broken. When I use SNAT instead of
>masquerading, everything works.
>
>Unfortunately, I think it's hard to reproduce the problem. Right after
>booting .23 for the first time, everything seemed to be okay. The
>problems started just an hour ago, after having the server running for
>fifteen hours without any problems.
>
>Unfortunately there's not much more information I can provide. I can
>attach my iptables/rule/route file and keep my machine running in case
>anyone needs/wants more information. For now I'll just stick with SNAT.
>It works good enough for me.
>  
>

Can you check the ringbuffer for error messages ? What happens
to the packets when masquerading fails ?

Best regards,
Patrick
