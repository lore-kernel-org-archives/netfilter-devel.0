From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables CLASSIFY and MARK not working?
Date: Thu, 01 Jun 2006 20:22:39 +0200
Message-ID: <447F306F.3080708@trash.net>
References: <0633E0EDB4F25F43A2D7179CA11FAFAB255414@xavier.staff.greatlakes.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: lartc@mailman.ds9a.nl,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <lartc-bounces@mailman.ds9a.nl>
To: "Eliot, Wireless and Server Administrator,  Great Lakes Internet" <support8@greatlakes.net>
In-Reply-To: <0633E0EDB4F25F43A2D7179CA11FAFAB255414@xavier.staff.greatlakes.net>
List-Unsubscribe: <http://mailman.ds9a.nl/cgi-bin/mailman/listinfo/lartc>,
	<mailto:lartc-request@mailman.ds9a.nl?subject=unsubscribe>
List-Archive: <http://mailman.ds9a.nl/pipermail/lartc>
List-Post: <mailto:lartc@mailman.ds9a.nl>
List-Help: <mailto:lartc-request@mailman.ds9a.nl?subject=help>
List-Subscribe: <http://mailman.ds9a.nl/cgi-bin/mailman/listinfo/lartc>,
	<mailto:lartc-request@mailman.ds9a.nl?subject=subscribe>
Sender: lartc-bounces@mailman.ds9a.nl
Errors-To: lartc-bounces@mailman.ds9a.nl
List-Id: netfilter-devel.vger.kernel.org

Eliot, Wireless and Server Administrator, Great Lakes Internet wrote:
> However, this still does not work:
> 
> Chain POSTROUTING (policy ACCEPT 812K packets, 441M bytes)
>  pkts bytes target     prot opt in     out     source
> destination
>  2071  129K CLASSIFY   all  --  *      br1     0.0.0.0/0
> 0.0.0.0/0           MARK match 0x1fe CLASSIFY set 1c7:0
>     2   521 CLASSIFY   all  --  *      br1     0.0.0.0/0
> 0.0.0.0/0           MARK match 0x1ff CLASSIFY set 1c8:0
>     0     0 CLASSIFY   all  --  *      br1     0.0.0.0/0
> 0.0.0.0/0           MARK match 0x200 CLASSIFY set 1c9:0
>  2760 4060K CLASSIFY   all  --  *      wivl4   0.0.0.0/0
> 0.0.0.0/0           MARK match 0x1fe CLASSIFY set 1db:0
>     3   500 CLASSIFY   all  --  *      wivl4   0.0.0.0/0
> 0.0.0.0/0           MARK match 0x1ff CLASSIFY set 1dc:0
>     0     0 CLASSIFY   all  --  *      wivl4   0.0.0.0/0
> 0.0.0.0/0           MARK match 0x200 CLASSIFY set 1dd:0
> 
> 
> wireless-r1 bwlimit # tc -s qdisc show dev wivl4
> qdisc hfsc 5: default 2
>  Sent 8554815 bytes 7797 pkt (dropped 6, overlimits 13 requeues 0)
>  rate 0bit 0pps backlog 0b 0p requeues 0
> qdisc sfq 1db: parent 5:1fe limit 128p quantum 1514b
>  Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
>  rate 0bit 0pps backlog 0b 0p requeues 0
> qdisc sfq 1dc: parent 5:1ff limit 128p quantum 1514b
>  Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
>  rate 0bit 0pps backlog 0b 0p requeues 0
> qdisc sfq 1dd: parent 5:200 limit 128p quantum 1514b
>  Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
>  rate 0bit 0pps backlog 0b 0p requeues 0


I already told you why this doesn't work, you have to classify to
the _classes_, not the qdiscs.
