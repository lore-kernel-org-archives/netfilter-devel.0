From: Simon Lodal <simonl@parknet.dk>
Subject: Re: RFC: Partial IP4 syntax
Date: Wed, 29 Sep 2004 18:38:12 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <415AE4F4.2000903@parknet.dk>
References: <415A12AE.1060901@parknet.dk> <415A3263.7080708@xgendev.com>
	<415A4B4E.1080801@parknet.dk>
	<Pine.LNX.4.61.0409291051190.11661@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ben Efros <ben@xgendev.com>, Henrik Nordstrom <hno@marasystems.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <Pine.LNX.4.61.0409291051190.11661@filer.marasystems.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Henrik Nordstrom skrev:
> IETF has not defined such ascii representation of IPv4 addresses, but 
> the BSD libc inet_aton function does and this has been inherited by very 
> many systems and tools.
> 
> This notation is being depreated as it does not serve a very useful 
> purpose and can be somewhat confusing, but it exists and conflicting 
> with it would be a bad idea.
Ok, let's see where we may get compatibility problems:
1) iptables input: iptables' support for full 32bit format addresses is 
both lacking and undocumented and could disappear without notice. So if 
any programs use it they should rather be fixed.
2) iptables output: There is a potential problem here, if programs parse 
iptables or iptables-save output, and they know about the full 32bit form.

iptables -L is for human eyes while iptables-save is for machine 
parsing. So what if we make iptables -L print in any format it likes 
(not intended for machine parsing anyway), but have iptables-save always 
print addresses in full dotted quad?

>> If it is really a problem I agree my scheme will break it. Could 
>> probably be solved by changing the default to incomplete-at-beginning, 
>> so 10 = .10 = 0.0.0.10.
> 
> 
> Not without breaking existing "industry standards" on how IP numbers can 
> be typed.
Why? I certainly do not want to break anything, formalized or not, only 
extend.

> You could use 10. for the 10.0.0.0/8 network.
That is what I propose.

The question is how to interpret a single number. Implicitly append or 
prepend a dot? Or interpret as full 32bit notation? Or ignore it?


Simon
