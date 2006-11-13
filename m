From: Alexey Toptygin <alexeyt@freeshell.org>
Subject: Re: iptables 1.3.6 not using /etc/networks
Date: Mon, 13 Nov 2006 21:23:05 +0000 (UTC)
Message-ID: <Pine.NEB.4.64.0611132106200.26099@ukato.freeshell.org>
References: <cd6061db0611111725q2822d96cg2272b44dc3e85d0b@mail.gmail.com>
	<cd6061db0611111835u7d6ea889g56822e458e3e12f2@mail.gmail.com>
	<20061112173312.GA2593@linuxace.com>
	<Pine.NEB.4.64.0611121933050.20892@ukato.freeshell.org>
	<20061112194314.GA3542@linuxace.com>
	<Pine.NEB.4.64.0611130053020.6631@ukato.freeshell.org>
	<45581D66.2070009@rtij.nl>
	<Pine.NEB.4.64.0611131546380.26786@ukato.freeshell.org>
	<4558D3A4.4070204@rtij.nl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Martijn Lievaart <m@rtij.nl>
In-Reply-To: <4558D3A4.4070204@rtij.nl>
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

>> No, domains can't start with a digit. See RFC 1034:
>> 
>> ftp://ftp.rfc-editor.org/in-notes/rfc1034.txt
>> 
> Domains can and do start with a digit, see RFC1912 section 2.1. Think 
> 3com.com.

This is news to me, and isn't reflected in the current standard (which is 
still RFC 1034), but you are right that it's widely implemented. It seems 
wierd that the Host Requirements standard can override the DNS standard 
without the DNS standard being updated...

 			Alexey
