From: Dirk Morris <dmorris@metavize.com>
Subject: Re: -m physdev iptables: Invalid Argument
Date: Fri, 24 Oct 2003 17:26:40 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F99C340.2070202@metavize.com>
References: <3F996BBA.5070106@metavize.com> <3F99B88D.1060000@trash.net> <3F99BD97.2080409@metavize.com> <3F99BFDA.6030506@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <3F99BFDA.6030506@trash.net>
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

>> ~ # sudo  /sbin/iptables  -m physdev -t nat --physdev-in eth0 -A 
>> PREROUTING -p tcp --destination-port 7:7  -j REDIRECT --to-port 20257
>> iptables: Invalid argument
>
> -m phydev --phsydev-in eth0

I assume you mean "-m physdev"

~ # sudo  /sbin/iptables  -m physdev --physdev-in eth0 -t nat -A 
PREROUTING -p tcp --destination-port 7:7  -j REDIRECT --to-port 
20257                                               
iptables: Invalid argument

Could you please just state the command you are using in a clear manner?
(and a uname -a)

Thanks
