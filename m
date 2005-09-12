From: Patrick McHardy <kaber@trash.net>
Subject: Re: buffer overflow in ip_ct_{ftp,tftp,irc}
Date: Mon, 12 Sep 2005 10:49:18 +0200
Message-ID: <4325410E.5040700@trash.net>
References: <m2zmqoscc5.fsf@cerbere.dyndns.info>	<m2slwgsc4p.fsf@cerbere.dyndns.info>	<431F7B26.4040302@netfilter.org>	<431F7C38.50206@netfilter.org>
	<432213E5.4000200@trash.net> <43253FD7.9050107@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org,
	Samir Bellabes <sbellabes@mandriva.com>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <43253FD7.9050107@ufomechanic.net>
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

Amin Azez wrote:
> Patrick McHardy wrote:
>
>>I agree, I've applied this patch instead. Thanks.
> 
> Dumb question follows:
> 
> What has this patch been applied to?...
> 
> pom-ng?
> a git tree somewhere?
> and svn kernel tree somewhere?

My personal git tree. I usually push it to Dave every week
or so if it contains patches.
