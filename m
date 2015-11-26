From: Daniel Wagner <daniel.wagner@bmw-carit.de>
Subject: Re: [PATCH] iptables: Link libext_arpt to static build
Date: Thu, 26 Nov 2015 07:42:26 +0100
Message-ID: <5656A9D2.3080502@bmw-carit.de>
References: <1448273927-24853-1-git-send-email-daniel.wagner@bmw-carit.de>
 <20151125194541.GA12517@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.bmw-carit.de ([62.245.222.98]:60253 "EHLO
	mail.bmw-carit.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbbKZGmb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Nov 2015 01:42:31 -0500
In-Reply-To: <20151125194541.GA12517@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 11/25/2015 08:45 PM, Pablo Neira Ayuso wrote:
> On Mon, Nov 23, 2015 at 11:18:47AM +0100, Daniel Wagner wrote:
>> The libext_arpt is not included when linking the static version of
>> iptables.
>>
>> Signed-off-by: Daniel Wagner <daniel.wagner@bmw-carit.de>
>> ---
>> Hi,
>>
>> I had some troubles getting a static version of iptables. Not sure
>> if I fixed it correctly. Anyway I am able to proceed with testing.
> 
> Could you tell me what options you're using to compile iptables so I
> can try to reproduce it?

Yes, sure. I am using this simple toy script to build:

declare -a arr=("libmnl" "libnl" "libnftnl" "libnfnetlink"
"libnetfilter" "libnetfilter_acct" "libnetfilter_conntrack"
"libnetfilter_cthelper" "libnetfilter_cttimeout" "libnetfilter_queue"
"iptables")

NFPATH=/home/wagi/connman/netfilter
export PKG_CONFIG_PATH=$NFPATH/lib/pkgconfig
export LD_LIBRARY_PATH=$NFPATH/lib

## now loop through the above array
for i in "${arr[@]}"
do
    echo "$i"
    (
	cd $i
	./configure --prefix=$NFPATH --enable-static
	make -j20
	make install
    )
done
