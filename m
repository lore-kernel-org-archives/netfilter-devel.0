From: Patrick McHardy <kaber@trash.net>
Subject: Re: bugreport ipt_CLUSTERIP
Date: Sat, 29 Jul 2006 03:49:48 +0200
Message-ID: <44CABEBC.9050101@trash.net>
References: <20060725082618.8zdzyrc36s0ksgsk@mail.tu-chemnitz.de>	<44C8CB58.60709@trash.net>
	<1154078751.44c9d81ff2c50@www.domainfactory-webmail.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Maik Hentsche <maik@mm-double.de>
In-Reply-To: <1154078751.44c9d81ff2c50@www.domainfactory-webmail.de>
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

Maik Hentsche wrote:
> Zitat von Patrick McHardy <kaber@trash.net>:
> 
>>What options did you use to trigger this?
> 
> 
> iptables -D INPUT -i eth1 -d 172.20.251.25  -j CLUSTERIP --new
> --hashmode sourceip-sourceport --clustermac 01:00:5e:12:34:56
> --total-nodes 2 --local-node 2
> 
> The first time, I tried this to delete the appropiate rule, it directly
> crashed. Unfortunatelly, I do not have the related Oops message, since
> I thought it might occur again and wanted to log via serial console.
> The second time, the already mentioned error occured, when I rebooted
> my machine and unfortunatelly after I had plugged the serial cable off
> :o(


I tried to reproduce this (by first adding your rule, then deleting it,
adding it again, rebooting), but got no crash. CLUSTERIP keeps global
state, so it might be that some previous actions using it contributed
to the crash, although its strange that it crashed in ip_tables, not
in CLUSTERIP itself. Did you added/deleted/flushed/... any CLUSTERIP
rules before the crashes? If you can find a way to reproducibly cause
the crash it would help a lot.
