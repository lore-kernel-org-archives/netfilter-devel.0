From: Patrick McHardy <kaber@trash.net>
Subject: Re: kernel BUG at kernel/sched.c:2833!
Date: Mon, 21 Nov 2005 18:05:19 +0100
Message-ID: <4381FE4F.2000107@trash.net>
References: <Pine.LNX.4.64.0511141033001.8729@bizon.gios.gov.pl>	<437882BE.6080705@eurodev.net>	<Pine.LNX.4.64.0511162216140.16387@bizon.gios.gov.pl>	<437BD093.3010905@eurodev.net>	<Pine.LNX.4.64.0511172250390.9911@bizon.gios.gov.pl>	<4381D8B3.1010100@eurodev.net>	<Pine.LNX.4.64.0511211541020.30476@bizon.gios.gov.pl>
	<4381DDCF.7090609@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <4381DDCF.7090609@eurodev.net>
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

Pablo Neira wrote:
> Krzysztof Oledzki wrote:
> 
>>>I can't reproduce that problem that you're reporting. I don't see how
>>>the ctnetlink code can trigger that at the moment :(
>>
>>What information should I provide to help tracking this bug?
> 
> Any extra patch applied to your vanilla kernel? architecture? whatever
> that can give me a clue on what's wrong. Send me such info in private if
> you want.

Please don't send information related to the bug in private if not
necessary, the initial bug report is public so other people might
be looking into it or notice that they are affected by the same
problem.
