From: Patrick McHardy <kaber@trash.net>
Subject: Re: [2.6 patch] make nf_ct_path[] static
Date: Wed, 30 Jan 2008 21:02:57 +0100
Message-ID: <47A0D7F1.7010700@trash.net>
References: <20080130200259.GE29368@does.not.exist>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pavel Emelyanov <xemul@openvz.org>,
	"David S. Miller" <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Adrian Bunk <bunk@kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60187 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763789AbYA3UDc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:03:32 -0500
In-Reply-To: <20080130200259.GE29368@does.not.exist>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Adrian Bunk wrote:
> This patch makes the needlessly global nf_ct_path[] static.


I already have this queued.
