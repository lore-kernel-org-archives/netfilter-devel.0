From: Jonas Berlin <jberlin@niksula.hut.fi>
Subject: Re: Multiple Targets
Date: Sat, 19 Feb 2005 19:21:36 +0200
Message-ID: <421775A0.3040902@niksula.hut.fi>
References: <7174b1e405021900052b4545c4@mail.gmail.com>	<20050219082851.GA18228@oknodo.bof.de>
	<1589344960.20050219102331@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Maciej Soltysiak <solt@dns.toxicfilms.tv>
In-Reply-To: <1589344960.20050219102331@dns.toxicfilms.tv>
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

Maciej Soltysiak wrote:

>Hello Patrick,
>
>Saturday, February 19, 2005, 9:28:51 AM, you wrote:
>  
>
>>Problem: target options. How would the commandline parser see that
>>--set-mark belongs to MARK, and --log-prefix belongs to LOG? What
>>about the hypothetical case of several targets having target options
>>with identical names?
>>    
>>
Isn't it possible to have multiple matchers also? How are the arguments 
to them separated?

>This is all very interesting.
>But do we want this because we want just better looking rulesets or
>have it optimized in sense of matchinge the packets?
>  
>
If the latter, how about having a match target instead that matches if 
the previous one matched?

i.e.

>iptables -A INPUT -p tcp --dport 53 -j LOG --log-prefix "foo: "
>iptables -A INPUT -p tcp --dport 53 -j MARK --set-mark 1
>iptables -A INPUT -p tcp --dport 53 -j ACCEPT
>  
>
would instead be written:

iptables -A INPUT -p tcp --dport 53 -j LOG --log-prefix "foo: "
iptables -A INPUT -m previous -j MARK --set-mark 1
iptables -A INPUT -m previous -j ACCEPT

This would be quite easy to implement, not break any binary interface 
and my guess is it wouldn't be too slow either.

That said, I could maybe look into coding it if there is no better idea 
and nobody think it's an immensely stupid idea :)

>iptables reads these 3 rules but creates one complex rule for that in
>kernel-space that would read:
>match tcp dport 53 packets on INPUT and do
>1) LOG --log-prefix "foo: "
>2) MARK --set-mark 1
>3) ACCEPT
>  
>
Another idea I just got would be like

iptables -A INPUT -p tcp --dport 53 -j IF_NOT_MATCH_SKIP --skip 3
iptables -j LOG --log-prefix "foo: "
iptables -j MARK --set-mark 1
iptables -j ACCEPT

i.e. if it matches it didn't match, it would skip the following three 
rules. This might be a bit intrusive to implement though, I'm not sure. 
It would be a little less space-effective, maybe aesthetically or 
logically less pleasing, but faster to process, if my previous 
suggestion would be too slow :)

These might not be the best options, but at least they are options :)

-- 
- xkr47
