From: Patrick McHardy <kaber@trash.net>
Subject: Re: Help needed on standalone nat for opening new ports inside the
 code
Date: Sat, 14 Feb 2004 12:17:24 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <402E03C4.20007@trash.net>
References: <1076755824.13168.10.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Nagaraj G <gnraj@teneoris.com>
In-Reply-To: <1076755824.13168.10.camel@localhost.localdomain>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Nagaraj G wrote:
> Hello,
> 
> I am writing a new netfilter application module where-in I have to
> mangle each and every packet. So, I have made the module as a standalone
> NAT with NAT_ALWAYS flag defined.
> 
> ...
>
> I tried doing ip_conntrack_expect_related(). But it fails with -16
> (EBUSY).

EBUSY is returned when max_expected is not set and the expectation
clashes with existing ones. My guess is that you haven't initialized
the mask of the expectation properly. If that's not it, please post
the relevant sections of code, that makes it easier for people to help.

Regards,
Patrick
