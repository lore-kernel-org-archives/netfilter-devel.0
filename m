From: Amin Azez <azez@ufomechanic.net>
Subject: Re: NF structural changes (was: dangerous?)
Date: Wed, 14 Mar 2007 22:29:01 +0000
Message-ID: <45F8772D.4070401@ufomechanic.net>
References: <Pine.LNX.4.61.0703142148430.1199@yvahk01.tjqt.qr>
	<45F8637D.3060600@trash.net>
	<Pine.LNX.4.61.0703142207180.1199@yvahk01.tjqt.qr>
	<45F870E3.6020805@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Jan Engelhardt <jengelh@linux01.gwdg.de>,
	Hendrik Nordstrom <henrik@henriknordstrom.net>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45F870E3.6020805@trash.net>
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

Patrick McHardy wrote:
> Jan Engelhardt wrote:
>   
>> Right. Of course this is a problem. To that end, I can really only say
>> that a divide needs to be made someday.
>>     
>
> I totally disagree. iptables has tons of problems, I'm guessing that
> a year from now we will have a successor. Breaking compatibility at
> this point in its lifetime is not acceptable, especially on such a
> fundamental level. 
quite likely we will come to that conclusion but our discussion might 
result in private patches that don't hit the kernel.
> I really wish people would stop wasteing time
> trying to redesign iptables, its just not worth it.
>   
maybe, but it looks so promising coming from a position of wasting time 
trying to work with it :-)
- and you know it's so much more fun to tweak someone elses work than 
start from scratch...

Sam
