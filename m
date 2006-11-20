From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: iptables 1.3.6 not using /etc/networks
Date: Mon, 20 Nov 2006 01:00:44 +0100
Message-ID: <4560F02C.4040905@netfilter.org>
References: <cd6061db0611111725q2822d96cg2272b44dc3e85d0b@mail.gmail.com>	<cd6061db0611111835u7d6ea889g56822e458e3e12f2@mail.gmail.com>	<20061112173312.GA2593@linuxace.com>
	<cd6061db0611181409i27ef1f68l49517bf56c45128b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Phil Oester <kernel@linuxace.com>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Laurence J. Lane" <ljlane@debian.org>
In-Reply-To: <cd6061db0611181409i27ef1f68l49517bf56c45128b@mail.gmail.com>
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

Laurence J. Lane wrote:
> On 11/12/06, Phil Oester <kernel@linuxace.com> wrote:
> 
>> Not sure offhand how we can satisfy both cases here, but I'd posit
>> that more people use x.x.x/24 than use foonet/x notation.
> 
> I have another bug report saying it breaks stuff from /etc/hosts too.
> 
> How about something like this? I assume valid IP characters are in the
> range of 0-9 and a dot. This will skip pad_cidr() if any characters
> outside of that range are encountered. Plain bad IP addresses are
> apparently validated elsewhere. Of course, I could be wrong about all
> of this.

Apparently /etc/host accepts entries composed of dots, e.g.

foo.machine     192.168.100.100

So this assumption can be OK as soon as nobody is using such notation.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
