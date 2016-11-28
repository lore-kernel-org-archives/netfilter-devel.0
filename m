From: Phil Sutter <phil@nwl.cc>
Subject: Re: Filtering invalid MAC addresses
Date: Mon, 28 Nov 2016 08:33:15 +0100
Message-ID: <20161128073315.GN6158@orbyte.nwl.cc>
References: <7e23d525adcd53f91eb6bf6db65a7e91@northome.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: jordi guri <jordi@northome.ca>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:45699 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754144AbcK1HdR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Nov 2016 02:33:17 -0500
Content-Disposition: inline
In-Reply-To: <7e23d525adcd53f91eb6bf6db65a7e91@northome.ca>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Sun, Nov 27, 2016 at 06:09:11PM -0800, jordi guri wrote:
> I was wondering if the newer nftables is able to deal with invalid MAC 
> addresses.  iptables I don't think can deal with these.  For example I 
> have the following showing up in my log (from some anonymous proxy port 
> scanner):
> +++++
> Nov 27 17:27:40 northome kernel: ** iptables-DROP ** IN=eth0 OUT= 
> MAC=f2:3c:91:9b:81:db:84:78:ac:0d:79:c1:08:00 SRC=183.
> 60.48.25 DST=23.92.27.236 LEN=40 TOS=0x00 PREC=0x20 TTL=51 ID=0 DF 
> PROTO=TCP SPT=12208 DPT=5902 WINDOW=8192 RES=0x00 SYN
>   URGP=0
> 
> Nov 27 17:31:50 northome kernel: ** iptables-DROP ** IN=eth0 OUT= 
> MAC=f2:3c:91:9b:81:db:84:78:ac:0d:a6:41:08:00 SRC=175.
> 194.186.44 DST=23.92.27.236 LEN=40 TOS=0x00 PREC=0x00 TTL=52 ID=39168 
> PROTO=TCP SPT=24565 DPT=23 WINDOW=19941 RES=0x00 S
> +++++
> 
> There are many such entries as the above (all day, every minute) for 
> various destination ports on my server, and (in this case) with the same 
> 2 invalid MAC addresses.

Looking at nf_log_ipv4.c, what is actually printed after 'MAC=' is not
just a MAC address, but the full Ethernet header, i.e. a combination of
destination MAC address, source MAC address and Ethertype. So the first
logged packet above has destination MAC address f2:3c:91:9b:81:db,
source MAC address 84:78:ac:0d:79:c1 (prefix 84:78:ac belongs to Cisco
Systems Inc.) and Ethertype of 0x0800 (IPv4).

> What is interesting about this is that the first part of both of the 
> above MAC addresses in my iptables log are; "f2:3c:91:9b:81:db".  This 
> happens to be the same MAC address as that of my server's eth0 
> interface.  Therefore I cannot block these scan attempts via the MAC 
> address alone (even if I could in part).

Which is expected, otherwise your server wouldn't receive the frame. :)

> So my question;  Does/is nftables/iptables going to offer some sort of 
> solution to the above invalid MAC address problem, as iptables does 
> currently for invalid packets and IP addresses?

With iptables, there is '-m mac' to match source MAC addresses. With
nftables, you can use 'ether saddr' or 'ether daddr' matches to test
against source or destination MAC address.

Cheers, Phil
