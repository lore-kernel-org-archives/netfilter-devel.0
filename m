From: Michal Kubecek <mkubecek@suse.cz>
Subject: Re: Filtering invalid MAC addresses
Date: Mon, 28 Nov 2016 08:31:28 +0100
Message-ID: <20161128073128.GA19119@unicorn.suse.cz>
References: <7e23d525adcd53f91eb6bf6db65a7e91@northome.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: jordi guri <jordi@northome.ca>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49102 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750878AbcK1Hba (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Nov 2016 02:31:30 -0500
Content-Disposition: inline
In-Reply-To: <7e23d525adcd53f91eb6bf6db65a7e91@northome.ca>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Nov 27, 2016 at 06:09:11PM -0800, jordi guri wrote:
> 
> I was wondering if the newer nftables is able to deal with invalid
> MAC addresses.  iptables I don't think can deal with these.  For
> example I have the following showing up in my log (from some
> anonymous proxy port scanner):
> +++++
> Nov 27 17:27:40 northome kernel: ** iptables-DROP ** IN=eth0 OUT=
> MAC=f2:3c:91:9b:81:db:84:78:ac:0d:79:c1:08:00 SRC=183.
> 60.48.25 DST=23.92.27.236 LEN=40 TOS=0x00 PREC=0x20 TTL=51 ID=0 DF
> PROTO=TCP SPT=12208 DPT=5902 WINDOW=8192 RES=0x00 SYN
>  URGP=0
> 
> Nov 27 17:31:50 northome kernel: ** iptables-DROP ** IN=eth0 OUT=
> MAC=f2:3c:91:9b:81:db:84:78:ac:0d:a6:41:08:00 SRC=175.
> 194.186.44 DST=23.92.27.236 LEN=40 TOS=0x00 PREC=0x00 TTL=52
> ID=39168 PROTO=TCP SPT=24565 DPT=23 WINDOW=19941 RES=0x00 S
> +++++
> 
> There are many such entries as the above (all day, every minute) for
> various destination ports on my server, and (in this case) with the
> same 2 invalid MAC addresses.

Why do you call them "invalid"? As far as I can tell, 84:78:ac:0d:79:c1
and 84:78:ac:0d:a6:41 are normal MAC addresses (with Cisco vendor
prefix), there doesn't seem to be anything invalid about them.

> What is interesting about this is that the first part of both of the
> above MAC addresses in my iptables log are; "f2:3c:91:9b:81:db".
> This happens to be the same MAC address as that of my server's eth0
> interface.

What you call "first part" is the destination MAC address so it's hardly
surprising it matches the MAC address of the incoming interface.

Just to be sure: do you understand that the string after "MAC=" is _not_
a MAC address (it's obviously too long for that) but the whole ethernet
header consisting of

  - 6 bytes of destination MAC address
  - 6 bytes of source MAC address
  - 2 bytes of packet type (0800 is IPv4)

and that source MAC address in this header is always going to belong to
the last hop on the way to you, i.e. it's almost always useless for
identifying the actual attacker?

                                                         Michal Kubecek
