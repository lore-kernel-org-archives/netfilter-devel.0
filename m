From: Eicke Friedrich <tady@gmx.net>
Subject: Re: how to clear the conntrack table!
Date: Mon, 25 Aug 2003 12:14:01 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F49E169.5070707@gmx.net>
References: <006301c3630d$7c163260$5b01aa0a@nightmare> <20030823210837.GE6750@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20030823210837.GE6750@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Harald Welte wrote:
> unfortunately there is currently no other way than to unload and
> reload the ip_conntrack module :(
I've tried this a couple of times. The module seems to get deleted
(lsmod still shows ip_conntrack but as deleted) but rmmod does NOT
finish. It grabs 100% CPU for minutes. I had to reboot the box then.
Any hints?

Regards,
Eicke.
