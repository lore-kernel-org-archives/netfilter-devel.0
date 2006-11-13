From: Alexey Toptygin <alexeyt@freeshell.org>
Subject: Re: iptables 1.3.6 not using /etc/networks
Date: Mon, 13 Nov 2006 15:50:35 +0000 (UTC)
Message-ID: <Pine.NEB.4.64.0611131546380.26786@ukato.freeshell.org>
References: <cd6061db0611111725q2822d96cg2272b44dc3e85d0b@mail.gmail.com>
	<cd6061db0611111835u7d6ea889g56822e458e3e12f2@mail.gmail.com>
	<20061112173312.GA2593@linuxace.com>
	<Pine.NEB.4.64.0611121933050.20892@ukato.freeshell.org>
	<20061112194314.GA3542@linuxace.com>
	<Pine.NEB.4.64.0611130053020.6631@ukato.freeshell.org>
	<45581D66.2070009@rtij.nl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Phil Oester <kernel@linuxace.com>, "Laurence J. Lane" <ljlane@debian.org>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Martijn Lievaart <m@rtij.nl>
In-Reply-To: <45581D66.2070009@rtij.nl>
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

On Mon, 13 Nov 2006, Martijn Lievaart wrote:

> Alexey Toptygin wrote:
>
>> I don't understand what you mean. I think if it starts with a digit, it 
>> must be an IP (or part of an IP with 0's dropped), else it is a network 
>> name or a domain name (since neither of those can start with digits). If 
>> it's an IP by the above logic, then pad it with '.0's as necessary (or 
>> translate directly into a number without padding first). If it's not an IP, 
>> first call getnetbyname on it and if that returns NULL call gethostbyname. 
>> I think this algorithm works in all cases, unless I'm missing something.
>
> Domains can legitimately start with digits. F.i. 9292ov.nl. However, checking 
> for a valid IP address (in all forms) should be trivial.

No, domains can't start with a digit. See RFC 1034:

ftp://ftp.rfc-editor.org/in-notes/rfc1034.txt

>From which I quote:

> <domain> ::= <subdomain> | " "
>
> <subdomain> ::= <label> | <subdomain> "." <label>
>
> <label> ::= <letter> [ [ <ldh-str> ] <let-dig> ]
>
> <ldh-str> ::= <let-dig-hyp> | <let-dig-hyp> <ldh-str>
>
> <let-dig-hyp> ::= <let-dig> | "-"
>
> <let-dig> ::= <letter> | <digit>
>
> <letter> ::= any one of the 52 alphabetic characters A through Z in
> upper case and a through z in lower case
>
> <digit> ::= any one of the ten digits 0 through 9

 			Alexey
