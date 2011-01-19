From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: nf_conntrack_tstamp: add flow-based timestamp
 extension
Date: Wed, 19 Jan 2011 16:01:17 +0100
Message-ID: <4D36FCBD.3040808@trash.net>
References: <20110118192724.3438.41304.stgit@decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46763 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099Ab1ASPBW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Jan 2011 10:01:22 -0500
In-Reply-To: <20110118192724.3438.41304.stgit@decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 18.01.2011 20:27, Pablo Neira Ayuso wrote:
> This patch adds flow-based timestamping for conntracks. This
> conntrack extension is disabled by default. Basically, we use
> two 64-bits variables to store the creation timestamp once the
> conntrack has been confirmed and the other to store the deletion
> time. This extension is disabled by default, to enable it, you
> have to:
> 
> echo 1 > /proc/sys/net/netfilter/nf_conntrack_timestamp
> 
> This patch allows to save memory for user-space flow-based
> loogers such as ulogd2. In short, ulogd2 does not need to
> keep a hashtable with the conntrack in user-space to know
> when they were created and destroyed, instead we use the
> kernel timestamp. If we want to have a sane IPFIX implementation
> in user-space, this nanosecs resolution timestamps are also
> useful. Other custom user-space applications can benefit from
> this via libnetfilter_conntrack.
> 
> This patch modifies the /proc output to display the delta time
> in seconds since the flow start. You can also obtain the
> flow-start date by means of the conntrack-tools.

Applied, thanks Pablo.
