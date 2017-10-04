From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nftables: Add support for unsupported codes in icmp and icmp6
 extensions
Date: Wed, 4 Oct 2017 13:08:52 +0200
Message-ID: <20171004110852.GA2575@salvia>
References: <1507110760.6328.16.camel@harryPotter>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="jI8keyz6grp/JLjh"
Cc: netfilter-devel@vger.kernel.org, outreachy-kernel@googlegroups.com
To: Harsha Sharma <harshasharmaiitr@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:48821 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751114AbdJDLI4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Oct 2017 07:08:56 -0400
Content-Disposition: inline
In-Reply-To: <1507110760.6328.16.camel@harryPotter>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Harsha,

I would suggest you start with a more simple task:

Probably you can add one test for named objects to our tests/shell/
directory under nftables.git tree.

I'm attaching a couple of examples. Please, have a look at
nft/tests/shell/ directory.

Thanks.

--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=nft-limit-name

table ip filter {
            limit http-traffic {
		rate 1/second
            }

            chain input {
                    type filter hook input priority 0; policy accept;
                    limit name tcp dport map { 80 : "http-traffic", 443 : "http-traffic"}
            }
}

--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=nft-stateful-objs

table ip x {
        counter user123 {
                packets 12 bytes 1433
        }

        quota user123 {
                over 2000 bytes
        }

        quota user124 {
                over 2000 bytes
        }

        set y {
                type ipv4_addr
        }

        map test {
                type ipv4_addr : quota
                elements = { 192.168.2.2 : "user124", 192.168.2.3 : "user124"}
        }

        chain y {
                type filter hook input priority 0; policy accept;
                counter name ip saddr map { 192.168.2.2 : "user123", 1.1.1.1 : "user123", 2.2.2.2 : "user123"}
                quota name ip saddr map @test drop
        }
}

--jI8keyz6grp/JLjh--
