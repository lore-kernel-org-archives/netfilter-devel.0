From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: filter for adding/checking TCP MD5 option
Date: Sat, 24 Jan 2004 10:24:27 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0401241021550.32723-100000@filer.marasystems.com>
References: <20040124083730.GB19035@alpha.home.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Remco van Mook <remco@virtu.nl>, <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Willy Tarreau <willy@w.ods.org>
In-Reply-To: <20040124083730.GB19035@alpha.home.local>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, 24 Jan 2004, Willy Tarreau wrote:

> Unless I'm wrong, nf-hipac's goal is to allow to keep maximum performance with
> *huge* amounts of rules.

It is, nothing more, nothing less.

If there is only a minimal set of rules the performance is the same.

For bigger not very well structured rulesets nf-hipac is a clear win at
the cost of higher memory usage.

Regards
Henrik
