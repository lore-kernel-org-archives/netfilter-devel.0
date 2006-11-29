From: Amin Azez <azez@ufomechanic.net>
Subject: Re: iptables 1.3.6 not using /etc/networks
Date: Wed, 29 Nov 2006 14:09:06 +0000
Message-ID: <456D9482.30205@ufomechanic.net>
References: <cd6061db0611111725q2822d96cg2272b44dc3e85d0b@mail.gmail.com>	<cd6061db0611111835u7d6ea889g56822e458e3e12f2@mail.gmail.com>	<20061112173312.GA2593@linuxace.com>	<cd6061db0611181409i27ef1f68l49517bf56c45128b@mail.gmail.com>
	<4560F02C.4040905@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Phil Oester <kernel@linuxace.com>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <4560F02C.4040905@netfilter.org>
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

* Pablo Neira Ayuso wrote, On 20/11/06 00:00:
> Laurence J. Lane wrote:
>> On 11/12/06, Phil Oester <kernel@linuxace.com> wrote:
>>
>>> Not sure offhand how we can satisfy both cases here, but I'd posit
>>> that more people use x.x.x/24 than use foonet/x notation.
>> I have another bug report saying it breaks stuff from /etc/hosts too.
>>
>> How about something like this? I assume valid IP characters are in the
>> range of 0-9 and a dot. This will skip pad_cidr() if any characters
>> outside of that range are encountered. Plain bad IP addresses are
>> apparently validated elsewhere. Of course, I could be wrong about all
>> of this.
> 
> Apparently /etc/host accepts entries composed of dots, e.g.
> 
> foo.machine     192.168.100.100
> 
> So this assumption can be OK as soon as nobody is using such notation.

I do, so do lots of web developers I know; it helps them test websites
under  the correct domain.

Does the patch you suggested depend on this not being the case?

Sam
