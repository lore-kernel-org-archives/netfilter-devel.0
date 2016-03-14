From: ravin goyal <ravirocks1021@gmail.com>
Subject: libnetfilter_conntrack's NFCT_OF_TIMESTAMP is not working
Date: Mon, 14 Mar 2016 10:39:20 +0530
Message-ID: <CANU0Mn2zLUqjhcOWKYvSFetH94sp2zf8O7rkFaoYa7sfTn8epg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hii

regarding libnetfilter_conntrack I have been working on getting start
and stop timestamp of the connection, I lookup source code and found
if i enable NFCT_OF_TIMESTAMP (echo "1" >
/proc/sys/net/netfilter/nf_conntrack_timestamp)  , i will get the same
but when i ran
conntrack -E -eDESTROY -otimestamp,extended , it didn't show the start
and stop time and when i print the value it said flags=1,
NFCT_OF_TIMESTAMP is 8
somehow the following line....
if (flags & NFCT_OF_TIMESTAMP) in code
/src/conntrack/snprint_default.c doesn't match hence function
__snprintf_timestamp_start and __snprintf_timestamp_stop doesn't get
called.

I don't know how else can i set or use NFCT_OF_TIMESTAMP

any help regarding this issue would be appreciated

Regards
Ravin Goyal
