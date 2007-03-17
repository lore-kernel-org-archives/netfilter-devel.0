From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: patch: Port- and netscan detection for netfilter
Date: Sat, 17 Mar 2007 01:37:35 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0703170135440.23117@yvahk01.tjqt.qr>
References: <DF74C782E6463841A9BD3322977588813532AA@FHCLUSRV-EX.dcs.fh-heidelberg.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
To: "Gladewitz, Robert (FH)" <Robert.Gladewitz@fh-heidelberg.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <DF74C782E6463841A9BD3322977588813532AA@FHCLUSRV-EX.dcs.fh-heidelberg.de>
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


On Mar 16 2007 23:17, Gladewitz, Robert (FH) wrote:
>
>The interesting is the additional functionality in this module. If a 
>host has identifying as portscan-source you can define a time for 
>matching the rules after the first identification. For example, you can 
>drop all packages for a time xxx from this host after identifying as 
>portscan-source. In this cast, the attackers can't find more 
>information about your network.

Now, again for the list, what can its timing code do better than, say,

  -A INPUT -m portnetscan -m recent --name evil --set;
  -A INPUT -m recent --evil --update --seconds xxx -j DROP;




Jan
-- 
