From: Guillaume Leccese <guillaume.leccese@oxalide.com>
Subject: iptables logging to syslog: performance problem
Date: Tue, 23 Oct 2007 17:12:40 +0200
Message-ID: <471E0F68.4010700@oxalide.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi list,

On a 2.6.19.1 kernel box (nfct patch from Julian
http://www.ssi.bg/~ja/nfct/) we have a strange performance problem.

When a scan occur on a /24 network handled by the firewall (on a filtered
port) packets dropping produces a syslog output. During the logging process,
the traffic is at a frozen state (2 seconds to 30 seconds, depending of the
number of ports scanned).

vmstat output when the problem happen:

procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
2 0     0 577112 102152 266592     0     0     0     0 1698 1513 0 16 84 0
2 0     0 576120 102152 266592     0     0     0     0 1690 1507 0 16 83 0

Before, interrupt is approximatively at 25k/sec (symmetrical to the
traffic). For instance, usually we have 100mb/s on outgoing with
a peak above 200mb/s during high activity.

vmstat output at normal state:

procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
0  0      0 753820 113540  77544    0    0     0    16 24668   91  0  6 94  0
0  0      0 753820 113540  77544    0    0     0     0 24919   72  0  7 93  0

The probleme can be reproduced with a nmap /24 scan on a specific port or
with a full scan on a single host.

a vmstats when output to syslog is not active:

Oct 20 00:46:50 2 0 0 814400 43740 99024 0 0 0 0 16995 7325 10 32 58 0
Oct 20 00:46:51 2 0 0 814316 43740 99024 0 0 0 0 16166 7322 10 32 58 0

I have done these vmstats during the night, traffic was not so important, but
interrupts does not decrease and no freeze noticed.

When output to syslog is not effective, there is no performance decrease.

More details about the configuration:

- Linux 2.6.19.1, module activate, iptables not in module
- e1000, tygon 3 and sundance drivers in module
- bonding device in module
- 2x e1000, driver v7.6.9 stable, in bonding
- Keepalived 1.1.12-1, Debian apt version

Comments and help are welcome.

Regards,

-- 
Guillaume Leccese
13, rue Greneta 75003 Paris
tel: 01 44 78 63 66 - fax: 01 44 78 63 65
http://www.oxalide.com



