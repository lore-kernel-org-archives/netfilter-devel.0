From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Counter problem in a new nat target.
Date: Wed, 10 Dec 2003 15:19:52 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0312101514250.10808-100000@filer.marasystems.com>
References: <3FD7170C.2080404@netlab.hut.fi>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org, Jesse Peng <jesse@deansoft.com.tw>,
   KOVACS Krisztian <hidden@balabit.hu>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Emmanuel Guiton <emmanuel@netlab.hut.fi>
In-Reply-To: <3FD7170C.2080404@netlab.hut.fi>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 10 Dec 2003, Emmanuel Guiton wrote:

> I was a bit reluctant to do this since I don't think it won't be useful 
> for any applications other than mine. I thought it was a waste.

Well.. extending the conntrack structure with the required information is 
a simple job, and can be done compile-time conditionally on if the feature 
is required or not.

Making other designs relating conntrack entries with custom data either 
requires abusing one of the existing fields and risk catastrophic results 
if there ever is a conflict with the originally intended use of these 
fields or by building an index outside of the conntrack table which is 
both complex and error prone.

The amount of information you need to extend the conntrack with is very 
small, just a identity of the counter used allowing your module to find 
which counter was used for this conntrack entry when it is destroyed. In 
the most simple implementation this is a pointer to your counter data, but 
it can be just an integer or a suitable size if you prefer. It is all 
dependent on how you want to identify the module specific data related to 
this specific conntrack entry.

Regards
Henrik
