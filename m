From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [netfilter-core] [2.6 patch] net/ipv4/netfilter/: misc possible
 cleanups
Date: Thu, 16 Dec 2004 09:43:32 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0412160942150.28214@filer.marasystems.com>
References: <20041215011931.GD12937@stusta.de>
	<20041215090322.GA2862@sunbeam.de.gnumonks.org>
	<1103161248.2200.7.camel@localhost.localdomain>
	<20041216074017.GL2862@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Rusty Russell <rusty@rustcorp.com.au>,
	Netfilter development mailing list <netfilter-devel@lists.netfilter.org>,
	Netfilter Core Team <coreteam@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20041216074017.GL2862@sunbeam.de.gnumonks.org>
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

On Thu, 16 Dec 2004, Harald Welte wrote:

> Then different patches need different exports, and you have your patches
> again clashing :(  We've been through this...

Shouldn't be to hard to make pom deal with this in a manner similar to the 
ladd files, or perhaps simply by the ladd mechanism skipping the add if 
the line is there already..

Regards
Henrik
