From: Ben Efros <ben@xgendev.com>
Subject: Re: RFC: Partial IP4 syntax
Date: Tue, 28 Sep 2004 20:56:19 -0700
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <415A3263.7080708@xgendev.com>
References: <415A12AE.1060901@parknet.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Simon Lodal <simonl@parknet.dk>
In-Reply-To: <415A12AE.1060901@parknet.dk>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Simon Lodal wrote:

> Examples:
> 10 = 10.0.0.0/8

<SNIP>

> Iknow IP address syntax should not change every day. But this will not 
> break or exclude old syntax. I do not see it clashing with 
> other/future syntax.

Wrong.  IP numbers can also be written in 32-bit unsigned notation.  In 
your first example:
10 being  10.0.0.0/8
10 is actually treated as unsigned 32bit int, meaning you're address is 
actually 0.0.0.10
Try this command and see for yourself:
"ping 5000"
Notice how ping is actually sending to "0.0.19.136" ?

This is done because 32-bit addresses should be representable as a 32bit 
number and not just as a string representation of the address for a 
variety of reasons.

Unfortunately your idea would break a LOT of very useful tools and ways 
of representing valid ip numbers.

Ben
