From: Willy TARREAU <willy@w.ods.org>
Subject: Re: [ANNOUNCE] call for testing of patch-o-matic-ng
Date: Sun, 29 Feb 2004 16:03:35 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040229150335.GB23662@pcw.home.local>
References: <20040229101116.GA10012@pcw.home.local> <Pine.LNX.4.44.0402291121270.25361-100000@filer.marasystems.com> <20040229142939.GE15558@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>,
   Henrik Nordstrom <hno@marasystems.com>,
   Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <20040229142939.GE15558@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I hit enter too early...

Harald, could you slightly modify the runme script so that it strips
trailing slashes in the patches names ? I make use of <TAB> a lot
in the directory and bash automatically adds a slash at the end of
the name, which fools the script.

BTW, if some people are interested, I have written a very little script
which helps you to easily you keep a profile of patch sets to apply.

Regards
Willy
