From: Alexey Toptygin <alexeyt@freeshell.org>
Subject: Re: iptables 1.3.6 not using /etc/networks
Date: Mon, 13 Nov 2006 00:58:48 +0000 (UTC)
Message-ID: <Pine.NEB.4.64.0611130053020.6631@ukato.freeshell.org>
References: <cd6061db0611111725q2822d96cg2272b44dc3e85d0b@mail.gmail.com>
	<cd6061db0611111835u7d6ea889g56822e458e3e12f2@mail.gmail.com>
	<20061112173312.GA2593@linuxace.com>
	<Pine.NEB.4.64.0611121933050.20892@ukato.freeshell.org>
	<20061112194314.GA3542@linuxace.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: "Laurence J. Lane" <ljlane@debian.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20061112194314.GA3542@linuxace.com>
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

> On Sun, Nov 12, 2006 at 07:36:34PM +0000, Alexey Toptygin wrote:
>>> Not sure offhand how we can satisfy both cases here, but I'd posit
>>> that more people use x.x.x/24 than use foonet/x notation.
>>
>> Isn't it always true that foonet/y starts with a letter and x.x.x/y starts
>> with a digit? In this case, checking that the string starts with a digit
>> before searching it for '.' characters and appending '.0's should work.
>
> But if you use a FQDN such as www.domain.com/24, then shouldn't that
> then imply <ip of www.domain.com>/24?  That's why I didn't make the
> exception for letters vs. digits, as it could be used either way.

I don't understand what you mean. I think if it starts with a digit, it 
must be an IP (or part of an IP with 0's dropped), else it is a network 
name or a domain name (since neither of those can start with digits). If 
it's an IP by the above logic, then pad it with '.0's as necessary (or 
translate directly into a number without padding first). If it's not an 
IP, first call getnetbyname on it and if that returns NULL call 
gethostbyname. I think this algorithm works in all cases, unless I'm 
missing something.

 			Alexey
