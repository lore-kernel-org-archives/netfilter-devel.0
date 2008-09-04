From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 25/38] netns ct: honest net.netfilter.nf_conntrack_count
Date: Thu, 04 Sep 2008 19:20:45 +0200
Message-ID: <48C018ED.8090708@trash.net>
References: <20080821220719.GY31136@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	containers@lists.linux-foundation.org
To: adobriyan@gmail.com
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20080821220719.GY31136@x200.localdomain>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

adobriyan@gmail.com wrote:
> Note, sysctl table is always duplicated, this is simpler, less special-cased,
> less mistakes (and did one mistake in first version of this patch).

This also doesn't explain what the patch is doing at all.
