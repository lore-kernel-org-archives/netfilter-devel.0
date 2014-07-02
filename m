From: Maxime Bizon <mbizon@freebox.fr>
Subject: Re: Parser stable fix question for CFG80211_INTERNAL_REGDB
Date: Wed, 02 Jul 2014 14:04:41 +0200
Message-ID: <1404302681.25238.1.camel@sakura.staff.proxad.net>
References: <CAB=NE6WfTXiScyXHReEWcpQ9EKpu1YCVQypa-B5BBO6aYXh3fA@mail.gmail.com>
	 <CAB=NE6VTN==Ewvf4HhTcadWLzjZnYkF1xSM1Yej6QfotWHKY0A@mail.gmail.com>
	 <20140701144149.GB6358@tuxdriver.com>
	 <CABPxzYL28zyu5D5iYDZy3wcJ-BMa8RfaFCe88HC5867NhpvPnQ@mail.gmail.com>
Reply-To: mbizon@freebox.fr
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Felix Fietkau <nbd@openwrt.org>, John Walker <john@x109.net>,
	netfilter-devel@vger.kernel.org,
	Richard Fontana <fontana@sharpeleven.org>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ns.iliad.fr ([212.27.33.1]:49818 "EHLO ns.iliad.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040AbaGBMPG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Jul 2014 08:15:06 -0400
In-Reply-To: <CABPxzYL28zyu5D5iYDZy3wcJ-BMa8RfaFCe88HC5867NhpvPnQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wed, 2014-07-02 at 13:03 +0530, Krishna Chaitanya wrote:

> Lot of embedded devices like ours avoid the pain of cross compiling
> crda, udev...
> and resort to internal_regdb as a easy way to get things done.

Count me in.

The whole crda stuff is crazy for embedded devices with fixed hardware.

-- 
Maxime


