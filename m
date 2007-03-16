From: Patrick McHardy <kaber@trash.net>
Subject: Re: patch: Port- and netscan detection for netfilter
Date: Fri, 16 Mar 2007 16:40:55 +0100
Message-ID: <45FABA87.4090601@trash.net>
References: <DF74C782E6463841A9BD332297758881121069@FHCLUSRV-EX.dcs.fh-heidelberg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: "Gladewitz, Robert (FH)" <Robert.Gladewitz@fh-heidelberg.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <DF74C782E6463841A9BD332297758881121069@FHCLUSRV-EX.dcs.fh-heidelberg.de>
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

Gladewitz, Robert (FH) wrote:
> in my Master-Theses I designed a new kernel- and netfilter module for
> detection of net- and portscans. Now, the module is tested on more then
> 10 different firewall-installations. It's working without any problems
> during the last 8 months.
> 
> Your can read the documentation on
> http://ipt-portnetscan.sourceforge.net/. There is also a possibility to
> download all versions of Kernel- and IpTables-Patches.
> 
> I would be pleased to see you integrated these patches into IpTables of
> your use.
> Looking forward to your answer

Please attach patches inline so they can be read in the mail client.

> +++ linux-2.6.20.2/Documentation/ipt_PORTNETSCAN.txt
> @@ -0,0 +1,389 @@
> +Allgemein Informationen zum Modul ipt_PORTNETSCAN

Luckily I speak german :)

But seriously, we already had different portscan-detection matches
submitted, but decided against merging them since its not clear
what the benefit of detecting scans is. It clearly doesn't improve
security since

- you can just scan slow enough not to be detected
- you don't need to scan to crack something

So all it offers is a bit of correlated information ("you were scanned
by ..."), that can also be extracted from log-files.
