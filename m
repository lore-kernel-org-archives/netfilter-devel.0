From: Anton VG <anton.vazir@gmail.com>
Subject: Re: Ulogd2 beta3 +NFCT - unable to get working
Date: Wed, 24 Jun 2009 14:40:24 +0500
Message-ID: <c4b050a10906240240m5d685ca8q80424978fb475caa@mail.gmail.com>
References: <c4b050a10906231656u53e20855ud5cf5833ca5db7cc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:57326 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756990AbZFXJkW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Jun 2009 05:40:22 -0400
Received: by ewy6 with SMTP id 6so982547ewy.37
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Jun 2009 02:40:24 -0700 (PDT)
In-Reply-To: <c4b050a10906231656u53e20855ud5cf5833ca5db7cc@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello!
Just my experience with ULOGD 2.0 beta 3. NFCT logging seems broken.
I've managed to get something working, i'm logging to a PGSQL DB.

When I do enable hash_enable=0 and
pollinterval=100 and"INSERT_CT"  - it starts logging connections, but
after a while, byte counters of already logged connections in DB was
zeroed.

If hash_enable=1 and -"INSERT_CT" - it logs some connections, and byte
counters always 0

if pollinterval is not manually defined - it does not log anything.

Libraries and netfilter all latest
Kernel 2.6.29.5
os Debian stable

my test bed is 3 PC's , one of which consists all the given stuff for
traffic accounting and i'm WGETtting files between 1 and 3rd PC's and
watching the result in

PC_1 <-- NFCT_PC_2 --> PC_3

stack=ct1:NFCT,ip2str1:IP2STR,pgsql1:PGSQL

[pgsql1]
db="ulog2"
host="192.168.1.148"
user="ulog2"
table="ulog2_ct"
pass="ulog2"
procedure="INSERT_CT"
#procedure="INSERT_OR_REPLACE_CT"

[ct1]
pollinterval=1
hash_enable=1

Anything I can do to help fixing this?
