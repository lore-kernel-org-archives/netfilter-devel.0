From: Patrick McHardy <kaber@trash.net>
Subject: [RFC NETFILTER 0/4]: rate estimator target/match for load-based routing
Date: Sun, 25 Nov 2007 18:11:36 +0100
Message-ID: <4749ACC8.9060300@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:64256 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331AbXKYRMP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 25 Nov 2007 12:12:15 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

These patches add a new RATEEST target for rate estimation and
a new rateest match to match on the estimated rates. The RATEEST
target uses gen_estimator for rate estimation, so it has the
same constraints as TC rate estimators. The rateest match supports
multiple different modes:

- comparing the estimated rate from a rate estimator against
   given bps/pps values
- comparing the difference of given bps/pps values to the
   measure rate against another set of given values
- comparing the bps/pps values of two rate estimators
- comparing the difference of two given bps/pps values to
   the estimated rates

The first and third mode should be obvious, the second and
third one can be used to compare "free bandwidth". I'm using
it like this to route outgoing FTP data connections over two
different internet connections based on the available bandwidth.

# measure used bandwidth on eth0/ppp0:
iptables -t mangle -A POSTROUTING -o eth0 \
                    -j RATEEST --rateest-name eth0 \
                               --rateest-interval 250ms \
                               --rateest-ewma 0.5s 


iptables -t mangle -A POSTROUTING -o ppp0 \
                    -j RATEEST --rateest-name ppp0 \
                               --rateest-interval 250ms \
                               --rateest-ewma 0.5s


iptables -t mangle -N BALANCE
iptables -t mangle -A PREROUTING -s <ftp-server> -j BALANCE

# route based on available bandwidth
iptables -t mangle -A BALANCE -m helper --helper ftp \
                               -m connmark --mark 0x0 \
                               -m rateest --rateest-delta \
                                          --rateest1 eth0 \
                                          --rateest-bps1 2.5mbit \
                                          --rateest-gt \
                                          --rateest2 ppp0 \
                                          --rateest-bps2 2mbit \
                               -j CONNMARK --set-mark 0x1 


iptables -t mangle -A BALANCE -m helper --helper ftp \
                               -m connmark --mark 0x0 \
                               -m rateest --rateest-delta \
                                          --rateest1 ppp0 \
                                          --rateest-bps1 2mbit \
                                          --rateest-gt \
                                          --rateest2 eth0 \
                                          --rateest-bps2 2.5mbit \
                               -j CONNMARK --set-mark 0x2 


iptables -t mangle -A BALANCE -j CONNMARK --restore-mark

For explanation: eth0 has an upstream bandwidth of 2.5mbit, ppp0
2mbit. It computes the difference between the estimated rates and
the available maximum (== free bandwidth) and chooses the line
with more free bandwidth. The only downside is that the estimator
needs some time to adjust to changed conditions, so when one
transfer finishes and another one starts directly afterwards and
both lines are idle besides the transfer, it will usually go to
the other line. I don't think this can be done any better using
this method, but suggestions for improvement are welcome of
course.

PS: the libxt_rateest.c part needs some minor work in the ->save
function, so no need to point that one out, all other bugs are
real bugs :)


