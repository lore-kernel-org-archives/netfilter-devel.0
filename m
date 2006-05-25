From: Patrick McHardy <kaber@trash.net>
Subject: Re: "bad argument" trouble with iptables-restore (ipt v.1.3.4 +
 gentoo 2.6.16)
Date: Thu, 25 May 2006 19:50:48 +0200
Message-ID: <4475EE78.4000306@trash.net>
References: <4474EEC4.4070909@ionpipe.com> <4475DDC4.4090008@ionpipe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eric White <eric.white@ionpipe.com>
In-Reply-To: <4475DDC4.4090008@ionpipe.com>
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

Eric White wrote:
> With a little more experimentation, I see that manually poking a new
> chain definition (e.g., "iptables -t filter -N :A:Svc:ABD ") and then
> issuing iptables-save generates a
> 
> ::A:Svc:ABD - [0:0]
> 
> line in the output.  So, I modified the ruleset, replacing all -N
> occurrences with the corresponding ":" prefix and added the "- [0:0]'
> suffix, with the same result; i.e., the COMMIT line generates a "bad
> argument" error.


This usually means that a previously used match/target didn't
ignore unknown arguments as it ought to do. I suggest to
try the latest iptables version (there are a couple of these
fixes in each release), if that doesn't help please try to
find out which match or target is responsible by removing
individual lines until the error goes away.
