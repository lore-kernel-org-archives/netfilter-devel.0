From: "Benton Pena" <bpena@centennialrd.com.do>
Subject: Fw: Kernel panic: Aiee, killing interrupt handler!
Date: Mon, 7 Oct 2002 11:36:08 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <004701c26e17$41add650$e8f412ac@centennialrd.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


----- Original Message -----
From: "Benton Pena" <bpena@centennialrd.com.do>
To: <shorewall-users@shorewall.net>
Sent: Monday, October 07, 2002 10:52 AM
Subject: Fw: Kernel panic: Aiee, killing interrupt handler!


>
> Hi, all
>
> I just installed shorewall ver. 1.3.9a on a:
>
> mobile:~ # uname -a
> Linux mobile 2.4.14 #1 Mon Nov 12 11:25:00 GMT 2001 sparc64 unknown
>
> when i try to ssh to it i get from the console:
>
> Kernel panic: Aiee, killing interrupt handler!
> In interrupt handler - not syncing
>
> after this, the server hang up and do not get any logs about what
happened.
> if anyone have seen this, please help.
>
> shorewall is configured to firewall this only host:
>
> interfaces file:
> #ZONE    INTERFACE      BROADCAST       OPTIONS
> net     eth0            detect          noping,norfc1918,routefilter
>
> the policy file:
> #SOURCE         DEST            POLICY          LOG LEVEL
LIMIT:BURST
> fw              net             DROP            info
> net             fw              DROP            info
> all             all             REJECT          info
>
> the rules file:
>
############################################################################
> ##
> #ACTION  SOURCE         DEST            PROTO   DEST    SOURCE
ORIGINAL
> #                                               PORT    PORT(S)    DEST
>
> #SSH administration depend on hosts.allow
> ACCEPT  net             fw              tcp     ssh
>
> #request from host
> ACCEPT  fw              net             tcp     domain,ssh,80,443,25,110
> ACCEPT  fw              net             udp     domain,ntp,110
> ACCEPT  fw              net             icmp    8
>
>  #mysql
> ACCEPT  net             fw              tcp     3306
> ACCEPT  net             fw              udp     3306
>
> #www
> ACCEPT  net             fw              tcp     80
> ACCEPT  net             fw              udp     80
> ACCEPT  net             fw              tcp     443
> ACCEPT  net             fw              udp     443
> #smtp
> ACCEPT  net             fw              tcp     25
>
> #pop3
> ACCEPT  net             fw              tcp     110
> ACCEPT  net             fw              udp     110
>
> #ftp
> ACCEPT  net             fw              tcp     21
>
> Benton Pena
> (809) 444-8027
>
>
