From: Duncan Roe <duncan_roe@optusnet.com.au>
Subject: Re: [PATCH v2] extensions: libxt_hashlimit: Do not print default
 timeout and burst
Date: Sat, 20 Jan 2018 17:11:18 +1100
Message-ID: <20180120061118.GB4210@dimstar.local.net>
References: <20180102224746.GB3309@dimstar.local.net>
 <20180115014532.GA13839@dimstar.local.net>
 <20180116011537.b4xm2mxlabn5tsfl@salvia>
 <20180116124143.5s6exg3467ozmobb@salvia>
 <20180116204554.GA27044@dimstar.local.net>
 <20180116215217.GA27232@dimstar.local.net>
 <20180116223930.ftuagn4vtkvd2nka@salvia>
 <20180119014815.GA4882@dimstar.local.net>
 <20180119022722.duu5l3esazkox43z@salvia>
 <20180119022757.z5ir6zcytaabqntc@salvia>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="y0ulUmNC+osPPQO6"
Cc: Netfilter Development <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:43289 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750917AbeATGLd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 20 Jan 2018 01:11:33 -0500
Received: from dimstar.local.net (c220-239-53-24.eburwd6.vic.optusnet.com.au [220.239.53.24])
        by mail110.syd.optusnet.com.au (Postfix) with SMTP id 5858F1077A6
        for <netfilter-devel@vger.kernel.org>; Sat, 20 Jan 2018 17:11:19 +1100 (AEDT)
Content-Disposition: inline
In-Reply-To: <20180119022757.z5ir6zcytaabqntc@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 19, 2018 at 03:27:57AM +0100, Pablo Neira Ayuso wrote:
> On Fri, Jan 19, 2018 at 12:48:15PM +1100, Duncan Roe wrote:
> > On Tue, Jan 16, 2018 at 11:39:30PM +0100, Pablo Neira Ayuso wrote:
> > > On Wed, Jan 17, 2018 at 08:52:17AM +1100, Duncan Roe wrote:
> > > > On Wed, Jan 17, 2018 at 07:45:54AM +1100, Duncan Roe wrote:
> > > > > On Tue, Jan 16, 2018 at 01:41:43PM +0100, Pablo Neira Ayuso wrote:
> > > > > > On Tue, Jan 16, 2018 at 02:15:37AM +0100, Pablo Neira Ayuso wrote:
> > > > > > > On Mon, Jan 15, 2018 at 12:45:32PM +1100, Duncan Roe WROTE:
> > > > > > > [...]
>
> Another alternative is:
>
> # iptables-restore-translate -f your_iptables_ruleset
>
> Hm, this is not documented in the wiki for some reason.

Yes it is - section "Moving from iptables to nftables" under "Basic operation".
>
Although I now use nft (script attached), I just realised that since libvirt
sets up iptables rules, I could demo iptables-restore-translate working on them.

> iptables-save > save.txt
> iptables-restore-translate -f save.txt
all looked good *except*
> # -t mangle -A POSTROUTING -o virbr0 -p udp -m udp --dport 68 -j CHECKSUM --checksum-fill
Just for fun, I thought I'd see what iptables-compat did with that:
> iptables-compat -t mangle -A POSTROUTING -o virbr0 -p udp -m udp --dport 68 -j CHECKSUM --checksum-fill
There was no error message and iptables-compat returned 0. But now:
> iptables-compat -t mangle -L
> ERROR: You're using nft features that cannot be mapped to iptables, please keep using nft.
and:
> nft list ruleset
> Segmentation fault (core dumped)

Where to next?

Cheers ... Duncan.

--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="rc.nftable_filter"

#!/usr/sbin/nft -f
flush ruleset

# filter table (Firewall function)
# ====== ===== ========= =========

table ip IP \
{
  set TCP_DROP \
  {
    type inet_service
    elements = { 37, 111, 6000 }
  }                                ;# set PROTO
  set UDP_DROP \
  {
    type inet_service
    elements = { 37, 137, 138, 512 }
  }                                ;# set PROTO
  set TCP_ACCEPT { type inet_service; flags interval; }

  # A chain to inspect incoming (to this box) packets from cable modem

  chain FILTER_INPUT \
  {
    type filter hook input priority 0; policy accept;
    iif ne "wlan0" accept

    # Allow icmp but not too many
    # (only limit pings and other info requests)
    # N.B. This has to come before allowing related packets
    icmp type { echo-request, timestamp-request, info-request } \
      limit rate 5/second counter accept

    # Drop the excess
    icmp type { echo-request, timestamp-request, info-request } counter drop

    # All other icmp is OK
    meta l4proto icmp counter accept

    # Allow established and related pkts
    ct state established,related counter accept

    # Drop connection attempts to ports we want to keep private
    # (because we allow connections from some source ports)(?)
    # (i.e. drop these w/out logging)
    tcp dport @TCP_DROP counter drop
    udp dport @UDP_DROP counter drop

    # Allow bootps->bootpc udp
    # (i.e. allow dhcp requests / responses)
    udp sport . udp dport { 67 . 68 } counter accept

    # Allow DNS replies
    udp sport 53 counter accept

    # Allow server ports
    tcp dport @TCP_ACCEPT counter accept

    # bittorrent UDP uses port 1900 at both ends (not in /etc/service)
    udp sport . udp dport { 1900 . 1900 } counter accept

    # Drop everything else, logging interesting ones (tcp SYN mainly)
    counter jump logdrop
  }                                ;# chain FILTER_INPUT

  chain logdrop \
  {
    meta pkttype { broadcast } counter drop
    tcp flags & fin == fin counter drop
    counter log prefix "nft: " level debug drop
  }                                ;# chain logdrop
}                                  ;# table ip IP
list ruleset

--y0ulUmNC+osPPQO6--
