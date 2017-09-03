From: DEXTER <mydexterid@gmail.com>
Subject: On ulogd2, nfacct and sqlite3
Date: Sun, 3 Sep 2017 11:12:52 +0200
Message-ID: <4210d497-fda6-a1a9-6fb6-cd139b2a9b47@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:38334 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751977AbdICJMz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 3 Sep 2017 05:12:55 -0400
Received: by mail-wm0-f47.google.com with SMTP id 187so21860552wmn.1
        for <netfilter-devel@vger.kernel.org>; Sun, 03 Sep 2017 02:12:55 -0700 (PDT)
Received: from localhost (188-143-42-143.pool.digikabel.hu. [188.143.42.143])
        by smtp.gmail.com with ESMTPSA id m128sm1597072wmd.23.2017.09.03.02.12.53
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 03 Sep 2017 02:12:53 -0700 (PDT)
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Guys!

I was searching for a _simple_ way to account traffic per host and found
numerous methods just by googleing but none of them were simple.
Then I stumbled upon ulogd2 and this page:
https://home.regit.org/2012/07/flow-accounting-with-netfilter-and-ulogd2/

Which is almost something I want, but the output should be in sqlite3.
So I tried to configure ulogd2 with sqlite3 output on Ubuntu 16.04, and
it just did not want to work.

Here are the issues I found (after all my remaining hair have fallen out):

- First, this is what comes up in the logs after starting ulogd:
"type mismatch between SQLITE3 and NFACCT in stack"
This completely misguided me on where to look for the issue. (~40% hair
loss)

- Then I realized (after a couple of hours trying to find out what is
going on) Ubuntu starts ulogd2 with --uid ulog option. When I manually
start ulogd without the --uid option it was able to write to the sqlite
file but not with --uid. I'm thinking this is probably because it cannot
communicate with the kernel after the setgid/setuid, because it is
missing the appropriate capability (maybe CAP_NET_ADMIN? idk.). (~30%
hair loss)

- The docs containing the sqlite3.table file completely missing the
table where the nfacct data can be written. Looking at
pgsql-ulogd2.sql.gz I found that the table columns should be something
like this:
INSERT INTO nfacct
(sum_name,sum_pkts,sum_bytes,oob_time_sec,oob_time_usec) (~5% hair loss)

- Ulogd logs this every pollinterval: unknown type 32816 for sum
This is because in ulogd_output_SQLITE3.c ULOGD_RET_RAW is only handled
in the default: section in the sqlite3_interp function. I don't know why
the sum is RET_RAW, I also don't know what that sum even want to be.
(because there are already sum_pkts, and sum_bytes). (~5% hair loss)

- Data is written to the sqlite database even if the sum_pkts and
sum_bytes are 0. There should be at least on option either on the input
side (nfacct) or the output side(sqlite3) that if the sums are 0 do not
write it to the database. (It just uses up space and I'm only interested
in hourly/daily/monthly/yearly traffic sums). (~6% hair loss)

Now the only thing needed for me is to regularly consolidate the sqlite
database and also show the data on a somewhat pretty web page. This has
nothing to do with ulogd and sqlite or you guys but since I couldn't
find one, I probably need to write my own. (~14% hair loss).

I hope I managed to collect all the issues I found while trying to make
this work, and hoping that someone in the future don't have to go
through this and will have the _justworks_ magic feeling.
