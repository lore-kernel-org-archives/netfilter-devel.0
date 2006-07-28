From: Maik Hentsche <maik@mm-double.de>
Subject: Re: bugreport ipt_CLUSTERIP
Date: Fri, 28 Jul 2006 11:25:51 +0200
Message-ID: <1154078751.44c9d81ff2c50@www.domainfactory-webmail.de>
References: <20060725082618.8zdzyrc36s0ksgsk@mail.tu-chemnitz.de>
	<44C8CB58.60709@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <44C8CB58.60709@trash.net>
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

Zitat von Patrick McHardy <kaber@trash.net>:

> Crash reports are better sent to mailing lists anyway

I'll keep that in mind.

> Are you sure this is caused by ipt_CLUSTERIP?

No, I'm not.

> What options did you use to trigger this?

iptables -D INPUT -i eth1 -d 172.20.251.25  -j CLUSTERIP --new
--hashmode sourceip-sourceport --clustermac 01:00:5e:12:34:56
--total-nodes 2 --local-node 2

The first time, I tried this to delete the appropiate rule, it directly
crashed. Unfortunatelly, I do not have the related Oops message, since
I thought it might occur again and wanted to log via serial console.
The second time, the already mentioned error occured, when I rebooted
my machine and unfortunatelly after I had plugged the serial cable off
:o(

> Did you apply any patches to your kernel?

No, plain vanilla kernel 2.6.17.3.

so long
Maik
