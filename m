From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: nat/conntrack helper locking problem?
Date: Thu, 20 Nov 2003 13:24:31 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0311201319250.9722-100000@filer.marasystems.com>
References: <3FBCAF7A.1070609@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
   Harald Welte <laforge@netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <3FBCAF7A.1070609@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 20 Nov 2003, Patrick McHardy wrote:

> Your right the fix is incorrect, I should have taken more time for it.
> Will do so right away ..

Also it did not compile... need to #include 
<linux/netfilter_ipv4/ip_conntrack_core.h> to have ip_conntrack_lock 
defined.

Anyway, knowing what the warning is I am not worried about it. The race 
window in question can not ever happen in our use as the modules are 
explicitly loaded by modprobe one at a time and never removed.

Regards
Henrik
