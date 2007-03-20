From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: AW: AW: patch: Port- and netscan detection for netfilter
Date: Tue, 20 Mar 2007 17:30:30 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0703201724010.20032@yvahk01.tjqt.qr>
References: <DF74C782E6463841A9BD3322977588813532AB@FHCLUSRV-EX.dcs.fh-heidelberg.de>
	<45FE1894.3070506@trash.net>
	<DF74C782E6463841A9BD332297758881121071@FHCLUSRV-EX.dcs.fh-heidelberg.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: "Gladewitz, Robert (FH)" <Robert.Gladewitz@fh-heidelberg.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <DF74C782E6463841A9BD332297758881121071@FHCLUSRV-EX.dcs.fh-heidelberg.de>
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


On Mar 19 2007 14:12, Gladewitz, Robert (FH) wrote:
>
>This module is not designed for using as locally firewall, it is designed
>for router in networks with dmz.

Who said -m hashlimit/-m recent was limited to a local firewall?

>For all actions your can be sure, that a port- or netscan is be
>happening, not only less / many - port / hosts!! The module can be sure
>deside, that the many dest-port (for axamlpe) comes from this
>source-host!

Do yourself a favor: Add a rule -m hashlimit --hashlimit-mode srcip,dstip
to your router (not 'local firewall') and do a portscan. Watch the
iptables -nvL counters on that rule rise.

>Please read the documentation /and or source - it is completely different
>to all other modules. The Idea is, that your look for all connection,
>which are match by the rule - the state is totally uninteresting.

The state _is_ interesting. Because ESTABLISHED connections are, with the
exception of Connect and Grab scans [ct], always "good" ones, i.e. the
firewall cannot decide, with the exception of [l7] and [l7] is also more
like [l5], if traffic is good or evil.

>
>If a source-host is identified as a scan-host you can drop the all
>packages from dir source-ip for a defined time.

You fail to explain, given that we know a certain host is "evil", why -m
recent cannot be used to drop its evil packets.

>The interesting is also, that you can use it for DROP-Packet on the end
>of all rules also (In the documentation I have defined 2 sceneries). On
>the start of the rules, your have only a check-line - on the end of all
>rules, you test if the client have to much denied traffic - then you can
>drop all package up this time.

Your check line is equivalent to -m recent --rcheck/--update.

The one at the end of the rules is eqv. to -m recent --set.

>The next is, your can check the state of connections and DENY-Hosts in
>/proc/net/stat/portnetscan

(And ipt_recent has also its own proc file for listing denied/matched hosts)


>-----Ursprüngliche Nachricht-----
>Von: Patrick McHardy [mailto:kaber@trash.net] 
>Gesendet: Montag, 19. März 2007 05:59
>An: Gladewitz, Robert (FH)
>Cc: netfilter-devel@lists.netfilter.org
>Betreff: Re: AW: patch: Port- and netscan detection for netfilter
>
>Gladewitz, Robert (FH) wrote:
>> The problem is, on the most attacks, the hacker try to get some information on the network. This module implements 3 different situations:
>
>Putting aside the question of the usefulness of this, whats the
>difference to using the three rules below?
>
>> - Netscan (Scan more hosts on less ports)
>
>iptables -A PREROUTING -m state --state NEW \
>		       -m hashlimit --hashlimit-name netscan \
>				    --hashlimit-mode dstip \
>				    --hashlimit n/sec \
>		       -j DROP
>
>> - Portscan (Scan less Hosts and many ports)
>
>iptables -A PREROUTING -m state --state NEW \
>		       -m hashlimit --hashlimit-name portscan \
>				    --hashlimit-mode dstport \
>				    --hashlimit n/sec \
>		       -j DROP
>
>> - Combined Scan (Scan many Ports on many)
>
>iptables -A PREROUTING -m state --state NEW \
>		       -m hashlimit --hashlimit-name portnetscan \
>				    --hashlimit-mode dstip,dstport \
>				    --hashlimit n/sec \
>		       -j DROP
>
>
>

Jan
-- 
