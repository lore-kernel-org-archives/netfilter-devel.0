From: Jay Schulist <jschulist@bivio.net>
Subject: Re: [PATCH] User defined udp and tcp conntrack state timeouts
Date: Wed, 18 Sep 2002 15:19:03 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0209181518150.5702-100000@beavis.networkrobots.com>
References: <20020918214534.GC10465@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jay Schulist <jschlst@linux-sna.org>, Harald Welte <laforge@gnumonks.org>,
   <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
In-Reply-To: <20020918214534.GC10465@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 18 Sep 2002, Patrick Schaaf wrote:

> Better avoid it in the first place, and convert internally, if it's
> not too much hassle. Isn't there a suitable sysctl helper for this
> situation? I vaguely remember something like that. Show seconds to
> the user, convert to internal format (eg. HZ) upon modification.
> 

good idea, there is a sysctl function to handle the jiffies conversion so 
it is quite easy to change.

jay-s.
