From: Ricardo Klein <klein.rfk@gmail.com>
Subject: ipset 6.16 kernel panic on bitmap:hash,ip
Date: Tue, 27 Nov 2012 10:17:59 -0200
Message-ID: <CADuigkVyCJVe5yKVvcKweZ=FmnTTWE1JQ55a35LrCLi2oWBHoQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

When I creta an ipset like this:
ipset -N SET_MACS bitmap:ip,mac range 0.0.0.0/0

I got kernel panic when run:
ipset list

Anyway, we need some rules here based on mac address (no matter what
ip address the machine have, because some of them are in DHCP).
I know that a mac address can be easy cloned, but, still, we need that
for some rules...

Can we have a set type "mac address" ? Only mac, with no ip?

O tried "ipset -N SET_MACS_ADM bitmap:ip,mac range 10.0.0.0/8" too but got:
ipset v6.16: The range you specified exceeds the size limit of the set type

"ipset -N SET_MACS_ADM bitmap:ip,mac range 10.0.0.0/16" woked...

But again, this does not do the job because I need to set a rule based
on mac address and dinamic ip addresses.

* Using CentOS 6.3 x86_64 with latest updates on VirtualBox (last one too)

--
Att...

Ricardo Felipe Klein
klein.rfk@gmail.com
