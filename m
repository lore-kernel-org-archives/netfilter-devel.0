From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: Asym. router has problems with full ip_conntrack table in
	2.4.20
Date: 27 Jan 2003 12:40:26 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1043667626.4275.30.camel@tux.rsn.bth.se>
References: <20030127112653.GB9209@westend.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Christian Hammers <ch@westend.com>
In-Reply-To: <20030127112653.GB9209@westend.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 2003-01-27 at 12:26, Christian Hammers wrote:

[big snip]
> I can reproduce on my desktop machine that the /proc files are active
> without having ipt_conntrack.o loaded and that I really have packet loss
> when the tables fill up!

ipt_conntrack != ip_conntrack

ipt_conntrack is a match to match on conntrack states.
ip_conntrack is the connectiontracking.

Remove ip_conntrack and all should be fine.

This isn't a development related issue, please post further problems on
this matter to netfilter@lists.netfilter.org
(and remove this list from the recipients)
(I'm sending my reply to the list you mailed just to let people know
that I've already answered your mail)

-- 
/Martin

Never argue with an idiot. They drag you down to their level, then beat you with experience.
