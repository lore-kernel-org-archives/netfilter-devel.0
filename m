From: Alexey Toptygin <alexeyt@freeshell.org>
Subject: Re: iptables 1.3.6 not using /etc/networks
Date: Sun, 12 Nov 2006 19:36:34 +0000 (UTC)
Message-ID: <Pine.NEB.4.64.0611121933050.20892@ukato.freeshell.org>
References: <cd6061db0611111725q2822d96cg2272b44dc3e85d0b@mail.gmail.com>
	<cd6061db0611111835u7d6ea889g56822e458e3e12f2@mail.gmail.com>
	<20061112173312.GA2593@linuxace.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: "Laurence J. Lane" <ljlane@debian.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20061112173312.GA2593@linuxace.com>
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

On Sun, 12 Nov 2006, Phil Oester wrote:

> On Sat, Nov 11, 2006 at 09:35:08PM -0500, Laurence J. Lane wrote:
>> On 11/11/06, Laurence J. Lane <ljlane@debian.org> wrote:
>>
>>>  # strace -s 255 -o /tmp/bar iptables -v -A INPUT -s foonet/8 -j
>>> ACCEPT #1.3.6 [2]
>>>  iptables v1.3.6: host/network `foonet.0.0.0' not found
>>>  Try `iptables -h' or 'iptables --help' for more information.
>>
>> This looks like something with the pad_cidr() call in
>> parse_hostnetworkmask(). ltrace shows the code calling
>> getnetbyname("foonet.0.0.0")  instead of getentbyname("foonet").
>
> Correct.  This was added between 1.3.5 and 1.3.6 to more sanely
> handle CIDR notation.  See the commit:
>
> https://lists.netfilter.org/pipermail/netfilter-cvslog/2006-July/005122.html
>
> Not sure offhand how we can satisfy both cases here, but I'd posit
> that more people use x.x.x/24 than use foonet/x notation.

Isn't it always true that foonet/y starts with a letter and x.x.x/y starts 
with a digit? In this case, checking that the string starts with a digit 
before searching it for '.' characters and appending '.0's should work.

 			Alexey
