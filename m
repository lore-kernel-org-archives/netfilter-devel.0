From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: libiptc question
Date: Wed, 25 Feb 2004 23:02:19 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0402252259370.32183-100000@filer.marasystems.com>
References: <20040225042920.21925.qmail@web25104.mail.ukl.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: =?iso-8859-1?q?Jambunathan=20Kalyanasundaram?= <k_jambunathan@yahoo.co.uk>
In-Reply-To: <20040225042920.21925.qmail@web25104.mail.ukl.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 25 Feb 2004, Jambunathan Kalyanasundaram wrote:

> I would like to add a SNAT rule ( with a TCP protocol match )
> programmatically to iptables.

Then the best method is to call the iptables command from your program to
add the needed iptables rule.

Using libiptc is completely undocumented and subject to change at any
time, even if unlikely as there is not much reason to care about libiptc
at this time with thoughts going into the next generation.

Regards
Henrik
