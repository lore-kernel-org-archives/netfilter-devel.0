From: "Morten Isaksen" <misak@misak.dk>
Subject: Re: libnfnetlink_conntrack performance
Date: Wed, 23 May 2007 20:30:31 +0200
Message-ID: <7194302c0705231130h2938dc22sea8ca26126c52ed6@mail.gmail.com>
References: <7194302c0705221402k14bfe9eco7ecc98910eaa1c87@mail.gmail.com>
	<46543BC1.8090106@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: "Pablo Neira Ayuso" <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46543BC1.8090106@netfilter.org>
Content-Disposition: inline
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

Hi!

On 5/23/07, Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> One optimization that we can apply here is that libnetfilter_conntrack
> listen to update events even if you don't want to do it. These
> introduces an extra cost, of course. I have a patch somewhere to improve
> this, even I plan to introduce more fine grain events groups like
> protocol/state specific, eg. only listen to TCP syn_sent events.

I am very interested in this patch.

> > The events are collected in batches of 7 and then sent in an UDP
> > packet to a log server.
>
> Did you ever have a look at conntrackd? It is available in the
> conntrack-tools package that I'll release today. It has a statistics
> mode that still needs some work, this option that you have implemented
> could be quite interesting for it.

I looked at it briefly, but as far as I could tell it did not support
the log-part I am interested in, so I decided to write my own log
program (very much based on the conntrack_event program). Also from a
performance point of view I like the program as small as possible.

-- 
Morten Isaksen
http://www.misak.dk/blog/
