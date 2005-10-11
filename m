From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [PATCH/RFC/RFT] add "revision" support to arp_tables and
	ip6_tables
Date: Tue, 11 Oct 2005 15:36:55 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0510111530010.2575@filer.marasystems.com>
References: <20051009222628.GC6593@rama.customers.eurospot.com>
	<434A373B.1060406@gmx.net> <20051010163256.GB5627@rama>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2005@gmx.net>
In-Reply-To: <20051010163256.GB5627@rama>
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

On Mon, 10 Oct 2005, Harald Welte wrote:

> Are you referring to something specific inside arp_tables kernel or
> userspace code?  We had a similar change in ip_tables some time ago, and
> just made sure that the userspace program ("iptables") didn't generate
> any strings longer than IPT_FUNCTION_NAMELEN-2.  Since we never had any
> matches or targets that used the full length, there is no problem.

And if it becomes a problem it is not hard to change the code to support 
IPT_FUNCTION_NAMELEN-1 length targets/matches again by implicitly 
null-terminating the string after extracting the version or using strncmp 
to compare the names (no null termination required if within n).

So even if there today exists a target/match with a name of this length it 
is not unfixable.

The versioning support only reduces the theoretical max target/match 
length which can be supported by the structures by one character from 
IPT_FUNCTION_NAMELEN to IPT_FUNCTION_NAMELEN-1. To keep implementation 
simple the change it actually reduces the max length from 
IPT_FUNCTION_NAMELEN-1 to IPT_FUNCTION_NAMELEN-2 by keeping the null 
termination of the string but this is not stricly required.

Regards
Henrik
