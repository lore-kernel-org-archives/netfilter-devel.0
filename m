From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Dynamic rule creation and deletion
Date: Wed, 25 Feb 2004 23:03:44 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0402252302420.32183-100000@filer.marasystems.com>
References: <20040225171842.54119.qmail@web25105.mail.ukl.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: =?iso-8859-1?q?Jambunathan=20Kalyanasundaram?= <k_jambunathan@yahoo.co.uk>
In-Reply-To: <20040225171842.54119.qmail@web25105.mail.ukl.yahoo.com>
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

> Transparent http proxy is at times required to talk to
> the origin web server with it's own ip address spoofed
> to that of the browser for which it is forwarding the
> request.

For this specific purpose the TPROXY patch was created, avoiding the 
constant modifications of iptables NAT in a more elegant manner.

Regards
Henrik
