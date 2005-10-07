From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH nfsim] tcpsession: implement the RESET command
Date: Sat, 08 Oct 2005 03:53:51 +1000
Message-ID: <1128707631.5611.0.camel@localhost.localdomain>
References: <20050922082404.GC21617@roonstrasse.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Max Kellermann <max@duempel.org>
In-Reply-To: <20050922082404.GC21617@roonstrasse.net>
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

On Thu, 2005-09-22 at 10:24 +0200, Max Kellermann wrote:
> Hi,
> 
> I implemented a RESET command for the tcpsession command.  It can be
> used to quickly purge TCP connections.

Hi Max!

	I applied this and your other tcpsession patch, working on 2.6.14
support now based on your initial patch now.

Thanks!
Rusty.
PS.  Please cc me directly on nfsim patches, so I don't miss them....
-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
