From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: libipq and mark
Date: Sat, 11 Oct 2003 23:01:56 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0310112242280.14382-100000@filer.marasystems.com>
References: <1064665866.2289.33.camel@porky>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Eric Leblond <eric@regit.org>
In-Reply-To: <1064665866.2289.33.camel@porky>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, 27 Sep 2003, Eric Leblond wrote:

> Hi,
> 
> I like to know it it's possible to set the mark of a paquet in usermode
> using libipq ?

Not that I know of.

To extent libipq you need to extend the ip_queue communication channel
used to include the mark in the verdict messages (ipq_verdict_msg) and 
modify the libipq API to provide access to this new verdict field.

Then modify ip_queue.c ipq_mangle_ipv4 to copy the new mark from the 
verdict (also remember to look for mark modification in the routing part 
at the end of the same function).

Regards
Henrik
