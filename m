From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: More on LIST_DELETE message with kernels 2.4.23 through 2.4.25
Date: Wed, 17 Mar 2004 11:51:54 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0403171145200.6035-100000@filer.marasystems.com>
References: <1079516281.4874.11.camel@vijay>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: KOVACS Krisztian <hidden@balabit.hu>,
   Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
   netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Vijaya Chandra Vupputuri <vijay@tachyontech.net>
In-Reply-To: <1079516281.4874.11.camel@vijay>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 17 Mar 2004, Vijaya Chandra Vupputuri wrote:

> 've tried to do the same but I don't seem to have any problem on a test
> box with redhat 7.3 (2.4.18-3)

And you have built your kernel with CONFIG_IP_NF_LOCAL_NAT disabled in
your kernel config? This is required to enable the assymetry in the NAT
code mentioned by KOVACS.

At least in the RedHat 2.4.20-28.7 kernel CONFIG_IP_NF_LOCAL_NAT is
enabled by default, so unless you have built a custom RedHat kernel with
this disabled you should not see the issue mentioned.

Regards
Henrik
