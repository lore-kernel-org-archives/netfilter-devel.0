From: Patrick McHardy <kaber@trash.net>
Subject: Re: 2.4.23 masquerading broken?
Date: Sun, 11 Jan 2004 13:08:31 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40013CBF.1080707@trash.net>
References: <20031202165653.GJ615@gaast.net> <3FCCCB02.5070203@trash.net> <20040110215954.GC20706@sunbeam.de.gnumonks.org> <40012825.60405@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Wilmer van der Gaast <lintux@lintux.cx>,
 linux-kernel@vger.kernel.org,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <40012825.60405@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Patrick McHardy wrote:

> BTW: Why do we need a route lookup at all ? Couldn't we just use the 
> first address on dev->in_dev->ifa_list ?
>

I've attached two patches (2.4+2.6) to the bugtracker which change
MASQUERADE to use indev->ifa_list->ifa_local. The 2.6 version is
running here without problems so far. Please have a look at
https://bugzilla.netfilter.org/cgi-bin/bugzilla/show_bug.cgi?id=144 .

Best regards,
Patrick
