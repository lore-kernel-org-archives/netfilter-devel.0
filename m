From: Patrick McHardy <kaber@trash.net>
Subject: Re: -m physdev iptables: Invalid Argument
Date: Sat, 25 Oct 2003 01:41:01 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F99B88D.1060000@trash.net>
References: <3F996BBA.5070106@metavize.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Dirk Morris <dmorris@metavize.com>
In-Reply-To: <3F996BBA.5070106@metavize.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Dirk Morris wrote:

> ~/ # sudo /sbin/iptables -m physdev -t mangle -A FORWARD --physdev-in 
> eth0 -p udp --source 10.0.0.0/255.255.255.0  --destination-port 7:7 -j 
> DIVERT --to-port 20259
> iptables: Invalid argument
>
Try to order the arguments properly then you will have no problems.

Regards,
Patrick
