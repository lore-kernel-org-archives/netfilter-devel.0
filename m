From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: nf_conntrack_tstamp: add flow-based timestamp
 extension
Date: Tue, 18 Jan 2011 14:59:18 +0100
Message-ID: <4D359CB6.60701@trash.net>
References: <20110116223329.32349.13288.stgit@decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56133 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962Ab1ARN7U (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Jan 2011 08:59:20 -0500
In-Reply-To: <20110116223329.32349.13288.stgit@decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 16.01.2011 23:33, Pablo Neira Ayuso wrote:
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
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  include/linux/netfilter/nfnetlink_conntrack.h  |    9 ++++
>  include/net/netfilter/nf_conntrack_extend.h    |    4 ++
>  include/net/netfilter/nf_conntrack_timestamp.h |   53 ++++++++++++++++++++++++
>  include/net/netns/conntrack.h                  |    2 +
>  net/netfilter/Kconfig                          |   11 +++++
>  net/netfilter/Makefile                         |    1 
>  net/netfilter/nf_conntrack_core.c              |   26 ++++++++++++
>  net/netfilter/nf_conntrack_netlink.c           |   46 ++++++++++++++++++++-
>  net/netfilter/nf_conntrack_standalone.c        |   41 +++++++++++++++++++

The nf_conntrack_timestamp.c file is missing from this patch.
