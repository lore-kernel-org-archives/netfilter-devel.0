From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2.6] Use C99 initializers for conntrack sysctl tables
Date: Fri, 20 Feb 2004 23:28:07 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <403689F7.5060404@trash.net>
References: <20040220210758.GV4797@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040220210758.GV4797@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Harald Welte wrote:
> Hi again, Dave!
> 
> I guess this needs no further comment.  Oh yes, it depends on the
> previous 2.6 resync patch I sent you.
> 
> Please apply, thanks
>

Hi Harald,

not sure if you're done yet, I just wanted to remind you of
the expect-evict-order fix in 2.6 pom, the 2.4 fix already got
submitted some time ago. Also I wanted to ask about your plans
to submit the 2.6 version of the owner-socketlookup patch. It
has had enough testing in 2.4 that I feel confident it won't
cause any problems.

Best regards,
Patrick
