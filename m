From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 15/33] netns ct: pass conntrack to nf_conntrack_event_cache()
 not skb
Date: Tue, 09 Sep 2008 08:04:14 +0200
Message-ID: <48C611DE.8090509@trash.net>
References: <48C01046.2070704@trash.net> <1220842990-30500-15-git-send-email-adobriyan@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	containers@lists.linux-foundation.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1220842990-30500-15-git-send-email-adobriyan@gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Alexey Dobriyan wrote:
> This is cleaner, we already know conntrack to which event is relevant.

Applied, thanks.
