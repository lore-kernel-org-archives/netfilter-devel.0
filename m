From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [PATCH 5/5] nfacct: add timestamp option
Date: Sun, 02 Sep 2012 21:03:08 +0100
Message-ID: <5043BB7C.5090508@googlemail.com>
References: <1343856436-11129-1-git-send-email-eric@regit.org> <1343856436-11129-6-git-send-email-eric@regit.org> <20120803093533.GE12107@1984> <50420477.6040705@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Leblond <eric@regit.org>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:33406 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417Ab2IBUDU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 2 Sep 2012 16:03:20 -0400
Received: by weyx8 with SMTP id x8so2596074wey.19
        for <netfilter-devel@vger.kernel.org>; Sun, 02 Sep 2012 13:03:19 -0700 (PDT)
In-Reply-To: <50420477.6040705@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> stack=acct1:NFACCT,pgsql3:PGSQL
>
> I get the following error if timestamp is not enabled:
>
> <7> ulogd.c:700 type mismatch between PGSQL and NFACCT in stack
> <7> ulogd.c:727 cannot find key `oob.time.sec' in stack
>
> I had to dig in further to find out why that was the case (something I could have done without), so I think it makes sense for the timestamp to always be included.
>   
I am still getting a mismatch error, though there is no indication as to 
what is causing it (full debug log follows):


<1> ulogd.c:820 building new pluginstance stack (acct1:NFACCT,pgsql3:PGSQL):
<1> ulogd.c:829 tok=`acct1:NFACCT'
<1> ulogd.c:866 pushing `NFACCT' on stack
<1> ulogd.c:829 tok=`pgsql3:PGSQL'
<1> ulogd.c:866 pushing `PGSQL' on stack
<1> ulogd.c:646 traversing plugin `PGSQL'
<5> ../../util/db.c:146 (re)configuring
<1> ulogd_output_PGSQL.c:146 SELECT attname FROM nfacct
<1> ulogd_output_PGSQL.c:166 5 fields in table
<1> ulogd.c:646 traversing plugin `NFACCT'
<1> ulogd.c:662 connecting input/output keys of stack:
<1> ulogd.c:670 traversing plugin `PGSQL'
<7> ulogd.c:700 type mismatch between PGSQL and NFACCT in stack
<1> ulogd.c:627 acct1(NFACCT)
<1> ulogd.c:733 assigning `sum.name(?)' as source for PGSQL(sum.name)
<1> ulogd.c:627 acct1(NFACCT)
<1> ulogd.c:733 assigning `sum.pkts(?)' as source for PGSQL(sum.pkts)
<1> ulogd.c:627 acct1(NFACCT)
<1> ulogd.c:733 assigning `sum.bytes(?)' as source for PGSQL(sum.bytes)
<1> ulogd.c:627 acct1(NFACCT)
<1> ulogd.c:733 assigning `oob.time.sec(?)' as source for 
PGSQL(oob.time.sec)
<1> ulogd.c:627 acct1(NFACCT)
<1> ulogd.c:733 assigning `oob.time.usec(?)' as source for 
PGSQL(oob.time.usec)
<1> ulogd.c:670 traversing plugin `NFACCT'
<5> ../../util/db.c:180 starting
<1> ../../util/db.c:86 allocating 593 bytes for statement
<1> ../../util/db.c:133 stmt='SELECT INSERT_NFACCT('

Any ideas?

Also, not nfacct related, but a general question about ulogd2: What 
happens when I have my iptables NFLOG targets set/created, but the ulog 
daemon is not running - do the packets matching get discarded or do they 
get buffered (if so, how large is this buffer and is this configurable?) 
so that when ulogd2 gets started they get processed?
