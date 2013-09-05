From: Valentina Giusti <valentina.giusti@oss.bmw-carit.de>
Subject: Re: [PATCH 0/4] [RFC] nfnetlink_acct: Traffic-based and periodic
 notifications
Date: Thu, 05 Sep 2013 09:58:52 +0200
Message-ID: <522839BC.6000909@oss.bmw-carit.de>
References: <1378296333-19208-1-git-send-email-valentina.giusti@bmw-carit.de> <20130904123920.GB4900@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: valentina.giusti@bmw-carit.de, netfilter-devel@vger.kernel.org,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	"David S. Miller" <davem@davemloft.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.bmw-carit.de ([62.245.222.98]:49633 "EHLO
	linuxmail.bmw-carit.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762687Ab3IEH65 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Sep 2013 03:58:57 -0400
In-Reply-To: <20130904123920.GB4900@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

On 09/04/2013 02:39 PM, Pablo Neira Ayuso wrote:
> On Wed, Sep 04, 2013 at  02:05:29PM +0200,
 > valentina.giusti@bmw-carit.de wrote:
 >> From: Valentina Giusti <valentina.giusti@bmw-carit.de>
 >>
 >> This patchset introduces notifications of accounting objects to
 >> userspace for nfacct. Notifications can be sent periodically or
 >> based on the amount of accounted bytes or packets. In case a
 >> notification is set by giving a period as well as a given amount of
 >> traffic, the number of notifications triggered during a period can
 >> be rate limited.
 >>
 >> The need for notifications stems from monitoring applications (e.g.
 >> connman) which currently need to keep polling accounting objects
 >> via nfnl_acct_get() in order to get updated statistics. This is far
 >> from ideal in scenarios with large amounts of accounting objects
 >> and diverse, unpredictable network traffic.
 >>
 >> This implementation introduces a new message type,
 >> NFNL_MSG_ACCT_NOTIFY, which is sent by userspace (typically,
 >> libnetfilter_acct) in order to configure accounting notifications.
 >> The new message parameters are NFACCT_NOTIFY_PACKETS,
 >> NFACCT_NOTIFY_BYTES and NFACCT_NOTIFY_PERIOD, which are sent with
 >> the accounting object name. Userspace applications would typically
 >> configure desired notification modes and then get appropriate
 >> notifications via netlink, on the same socket used for said
 >> configuration.
 >>
 >> The patches needed for libnetfilter_acct and nfacct are included in
 >> this series.
 >>
 >> An example of nfacct usage is:
 >>
 >> $ nfacct add http-traffic # Create the accounting object
 >>
 >> [create related iptables rules here]
 >>
 >> $ nfacct notify http-traffic bytes 1024 [for every 1024 bytes of
 >> HTTP traffic:] { pkts = 00000000000000039225, bytes =
 >> 00000000000002361568 } = http-traffic; { pkts =
 >> 00000000000000039245, bytes = 00000000000002362608 } =
 >> http-traffic; ...
 >>
 >> or:
 >>
 >> $ nfacct notify-traffic http packets 100 [for every 100 packets of
 >> HTTP traffic:] { pkts = 00000000000000008303, bytes =
 >> 00000000000000486469 } = http-traffic; { pkts =
 >> 00000000000000008403, bytes = 00000000000000494581 } =
 >> http-traffic; ...
 >>
 >> or:
 >>
 >> $ nfacct notify http-traffic interval 120 [every two minutes:] {
 >> pkts = 00000000000000008303, bytes = 00000000000000486469 } =
 >> http-traffic; { pkts = 00000000000000008403, bytes =
 >> 00000000000000494581 } = http-traffic; ...
 >>
 >> or:
 >>
 >> $ nfacct notify http-traffic bytes 1024 bytes-ratelimit 4 period 5
 >> { pkts = 00000000000000010172, bytes = 00000000000000628714 } =
 >> http-traffic; { pkts = 00000000000000010192, bytes =
 >> 00000000000000629754 } = http-traffic; { pkts =
 >> 00000000000000010212, bytes = 00000000000000630794 } =
 >> http-traffic; { pkts = 00000000000000010232, bytes =
 >> 00000000000000631834 } = http-traffic; { pkts =
 >> 00000000000000010894, bytes = 00000000000000672343 } =
 >> http-traffic; ...
 > You can implement this from userspace by polling to obtain the
 > counters.

As I mentioned, there are

"applications (e.g. connman) which currently need to keep polling 
accounting objects via nfnl_acct_get() in order to get updated 
statistics. This is far from ideal in scenarios with large amounts of 
accounting objects and diverse, unpredictable network traffic."

- V.
