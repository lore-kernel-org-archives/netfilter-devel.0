From: Dirk Morris <dmorris@metavize.com>
Subject: Re: -m physdev iptables: Invalid Argument
Date: Fri, 24 Oct 2003 18:01:55 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F99CB83.1020405@metavize.com>
References: <3F996BBA.5070106@metavize.com> <3F99B88D.1060000@trash.net> <3F99BD97.2080409@metavize.com> <3F99BFDA.6030506@trash.net> <3F99C340.2070202@metavize.com> <3F99C692.90703@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <3F99C692.90703@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Patrick McHardy wrote:

>>
>>
>> ~ # sudo  /sbin/iptables  -m physdev --physdev-in eth0 -t nat -A 
>> PREROUTING -p tcp --destination-port 7:7  -j REDIRECT --to-port 
>> 20257                                               iptables: Invalid 
>> argument
>>
>> Could you please just state the command you are using in a clear manner?
>> (and a uname -a)
>>
>
> Yes I do. Just give the proper arguments to matches without òther
> stuff in between (which means physdev arg to phydev match,
> destination-port arg to tcp/udp protocol match, --to-port
> arg to REDIRECT) and try again. If that doesn't work, try to find
> out which of the matches doesn't work and if reordering
> of matches+their arguments helps (I've seen matches only working
> if they were last in command line).
>
~/iptables-1.2.9rc1 # ./iptables 
--version                                                         
iptables v1.2.9rc1
~/iptables-1.2.9rc1 # uname 
-a                                                                     
Linux timmy 2.6.0-test8 #2 Wed Oct 22 15:14:09 PDT 2003 i686 GNU/Linux

I don't know what else to try at this point.

~/iptables-1.2.9rc1 # sudo ./iptables -t nat -A PREROUTING -m physdev 
--physdev-in eth0 -j REJECT
iptables: Invalid argument
~/iptables-1.2.9rc1 # sudo ./iptables -t nat -A PREROUTING -j REJECT -m 
physdev --physdev-in eth0
iptables: Invalid argument

At this point, If it actually does work and is just this this hard to 
use, I would consider it an interface bug.
Either way, after a quick google, its too hard for other people to get 
working also.

But as far as i can tell its not a parsing bug, but iptc_append_entry 
returns -1.
