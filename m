From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: Bug Report: IPtables 1.2.* segfaulted by iptables 1.3.*
Date: Mon, 1 Aug 2005 09:19:48 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0508010918570.7329@yvahk01.tjqt.qr>
References: <9927912d05072704113d7e8707@mail.gmail.com>
	<e756d62eb5442015@mayday.cix.co.uk>
	<20050729105834.GD7063@rama.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Robert de Bath <list-netfilter@debath.co.uk>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050729105834.GD7063@rama.de.gnumonks.org>
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


>mh, mixing multiple versions of the tools is a bad idea anyway.  We have

There are .version members in the info struct of both userspace and 
kernelspace modules - if they are different, why did not iptables catch this?



Jan Engelhardt
-- 
