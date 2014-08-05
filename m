From: Matteo Croce <technoboy85@gmail.com>
Subject: Re: nftables null pointer
Date: Tue, 5 Aug 2014 12:21:30 +0200
Message-ID: <CAFnufp3mVBFVfLOmb3QofpPDubCYgzmOUc4u4vGM6gXv+6Rezg@mail.gmail.com>
References: <CAFnufp1157iUqOpax6Po-PZivC_7TQSeQqtmJnnpNLVm3hzH9w@mail.gmail.com>
 <20140805100141.GA3480@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qa0-f51.google.com ([209.85.216.51]:60803 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757584AbaHEKWL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Aug 2014 06:22:11 -0400
Received: by mail-qa0-f51.google.com with SMTP id k15so675636qaq.24
        for <netfilter-devel@vger.kernel.org>; Tue, 05 Aug 2014 03:22:10 -0700 (PDT)
In-Reply-To: <20140805100141.GA3480@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Yes it's reproducible with two config and two list:

# nft -f /dev/stdin <<EOF
table ip nat {
        chain post {
                type nat hook postrouting priority 0;
                ip saddr 192.168.0.0/24 oif eth0 snat 192.168.1.2
        }
}
EOF

# nft -n list table nat

# nft -f /dev/stdin <<EOF
table ip nat {
        chain post {
                type nat hook postrouting priority 0;
                ip saddr 192.168.0.0/24 oif eth0 snat 192.168.1.2
        }
}
EOF

# nft -n list table nat

2014-08-05 12:01 GMT+02:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> On Tue, Aug 05, 2014 at 10:01:56AM +0200, Matteo Croce wrote:
>> with vanilla linux 3.16.0 and  ntf 0.3:
>>
>> # nft list table nat
>> Killed
>> nf_tables: (c) 2007-2009 Patrick McHardy <kaber@trash.net>
>> BUG: unable to handle kernel NULL pointer dereference at 00000008
>> IP: [<d0b4beef>] nf_tables_fill_chain_info+0x27f/0x350 [nf_tables]
>
> Is this reproducible? If so, please indicate the sequence of commands.
> Thanks.



-- 
Matteo Croce
OpenWrt Developer
