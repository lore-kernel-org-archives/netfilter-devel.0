From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: bug in conntrack + NAT filtering [was Re: [ANNOUNCE] Release conntrack-tools
 0.9.6]
Date: Sun, 13 Apr 2008 03:53:24 +0200
Message-ID: <48016794.8050409@netfilter.org>
References: <47D28F29.6080707@netfilter.org> <Pine.LNX.4.64.0803092018460.24925@bizon.gios.gov.pl> <Pine.LNX.4.64.0803092035380.24925@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48917 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751022AbYDMBxb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 12 Apr 2008 21:53:31 -0400
In-Reply-To: <Pine.LNX.4.64.0803092035380.24925@bizon.gios.gov.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Krzysztof,

Krzysztof Oledzki wrote:
>> BTW: It seems there is somethig wrong with --dst-nat/--src-nat filtering:
>>
>> # conntrack -L --src-nat|wc -l;conntrack -L --src-nat=1.2.3.4|wc
>> -l;conntrack -L --src-nat=244.244.244.244|wc -l
>> 5010
>> 5010
>> 5010

I have committed a patch to SVN that it is supposed to fix this problem.

The commit also contains a way more flexible delete and update
operations, now you can do: conntrack -D -s 1.2.3.4 to delete all the
flows that are identified by the source IP 1.2.3.4. Similar feature for
the update operation: conntrack -U -s 1.2.3.4 -m 1 sets the connmark to
1 for all the matching flows.

I have also added a very (really very) simple tool to SVN that to
perform qa testing for the command line tool based on an user-defined
testsuite. Any help feeding the testsuite directory would be appreciate.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
