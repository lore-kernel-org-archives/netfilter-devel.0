From: Dirk Morris <dmorris@metavize.com>
Subject: Re: -m physdev iptables: Invalid Argument
Date: Fri, 24 Oct 2003 17:02:31 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F99BD97.2080409@metavize.com>
References: <3F996BBA.5070106@metavize.com> <3F99B88D.1060000@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <3F99B88D.1060000@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

>
>
>> ~/ # sudo /sbin/iptables -m physdev -t mangle -A FORWARD --physdev-in 
>> eth0 -p udp --source 10.0.0.0/255.255.255.0  --destination-port 7:7 
>> -j DIVERT --to-port 20259
>> iptables: Invalid argument
>>
> Try to order the arguments properly then you will have no problems.
>
I give up.
Care to enlighen us?

~ # sudo  /sbin/iptables  -m physdev -t nat --physdev-in eth0 -A 
PREROUTING -p tcp --destination-port 7:7  -j REDIRECT --to-port 20257
iptables: Invalid argument
~ # sudo  /sbin/iptables  -m physdev -t nat -A PREROUTING --physdev-in 
eth0 -p tcp --destination-port 7:7  -j REDIRECT --to-port 20257
iptables: Invalid argument
~ # sudo  /sbin/iptables  -m physdev -t nat -A PREROUTING -p tcp 
--physdev-in eth0 --destination-port 7:7  -j REDIRECT --to-port 20257
iptables: Invalid argument
~ # sudo  /sbin/iptables  -m physdev -t nat -A PREROUTING -p tcp 
--destination-port 7:7 --physdev-in eth0 -j REDIRECT --to-port 20257
iptables: Invalid argument
~ # sudo  /sbin/iptables  -m physdev -t nat -A PREROUTING -p tcp 
--destination-port 7:7  -j REDIRECT --physdev-in eth0 --to-port 20257
iptables: Invalid argument
~ # sudo  /sbin/iptables  -m physdev -t nat -A PREROUTING -p tcp 
--destination-port 7:7  -j REDIRECT --to-port 20257 --physdev-in eth0
iptables: Invalid argument
