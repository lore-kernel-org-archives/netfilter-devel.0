From: Milos Wimmer <wimmer@zcu.cz>
Subject: Re: [PATCH] Fix NAT TCP sequence adjustment
Date: Sun, 3 Apr 2005 14:26:07 +0200 (CEST)
Message-ID: <Pine.LNX.4.62.0504031420030.11607@nike.zcu.cz>
References: <20050402202438.GA2968@linuxace.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20050402202438.GA2968@linuxace.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Sat, 2 Apr 2005, Phil Oester wrote:

> As noted, without this patch an mget fails at (sizediff * strlen(PORT...).
> With this patch, I have successfully transferred 500 files under both
> scenarios: sizediff > 0 and < 0.

  Yes, I tried it just now and I can confirm it works great.

  Thank you for your work,

     Milos Wimmer
