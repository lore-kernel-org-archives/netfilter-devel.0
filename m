From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: iptables does not handle hostname with DNAT
Date: Sat, 22 May 2004 00:39:35 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0405220030010.28306-100000@filer.marasystems.com>
References: <40AE016E.6050007@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Thomas Woerner <twoerner@redhat.com>
In-Reply-To: <40AE016E.6050007@redhat.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 21 May 2004, Thomas Woerner wrote:

> is there a reason why DNAT can only be used with ip adresses and not with 
> hostnames?

None other than the small fact that iptables can only operate on IP
addresses..  but I don't really see any reason why DNAT --to should not
accept host names much like any of the other IP address specifications in
iptables. Well, there is one.. DNAT can only accept a single IP address
but a host name may return multiple IP addresses but it is pretty trivial
to deal with so..

What is needed is to rewrite libipt_DNAT.c to use parse_hostnetworkmask
rater than dotted_to_addr. See libipt_conntrack.c for an example on how it
can be done.

Regards
Henrik
