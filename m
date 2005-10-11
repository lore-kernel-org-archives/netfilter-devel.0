From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] fix iptables on systems with discontiguous processor ids
Date: Tue, 11 Oct 2005 14:33:52 -0700 (PDT)
Message-ID: <20051011.143352.35876843.davem@davemloft.net>
References: <434AE1A0.5030400@frankengul.org>
	<20051011142347.GB4756@rama.de.gnumonks.org>
	<434C27A8.5080403@frankengul.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: seb@frankengul.org
In-Reply-To: <434C27A8.5080403@frankengul.org>
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

From: S=E9bastien Bernard <seb@frankengul.org>
Date: Tue, 11 Oct 2005 22:59:20 +0200

> What information do you need exactly ?
> The oops can be tiresome to write down.
> Is the stackdump enough or do you need register info ?

The "TPC" should be translated into a specific symbol in the debugging =
output,
as should the backtrace call trace.  I guess those symbols ought to be
enough for now, and if we need more info we can ask for it specifically=

later after going over the log you give us.
