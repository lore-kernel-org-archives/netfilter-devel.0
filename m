From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Counter problem in a new nat target.
Date: Thu, 11 Dec 2003 09:20:58 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0312110918060.23401-100000@filer.marasystems.com>
References: <3FD7E26F.2020209@deansoft.com.tw>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Emmanuel Guiton <emmanuel@netlab.hut.fi>,
   <netfilter-devel@lists.netfilter.org>, KOVACS Krisztian <hidden@balabit.hu>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jesse Peng <jesse@deansoft.com.tw>
In-Reply-To: <3FD7E26F.2020209@deansoft.com.tw>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 11 Dec 2003, Jesse Peng wrote:

> The conntrack->help.Private_connection_helper_info and 
> conntrack->nat.help.Private_nat_helper supposed not that much accused 
> been abused.

There is not a problem using these from the helpers, but using these from
a target will give problems if such helper is ever used in the system for 
the same traffic as the target.

By designing the solution using these fields you absolutely rule out the 
possibility to combine the solution with conntrack/nat helpers.

Adding a new field is trivial and does not cause any conflicts. It is open 
source after all.

Regards
Henrik
