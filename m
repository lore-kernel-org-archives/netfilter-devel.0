From: Eric Leblond <eric@regit.org>
Subject: Issue with latest nftables
Date: Fri, 28 Jun 2013 22:08:40 +0200
Message-ID: <1372450120.8772.5.camel@tiger2>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:59907 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932Ab3F1UJD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Jun 2013 16:09:03 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I've found an issue when using the libnftables based nft.

If you use nft-add-rule from libnftables examples and you try to list
the rules afterward with nft, there is a problem with the added rules
which are not displayed correctly.

Here is the output of "nft list table filter -n -a --debug=all":

family=ip table=filter chain=output handle=9 flags=0 match name=iprange rev=1 payload dreg=1 base=1 offset=9 len=1 target name=LOG rev=0 
table filter {
        chain input {
                 hook NF_INET_LOCAL_IN 0;
        }

        chain forward {
                 hook NF_INET_FORWARD 0;
        }

        chain output {
                 hook NF_INET_LOCAL_OUT 0;
                 ip daddr 1.2.3.4 drop # handle 4
                 ip daddr 1.2.3.5 drop # handle 5
                 ip daddr 1.2.3.6 drop # handle 6
                 # handle 9
        }
}
netlink: Error: unknown expression type 'match'
name=iprange rev=1 


netlink: Error: unknown expression type 'target'
name=LOG rev=0 

Should this problem be trivial for someone, I let him do the job. If
not, I will start to work on it. 

BR,
-- 
Eric Leblond <eric@regit.org>
Blog: https://home.regit.org/

